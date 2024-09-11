module Bend.Compile.BendToNet.book-to-nets where

open import Data.Function.case
open import Data.List.Type
open import Data.List.head
open import Data.List.unzip
open import Data.Map.to-list renaming (to-list to map-to-list)
open import Data.Maybe.to-result
open import Data.Pair.Type
open import Data.Result.Type
open import Data.Result.bind
open import Data.String.Type
open import Data.String.append
open import Bend.Compile.BendToNet.Encoder.new renaming (new to new-encoder)
open import Bend.Compile.BendToNet.Encoder.encode-term
open import Bend.Compile.BendToNet.Encoder.Type
open import Bend.Fun.Book.Type using (Book)
open import Bend.Fun.Term.Type using (Term)
open import Bend.Net.Type using (Net)
open import Bend.Net.net-root
import Bend.Fun.FnDef.Type as FnDef'
import Bend.Fun.Rule.Type as Rule'

private
  open module FnDef = FnDef' Term
  open module Rule = Rule' Term

-- Converts all definitions in a book to a list of flat nets
book-to-nets : Book → Result (List Net) String
book-to-nets book =
  let (_ , defs) = unzip (map-to-list (Book.defs book)) in
  go defs
  where

  def-to-net : FnDef → Result Net String
  def-to-net (MkFnDef name type check rules src) = do
      rule ← to-result (head rules) ("No rules found for " ++ name)
      enc ← encode-term (new-encoder name) (Rule.body rule) net-root
      Done (Encoder.net enc)

  go : List FnDef → Result (List Net) String
  go [] = Done []
  go (def :: defs) = do
    net ← def-to-net def
    nets ← go defs
    (Done (net :: nets))
