module Data.List.count where

open import Data.List.Type
open import Data.Equal.Type
open import Data.Bool.if
open import Data.Nat.Type
open import Data.Nat.add
open import Data.Trait.Eq

count : ∀ {A : Set} {{eqA : Eq A}} → A → List A → Nat
count _ [] = Zero
count x (y :: ys) = (if x == y then 1 else 0) + count x ys