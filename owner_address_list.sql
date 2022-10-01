with
  agg as (
    with
      transfers as (
        (
          SELECT
            "to" as wallet,
            "tokenId" as token_id,
            'mint' as action,
            1 as value
          FROM
           erc721."ERC721_evt_Transfer"
          where
            contract_address = '\x33c6Eec1723B12c46732f7AB41398DE45641Fa42'
            and "from" = '\x0000000000000000000000000000000000000000'
        )
        union all
        (
          SELECT
            "to" as wallet,
            "tokenId" as token_id,
            'gain' as action,
            1 as value
          FROM
            erc721."ERC721_evt_Transfer"
          where
            contract_address = '\x33c6Eec1723B12c46732f7AB41398DE45641Fa42'
            and "from" != '\x0000000000000000000000000000000000000000'
        )
        union all
        (
          SELECT
            "from" as wallet,
            "tokenId" as token_id,
            'lose' as action,
            -1 as value
          FROM
            erc721."ERC721_evt_Transfer"
          where
            contract_address = '\x33c6Eec1723B12c46732f7AB41398DE45641Fa42'
            and "from" != '\x0000000000000000000000000000000000000000'
        )
      )
    select
      wallet,
      sum(value) as passes
    from
      transfers
    group by
      wallet
    order by
      passes desc
  )
select
  REPLACE(wallet::text,'\','0') as owners
          
from
  agg
where
  passes > 0
