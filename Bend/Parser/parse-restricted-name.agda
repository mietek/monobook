module Bend.Parser.parse-restricted-name where

open import Base.Char.Char
open import Base.Bool.Bool
open import Base.Bool.if
open import Base.String.String
open import Base.String.to-list
open import Base.String.from-list
open import Base.String.eq
open import Base.String.starts-with
open import Base.String.contains
open import Base.String.append
open import Base.Maybe.Maybe
open import Base.Unit.Unit
open import Base.Parser.Parser
open import Base.Parser.State
open import Base.Parser.consume
open import Base.Parser.fail
open import Base.Parser.Monad.bind
open import Base.Parser.Monad.pure
open import Base.Parser.take-while
open import Bend.Parser.is-name-char

-- Parses a restricted name.
-- - kind: The kind of name being parsed (e.g., "Datatype", "Variable").
-- = A parser that returns the parsed name if successful.
parse-restricted-name : String -> Parser String
parse-restricted-name kind = do
  name <- take-while is-name-char
  let res = if name == "" then 
              fail ("Expected " ++ kind ++ " name") 
            else if contains "__" name then 
              fail (kind ++ " names are not allowed to contain \"__\".")
            else if starts-with "//" name then 
              fail (kind ++ " names are not allowed to start with \"//\".")
            else 
              pure name
  res
