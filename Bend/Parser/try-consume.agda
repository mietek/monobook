module Bend.Parser.try-consume where

open import Base.Parser.Type
open import Base.Parser.Monad.bind
open import Base.Parser.Monad.pure
open import Base.Parser.alternative
open import Bend.Parser.skip-trivia
open import Bend.Parser.consume-exactly
open import Base.Bool.Type
open import Base.String.Type

try-consume : String -> Parser Bool
try-consume target = do
  skip-trivia
  (consume-exactly target >> (pure True)) <|> (pure False)
