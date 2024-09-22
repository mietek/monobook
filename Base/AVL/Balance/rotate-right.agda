module Base.AVL.Balance.rotate-right where

open import Base.AVL.Type
open import Base.AVL.empty
open import Base.AVL.Balance.Type
open import Base.AVL.Balance.eq
open import Base.Pair.Type
open import Base.Bool.Type
open import Base.Bool.if

-- Performs a right rotation on an AVL tree to fix an imbalance of -2.
-- - tree: The AVL tree to rotate.
-- = A pair containing the rotated AVL tree and a boolean indicating if the height of the root stayed the same.
rotate-right : ∀ {K V : Set} → AVL K V → Pair (AVL K V) Bool
rotate-right (Node v1 -one (Node v2 -one ll lr) r)
  = Node v2 zero ll (Node v1 zero lr r) , False

rotate-right (Node v1 -one (Node v2 zero ll lr) r)
  = Node v2 +one ll (Node v1 -one lr r) , True

rotate-right
   (Node v1 -one
      (Node v2 +one ll
        (Node v3 balance
          lll
          llr))
      r)
  = do 
  let b1 = if balance == +one then -one else zero
  let b2 = if balance == -one then +one else zero 
  Node v3 zero
    (Node v2 b1 ll lll)
    (Node v1 b2 llr r)
    , False

-- Invalid call to `rotate-right`
rotate-right tree = tree , False
