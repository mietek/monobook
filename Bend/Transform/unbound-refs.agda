module Bend.Transform.unbound-refs where

open import Base.Bool.if
open import Base.List.List renaming (List to List')
open import Base.List.mfoldl
open import Base.Maybe.Maybe
open import Base.Result.Result
open import Base.Result.Trait.Monad
open import Base.String.String
open import Base.String.append
open import Base.Unit.Unit
open import Bend.Fun.Book.Book
open import Bend.Fun.Book.contains-def
open import Bend.Fun.Term.Term
open import Bend.Fun.Term.children
import Base.BitMap.values as BitMap
import Bend.Fun.FnDef.FnDef as FnDef'
import Bend.Fun.Rule.Rule as Rule'

private
  open module FnDef = FnDef' Term
  open module Rule = Rule' Term

unbound-refs-term : Book -> Term -> Result Unit String
unbound-refs-term book (Ref nam) =
  if (contains-def book nam)
  then Done unit
  else Fail ("Unbound reference '" ++ nam ++ "'")
unbound-refs-term book term = do
  mfoldl (λ _ child -> unbound-refs-term book child) unit (children term)

-- Main function to check unbound references in a book
unbound-refs : Book → Result Unit String
unbound-refs book = do
  let defs = BitMap.values (Book.defs book)
  mfoldl (λ _ def ->
    mfoldl (λ _ rule -> unbound-refs-term book (Rule.body rule)) unit (FnDef.rules def))
    unit defs
