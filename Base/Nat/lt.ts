import { Nat } from '../../Base/Nat/Type';
import { Bool, True, False } from '../../Base/Bool/Type';

export const $$lt = (x: Nat, y: Nat): Bool => {
  if (x === 0n) {
    if (y === 0n) {
      return False;
    } else {
      return True;
    }
  } else {
    var x_ = x - 1n;
    if (y === 0n) {
      return False;
    } else {
      var y_ = y - 1n;
      return $$lt(x_, y_);
    }
  }
};

// NOTE: Using native BigInt comparison for efficiency
export const $lt = (x: Nat, y: Nat): Bool => x < y;
export const  lt = (x: Nat) => (y: Nat) => x < y;

// NOTE: Operator omitted: '_<_'
