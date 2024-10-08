module Base.Nat.to-bits where

open import Base.Bits.Bits
open import Base.Bool.if
open import Base.Nat.Nat
open import Base.Nat.div
open import Base.Nat.eq
open import Base.Nat.mod

-- Helper function for to_bits that handles the recursive case.
-- - n: The remaining part of the natural number to convert.
-- = The binary representation of the number as Bits.
{-# TERMINATING #-} -- FIXME!
to-bits-helper : Nat → Bits
to-bits-helper Zero = O E
to-bits-helper (Succ n) =
  let quotient = div (Succ n) 2
      remainder = mod (Succ n) 2
  in if (remainder == Zero)
     then O (to-bits-helper quotient)
     else I (to-bits-helper quotient)

-- Converts a natural number to its binary representation.
-- - n: The natural number to convert.
-- = The binary representation of the number as Bits.
to-bits : Nat → Bits
to-bits Zero = O E
to-bits (Succ n) = to-bits-helper (Succ n)
