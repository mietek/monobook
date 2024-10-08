module Bend.Compile.BendToNet.Encoder.encode-term where

open import Base.Bits.Bits
open import Base.Function.case
open import Base.List.List
open import Base.Maybe.Maybe
open import Base.Maybe.to-result
open import Base.Pair.Pair
open import Base.String.String
open import Base.String.append
open import Base.Result.Result
open import Base.Result.Monad.bind
open import Bend.Fun.Pattern.Pattern using (Pattern)
open import Bend.Fun.Term.Term using (Term)
open import Bend.Net.Port.Port
open import Bend.Net.NodeKind.NodeKind using (NodeKind)
open import Bend.Net.NodeKind.from-fan-kind
open import Bend.Compile.BendToNet.Encoder.Encoder
open import Bend.Compile.BendToNet.Encoder.new-node
open import Bend.Compile.BendToNet.Encoder.link
open import Bend.Compile.BendToNet.Encoder.link-var
open import Bend.Compile.BendToNet.Encoder.encode-pat
open import Bend.Compile.BendToNet.Encoder.encode-num

-- Encodes a Term into the Encoder, linking the result to the given port
-- - enc: The current Encoder state
-- - term: The Term to be encoded
-- - up: The upstream Port to connect the encoded term to
-- = The Encoder with the nodes from the compiled term or None on error
encode-term : Encoder -> Term -> Port -> Result Encoder String

encode-term enc (Term.Var name) up = do
  enc <- to-result (link-var enc name up) "link var fail"
  Done enc

encode-term enc (Term.Link name) up = do
  enc <- to-result (link-var enc ("$" ++ name) up) "link unscoped fail"
  Done enc

encode-term enc (Term.Lam pat bod) up = do
  let (lam-idx , enc) = new-node NodeKind.Con enc
  enc <- to-result (link enc (MkPort lam-idx 0) up) "link lam fail"
  enc <- to-result (encode-pat enc pat (MkPort lam-idx 1)) "encode lam pat fail"
  enc <- encode-term enc bod (MkPort lam-idx 2)
  Done enc

encode-term enc (Term.Let pat val nxt) up = do
  let (fst , enc) = new-node NodeKind.Var enc
  let (snd , enc) = new-node NodeKind.Var enc
  enc <- to-result (encode-pat enc pat (MkPort fst 0)) "encode let pat fail"
  enc <- encode-term enc val (MkPort snd 0)
  enc <- to-result (link enc (MkPort fst 1) (MkPort snd 1)) "link let var fail"
  -- Port 2 of vars is unused (unary node)
  enc <- encode-term enc nxt up
  Done enc

encode-term enc (Term.App fun arg) up = do
  let (app-idx , enc) = new-node NodeKind.Con enc
  enc <- encode-term enc fun (MkPort app-idx 0)
  enc <- encode-term enc arg (MkPort app-idx 1)
  enc <- to-result (link enc (MkPort app-idx 2) up) "link app fail"
  Done enc

encode-term enc (Term.Fan kind args) up = do
  go enc (from-fan-kind kind) args up
  where
    go : Encoder -> NodeKind -> List Term -> Port -> Result Encoder String
    go enc kind [] up = Fail "fan empty"
    go enc kind (x :: []) up = encode-term enc x up
    go enc kind (x :: xs) up = do
      let (node , enc) = new-node kind enc
      enc <- to-result (link enc (MkPort node 0) up) "link fan fail"
      enc <- encode-term enc x (MkPort node 1)
      go enc kind xs (MkPort node 2)

encode-term enc (Term.Era) up = do
  let (era-idx , enc) = new-node NodeKind.Era enc
  enc <- to-result (link enc (MkPort era-idx 0) up) "link era fail"
  Done enc

encode-term enc (Term.Ref name) up = do
  let (ref-idx , enc) = new-node (NodeKind.Ref name) enc
  enc <- to-result (link enc (MkPort ref-idx 0) up) "link ref fail"
  Done enc

encode-term enc (Term.Num num) up = do
  let (num-idx , enc) = new-node (NodeKind.Num (encode-num num)) enc
  enc <- to-result (link enc (MkPort num-idx 0) up) "link num fail"
  Done enc

encode-term enc (Term.Swt None arg [] [] None (zero :: succ :: [])) up = do
  let (swt-node , enc) = new-node NodeKind.Swi enc
  let (con-node , enc) = new-node NodeKind.Con enc
  enc <- encode-term enc arg (MkPort swt-node 0)
  enc <- to-result (link enc (MkPort swt-node 1) (MkPort con-node 0)) "link swt con fail"
  enc <- to-result (link enc (MkPort swt-node 2) up) "link swt ret fail"
  enc <- encode-term enc zero (MkPort con-node 1)
  enc <- encode-term enc succ (MkPort con-node 2)
  Done enc

encode-term enc (Term.Swt _ _ _ _ _ _) up = do
  Fail "invalid switch in compile"

encode-term enc (Term.Oper _opr fst snd) up = do
  -- TODO: This is a placeholder while these values are not added to HVM
  let (node1 , enc) = new-node NodeKind.Opr enc
  let (node2 , enc) = new-node NodeKind.Opr enc
  let (opr   , enc) = new-node (NodeKind.Num E) enc
  enc <- to-result (link enc (MkPort node1 0) (MkPort opr 0)) "link oper opr fail"
  enc <- encode-term enc fst (MkPort node1 1)
  enc <- to-result (link enc (MkPort node1 2) (MkPort node2 0)) "link oper nodes fail"
  enc <- encode-term enc snd (MkPort node2 1)
  enc <- to-result (link enc (MkPort node2 2) up) "link oper ret fail"
  Done enc

-- These should have already been removed at this point of compilation
encode-term enc (Term.Str _)          up = Fail "str in compile"
encode-term enc (Term.List _)         up = Fail "list in compile"
encode-term enc (Term.With _ _)       up = Fail "with in compile"
encode-term enc (Term.Ask _ _ _)      up = Fail "ask in compile"
encode-term enc (Term.Use _ _ _)      up = Fail "use in compile"
encode-term enc (Term.Mat _ _ _ _ _)  up = Fail "mat in compile"
encode-term enc (Term.Fold _ _ _ _ _) up = Fail "fold in compile"
encode-term enc (Term.Bend _ _ _ _ _) up = Fail "bend in compile"
encode-term enc (Term.Open _ _ _)     up = Fail "open in compile"
encode-term enc (Term.Def _ _)        up = Fail "def in compile"
 