module Base.BitMap.union where

open import Base.BitMap.BitMap
open import Base.BitMap.set
open import Base.BitMap.to-list
open import Base.List.List
open import Base.List.foldr
open import Base.Pair.Pair

-- Performs a left-biased union of two Maps.
-- Values from the first BitMap take precedence over values from the second BitMap.
-- - m1: The 1st BitMap (takes priority on conflicts).
-- - m2: The 2nd BitMap.
-- = A new BitMap containing all key-value pairs from both input Maps,
--   with values from m1 taking precedence when keys conflict.
union : ∀ {A : Set} -> BitMap A -> BitMap A -> BitMap A
union m1 m2 = foldr (λ (k , v) acc -> set acc k v) m2 (to-list m1)
