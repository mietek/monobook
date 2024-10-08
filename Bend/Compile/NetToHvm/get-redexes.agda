module Bend.Compile.NetToHvm.get-redexes where

open import Base.Bool.if
open import Base.List.List
open import Base.Pair.Pair
open import Base.BitMap.BitMap using (BitMap)
open import Base.BitMap.new renaming (new to map-new)
open import Base.BitMap.set renaming (set to map-set)
open import Base.BitMap.values renaming (values to map-values)
open import Base.BitMap.to-list
open import Base.Nat.Nat
open import Base.Nat.eq
open import Base.Nat.min
open import Base.Nat.to-bits
open import Base.Bits.Bits
open import Base.Bits.to-nat
open import Bend.Net.Net
open import Bend.Net.Node.Node
open import Bend.Net.Port.Port

-- Returns the redexes of the net as pairs of node indices
get-redexes : Net -> List (Pair Nat Nat)
get-redexes net =
  let redexes = check-nodes (to-list (Net.nodes net)) map-new in
  map-values redexes
  where

  -- Check each node in the net: if it's part of a redex, add it to
  -- the map, using the smaller node id as the key.
  check-nodes : List (Pair Bits Node) -> BitMap (Pair Nat Nat) -> BitMap (Pair Nat Nat)
  check-nodes [] map = map
  check-nodes ((key-a , node-a) :: nodes) map =
    let port-b = Node.main node-a in
    if (Port.slot-id port-b) == 0 then (
      -- A redex
      let key = to-bits (min (Port.node-id port-b) (to-nat key-a)) in
      let map = map-set map key (to-nat key-a , Port.node-id port-b) in
      check-nodes nodes map
    ) else
      -- Not a redex, continue
      check-nodes nodes map
