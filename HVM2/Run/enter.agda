module HVM2.Run.enter where

open import Base.Function.case
open import Base.Maybe.Maybe
open import HVM2.Run.Run
open import HVM2.Run.Monad.bind
open import HVM2.Run.Monad.pure
open import HVM2.Run.subst-take
open import HVM2.Term.Term

-- Recursively enters variables until reaching a
-- non-var term or a variable with no substitution
enter : Term -> Run Term
enter (Var x) = do
  subst <- subst-take x
  case subst of λ where
    None        -> pure (Var x)
    (Some term) -> enter term
enter term = pure term
