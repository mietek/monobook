module Imp.Eval.State.Thread.step where

import Base.Buffer.set as Buffer
import Base.List.foldl as List
import Base.Maybe.to-result as Maybe
import Imp.Eval.Env.pop as Env
import Imp.Eval.Env.push as Env
import Imp.Eval.Env.set as Env
open import Base.Function.case
open import Base.List.List
open import Base.Maybe.Maybe
open import Base.Pair.Pair
open import Base.Result.Monad.bind
open import Base.Result.Result
open import Base.String.String
open import Base.U64.from-nat
open import Base.U64.if
open import Base.U64.to-nat
open import Base.U64.U64
open import Imp.Eval.eval-expr
open import Imp.Eval.Frame.Frame
open import Imp.Eval.Memory.Memory
open import Imp.Eval.State.Thread.Thread
open import Imp.Expr.Expr
open import Imp.Stmt.Stmt

private
  StepResult = Result (Pair Memory (Maybe Thread)) String

  -- unwinds the stack of frames until a function call is found.
  -- returns the inner-most function in the stack of frames and
  -- the remaining frames, or an error if no function frame is found.
  unwind-fun : List Frame → Result (Pair (U64 → Stmt) (List Frame)) String

  unwind-fun []                = Fail "return outside of function"
  unwind-fun (Fun f :: frames) = Done (f , frames)
  unwind-fun (_ :: frames)     = unwind-fun frames

  -- unwinds the stack of frames until a loop is found.
  -- returns the inner-most loop in the stack of frames and
  -- the remaining frames, or an error if no loop frame is found.
  unwind-loop : List Frame → Result (Pair (Pair Expr Stmt) (List Frame)) String

  unwind-loop []                   = Fail "break/continue outside of loop"
  unwind-loop (Loop e b :: frames) = Done ((e , b) , frames)
  unwind-loop (_ :: frames)        = unwind-loop frames

-- Steps a thread in execution given global/shared memory, and the block id
-- that the thread is running under. The modified global/shared is returned.
-- A `Maybe Thread` is also returned in case there is more work to be done
-- by the thread.
{-# NON_TERMINATING #-}
step : Memory → (bid : U64) → (state : Thread) → StepResult

-- If we are at the end of a sequence of statements, and we are at the "root"
-- frame, then there is nothing more to execute, and this thread is finished.
step memory bid (MkThread tid vars None []) = Done (memory , None)

-- If we are at the end of a sequence of statements, and we are in a frame,
-- we pop that frame and continue execution.

-- If we were in a function but did not encounter a `return` statement,
-- then this function evaluates to 0.
-- TODO: perhaps an error should be raised here instead?
step memory bid (MkThread tid vars None ((Fun f) :: frames)) =
  Done (memory , Some (MkThread tid vars (Some (f (from-nat 0))) frames))

-- If we were in a loop, we evaluate the conditional expression.
-- We check the expression's value to determine if we execute
-- the loop body.
step memory bid (MkThread tid vars None ((Loop e b) :: frames)) = do
  (memory , value) ← eval-expr memory bid tid vars e
  if value then
      Done (memory , Some (MkThread tid vars (Some b) ((Loop e b) :: frames)))
    else
      Done (memory , Some (MkThread tid vars None frames))

-- Otherwise, we have some statement to execute.
step memory bid (MkThread tid vars (Some stmt) frames) with stmt

-- Declarations

... | (Locals vs) = do
  let vars = List.foldl (λ vars v → Env.set vars v (from-nat 0)) vars vs
  Done (memory , Some (MkThread tid vars None frames))

-- Local, Shared, and Global variable Assignments

... | (LSet v e) = do
  (memory , value) ← eval-expr memory bid tid vars e
  let vars = Env.set vars v value
  Done (memory , Some (MkThread tid vars None frames))

... | (SSet i v) = do
  (memory , i) ← eval-expr memory bid tid vars i
  (memory , v) ← eval-expr memory bid tid vars v
  shared ← Maybe.to-result (Buffer.set (Memory.shared memory) i v) "invalid access to shared memory"
  Done (record memory {shared = shared} , Some (MkThread tid vars None frames))

... | (GSet i v) = do
  (memory , i) ← eval-expr memory bid tid vars i
  (memory , v) ← eval-expr memory bid tid vars v
  global ← Maybe.to-result (Buffer.set (Memory.global memory) i v) "invalid access to global memory"
  Done (record memory {global = global} , Some (MkThread tid vars None frames))

-- Control flow

... | (If e t f) = do
  (memory , value) ← eval-expr memory bid tid vars e
  case (to-nat value) of λ where
    0 → Done (memory , Some (MkThread tid vars (Some f) frames))
    _ → Done (memory , Some (MkThread tid vars (Some t) frames))

... | (While e b) = do
  (memory , value) ← eval-expr memory bid tid vars e
  case (to-nat value) of λ where
    0 → Done (memory , Some (MkThread tid vars None     frames))
    _ → Done (memory , Some (MkThread tid vars (Some b) (Loop e b :: frames)))

... | (Ret e) = do
  (memory , value) ← eval-expr memory bid tid vars e
  (fun , frames) ← unwind-fun frames
  let
    vars = Env.pop vars
    e = fun value
  Done (memory , Some (MkThread tid vars (Some e) frames))

... | Cont = do
  ((e , b) , frames) ← unwind-loop frames
  Done (memory , Some (MkThread tid vars (Some (While e b)) frames))

... | Break = do
  (_ , frames) ← unwind-loop frames
  Done (memory , Some (MkThread tid vars None frames))

-- Monadic then (>>)
... | (Then a b) = do
  (memory , thread) ← step memory bid (MkThread tid vars (Some a) frames)
  case thread of λ where
    (Some (MkThread tid vars (Some stmt) frames)) → Done (memory , Some (MkThread tid vars (Some (Then stmt b)) frames))
    (Some (MkThread tid vars None        frames)) → Done (memory , Some (MkThread tid vars (Some b)             frames))
    -- this case is impossible since step only returns Done (_ , None) if `thread.stmt = None`.
    None                                          → Fail "Got None while stepping (Then a .)"

-- Executes an expression and drops the value
... | Ignore e = do
  (memory , _) ← eval-expr memory bid tid vars e
  Done (memory , Some (MkThread tid vars None frames))

-- Function Call
... | Call v b = do
  let
    vars   = Env.push vars
    frames = Fun (λ res → LSet v (Num res)) :: frames
  Done (memory , Some (MkThread tid vars (Some b) frames))
