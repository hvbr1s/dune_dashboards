select
  SUM("value" / 1e18)
from
  ethereum.transactions
where
  "to" = '\x33c6eec1723b12c46732f7ab41398de45641fa42'
