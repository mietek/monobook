import { BinTree } from '../../Base/BinTree/BinTree';
import { Bool, $True } from '../../Base/Bool/Bool';
import { $and } from '../../Base/Bool/and';
import { Eq, $eq } from '../../Base/Trait/Eq';
import { $fold } from '../../Base/BinTree/fold';

// Checks if all values in a tree are equal.
// 1st: The equality function for type A.
// 2nd: The tree to check.
// = True if all values in the tree are equal, False otherwise.
export const $all_equal = <A>(eq_a: Eq<A>, t: BinTree<A>): Bool => {
  switch (t.$) {
    case 'Leaf':
      return $True;
    case 'Node':
      return $fold((y: A, le: Bool, re: Bool) => $and($and($eq(eq_a, t.val, y), le), re), $True, t);
  }
};

export const all_equal = <A>(eq_a: Eq<A>) => (t: BinTree<A>): Bool => $all_equal(eq_a, t);
