module Base.AVLTree.Test.has-key where

open import Base.AVLTree.AVLTree
open import Base.AVLTree.empty
open import Base.AVLTree.insert
open import Base.AVLTree.has-key
open import Base.Equal.Equal
open import Base.Bool.Bool
open import Base.Nat.Nat
open import Base.Nat.Trait.Ord
open import Base.Unit.Unit
open import Base.Pair.Pair

-- Sample AVL tree for testing
sample-tree : AVLTree Nat Unit
sample-tree = (5 , unit) ::> (3 , unit) ::> (7 , unit) ::> (1 , unit) ::> (4 , unit) ::> (6 , unit) ::> (8 , unit) ::> empty

-- Test 1: Empty tree
test-empty : has-key 5 (empty {V = Unit}) ≡ False
test-empty = refl

-- Test 2: Key present in root
test-root : has-key 5 sample-tree ≡ True
test-root = refl

-- Test 3: Key present in left subtree
test-left : has-key 3 sample-tree ≡ True
test-left = refl

-- Test 4: Key present in right subtree
test-right : has-key 7 sample-tree ≡ True
test-right = refl

-- Test 5: Key present in leftmost leaf
test-leftmost : has-key 1 sample-tree ≡ True
test-leftmost = refl

-- Test 6: Key present in rightmost leaf
test-rightmost : has-key 8 sample-tree ≡ True
test-rightmost = refl

-- Test 7: Key not present (less than all keys)
test-not-present-less : has-key 0 sample-tree ≡ False
test-not-present-less = refl

-- Test 8: Key not present (greater than all keys)
test-not-present-greater : has-key 9 sample-tree ≡ False
test-not-present-greater = refl

-- Test 9: Key not present (between existing keys)
test-not-present-between : has-key 2 sample-tree ≡ False
test-not-present-between = refl

-- Test 10: Single-element tree (key present)
test-single-present : has-key 1 ((1 , unit) ::> empty) ≡ True
test-single-present = refl

-- Test 11: Single-element tree (key not present)
test-single-not-present : has-key 2 ((1 , unit) ::> empty) ≡ False
test-single-not-present = refl
