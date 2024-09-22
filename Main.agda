module Main where

open import Base.ALL

loop : Nat -> IO Unit
loop i = do
  IO.print ("Hello " <> show i)
  loop (i + 1)

main : IO Unit
main = loop 0
