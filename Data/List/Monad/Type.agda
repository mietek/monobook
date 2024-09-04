module Data.List.Monad.Type where

open import Data.List.Type
open import Data.List.Monad.bind

-- Infix operator for bind
_>>=_ : ∀ {A B : Set} → List A → (A → List B) → List B
_>>=_ = bind

infixl 1 _>>=_
