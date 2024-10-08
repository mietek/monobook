module HVM1.Run.Monad.bind where

open import Base.Pair.Pair
open import HVM1.Run.Run
open import HVM1.Run.State.State

-- Monadic bind for Run type
bind : ∀ {A B : Set} -> Run A -> (A -> Run B) -> Run B
bind ma fn state = do
  let (state , a) = ma state
  let (state , b) = fn a state
  (state , b)

-- Sequencing operator, discards the result of the first computation
seq : ∀ {A B : Set} -> Run A -> Run B -> Run B
seq p q = bind p (λ _ -> q)

-- Infix operator
_>>=_ :  ∀ {A B : Set} -> Run A -> (A -> Run B) -> Run B
_>>=_ = bind

_>>_ : ∀ {A B : Set} -> Run A -> Run B -> Run B
_>>_ = seq

infixl 1 _>>=_ _>>_
