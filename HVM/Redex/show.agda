module HVM.Redex.show where

import HVM.Term.show as Term
open import Data.String.Type
open import Data.String.append
open import HVM.Redex.Type

-- Converts a Redex to its string representation.
-- - redex: The Redex to convert.
-- = A string representation of the Redex.
show : Redex → String
show redex = Term.show (Redex.lft redex) ++ " ~ " ++ Term.show (Redex.rgt redex)
