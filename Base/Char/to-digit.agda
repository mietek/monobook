module Base.Char.to-digit where

open import Base.Nat.Nat
open import Base.Char.Char
open import Base.Maybe.Maybe
open import Base.Char.is-digit
open import Base.Char.is-hex-digit
open import Base.Char.digit-to-nat
open import Base.Char.hex-to-nat
open import Base.Bool.Bool
open import Base.Bool.if
open import Base.Nat.eq
open import Base.Bool.and

-- Converts a single character to its numeric value in the given base
to-digit : Nat -> Char -> Maybe Nat
to-digit base c = 
  if is-digit c then
    digit-to-nat c
  else if (base == 16) && is-hex-digit c then
    hex-to-nat c
  else
    None
