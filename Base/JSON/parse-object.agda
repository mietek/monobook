module Base.JSON.parse-object where

open import Base.JSON.JSON
open import Base.List.List
open import Base.Pair.Pair
open import Base.Parser.Parser
open import Base.Parser.Monad.bind
open import Base.Parser.consume
open import Base.Parser.Monad.pure
open import Base.Parser.skip-spaces
open import Base.Parser.alternative
open import Base.String.String
open import Base.JSON.parse-string

-- Parses a single key-value pair in a JSON object.
parse-pair : Parser JSON -> Parser (Pair String JSON)
parse-pair parseJSON = do
  skip-spaces
  key <- parse-string-value
  skip-spaces
  consume ":"
  value <- parseJSON
  pure (key , value)

-- Parses a list of key-value pairs in a JSON object.
{-# TERMINATING #-} -- FIXME!
parse-pairs : Parser JSON -> Parser (List (Pair String JSON))
parse-pairs parseJSON = parse-pair parseJSON >>= λ first ->
  (do
    skip-spaces
    consume ","
    rest <- parse-pairs parseJSON
    pure (first :: rest))
  <|> pure (first :: [])
  <|> pure []

-- Parses a JSON object.
-- - Skips leading whitespace.
-- - Consumes opening brace "{".
-- - Parses key-value pairs.
-- - Consumes closing brace "}".
-- - Returns a JObject JSON value.
parse-object : Parser JSON -> Parser JSON
parse-object parseJSON = do
  skip-spaces
  consume "{"
  pairs <- (do
    skip-spaces
    consume "}"
    pure [])
    <|> (do
      pairs <- parse-pairs parseJSON
      skip-spaces
      consume "}"
      pure pairs)
  pure (JObject pairs)

