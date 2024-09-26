module HVM2.Parser.Test.parse-term where

open import Base.Equal.Equal
open import Base.List.List
open import Base.Maybe.Maybe
open import Base.Parser.Reply
open import Base.Parser.State
open import Base.String.String
open import HVM2.Net.Net
open import HVM2.Parser.parse-term
open import HVM2.Redex.Redex
open import HVM2.Term.Term
open import Base.Result.Result

_ : parse-term (new-parser-state "*") ≡
  Done (MkReply
    (MkState "" 1)
    (Era)
  )
_ = refl

_ : parse-term (new-parser-state "x0") ≡
  Done (MkReply
    (MkState "" 2)
    (Var "x0")
  )
_ = refl

_ : parse-term (new-parser-state "(x0 x1)") ≡
  Done (MkReply
    (MkState "" 7)
    (Con (Var "x0") (Var "x1"))
  )
_ = refl
