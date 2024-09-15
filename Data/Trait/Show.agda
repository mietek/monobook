module Data.Trait.Show where

open import Agda.Primitive
open import Data.String.Type

record Show {a} (A : Set a) : Set (lsuc a) where
  field
    to-string  : A → String

open Show {{...}} public

show : ∀ {a} {A : Set a} {{showA : Show A}} → A → String
show {{showA}} x = to-string {{showA}} x