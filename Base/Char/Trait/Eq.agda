module Base.Char.Trait.Eq where

open import Base.Char.Type
import Base.Char.eq as Char
import Base.Char.neq as Char
open import Base.Trait.Eq

instance
  EqChar : Eq Char
  EqChar = record
    { eq = Char.eq
    ; neq = Char.neq
    }
