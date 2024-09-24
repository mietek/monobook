module Base.V2.lerp where

open import Base.Float.Type
open import Base.V2.Type
open import Base.V2.add
open import Base.V2.mul-scalar
open import Base.V2.sub

-- Performs linear interpolation between two V2 vectors.
-- - v1: The starting V2 vector.
-- - v2: The ending V2 vector.
-- - t: The interpolation parameter (0.0 ≤ t ≤ 1.0).
-- = The interpolated V2 vector.
lerp : V2 -> V2 -> Float -> V2
lerp v1 v2 t = v1 + (mul-scalar (v2 - v1) t)
