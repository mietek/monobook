module Bend.Compile.BendToNet.Encoder.link where

open import Base.Maybe.Type
open import Base.Maybe.bind
open import Bend.Compile.BendToNet.Encoder.Type
open import Bend.Net.link renaming (link to net-link)
open import Bend.Net.Port.Type

-- Links two ports in the Encoder's net
-- - enc: The current Encoder state
-- - a: The first Port to link
-- - b: The second Port to link
-- = The Encoder with the net updated or None on error
link : Encoder → Port → Port → Maybe Encoder
link enc a b = do
  let net = Encoder.net enc
  net ← net-link net a b
  Some (record enc { net = net })
