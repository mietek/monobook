module Base.Parser.take-while where

import Base.List.take-while as List
open import Base.Bool.Bool
open import Base.Char.Char
open import Base.List.List
open import Base.List.drop
open import Base.List.length
open import Base.Nat.Nat
open import Base.Nat.add
open import Base.Parser.Reply
open import Base.Parser.State
open import Base.Parser.Parser
open import Base.Result.Result
open import Base.String.String
open import Base.String.from-list
open import Base.String.to-list

-- Consumes characters from the input as long as they satisfy the given predicate.
-- - 1st: A function that takes a Char and returns a Bool, used as the predicate.
-- = A Parser that returns a String containing the consumed characters.
take-while : (Char -> Bool) -> Parser String
take-while pred = λ s -> do
  let input     = State.input s
  let chars     = to-list input
  let consumed  = List.take-while pred chars
  let result    = from-list consumed
  let count     = length consumed
  let new-index = add (State.index s) count
  let new-input = from-list (drop count chars)
  Done (MkReply (MkState new-input new-index) result)