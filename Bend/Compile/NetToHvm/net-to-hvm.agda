module Bend.Compile.NetToHvm.net-to-hvm where

open import Base.Result.Result
open import Base.Result.Monad.bind
open import Base.List.List
open import Base.Maybe.Maybe
open import Base.Maybe.to-result
open import Base.Nat.Nat
open import Base.Pair.Pair
open import Base.String.String
open import Bend.Net.Net renaming (Net to BNet)
open import Bend.Net.get-port
open import Bend.Net.net-root
open import HVM2.Net.Net renaming (Net to HNet)
open import HVM2.Redex.Redex
open import Bend.Compile.NetToHvm.get-redexes
open import Bend.Compile.NetToHvm.tree-to-hvm
open import Bend.Compile.NetToHvm.State.State
open import Bend.Compile.NetToHvm.State.new renaming (new to state-new)

-- Converts a Bend Net to an HVM Net.
-- - net: The Bend Net to convert.
-- = The converted HVM Net or an error message.
net-to-hvm : BNet -> Result HNet String
net-to-hvm net = do
  let redexes = get-redexes net
  let state = state-new (BNet.len net)
  root <- to-result (get-port net net-root) "no root"
  (root , state) <- var-or-subtree-to-hvm net root state
  rbag <- go redexes state
  Done (MkNet rbag root)

  where

  -- Helper function to process the list of redexes.
  -- - redexes: List of redex pairs to process.
  -- - state: Current compilation state.
  -- = The list of HVM Redexes or an error message.
  go : List (Pair Nat Nat) -> State -> Result (List Redex) String
  go [] state = Done []
  go ((a , b) :: redexes) state = do
    (a , state) <- tree-to-hvm net a state
    (b , state) <- tree-to-hvm net b state
    let redex = MkRedex a b
    redexes <- go redexes state
    Done (redex :: redexes)
