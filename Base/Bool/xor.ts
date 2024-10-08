import { Bool } from '../../Base/Bool/Bool';

// Performs logical XOR operation on two bools.
// - a: The 1st bool.
// - b: The 2nd bool.
// = True if a and b are different.
export const $$xor = (a: Bool, b: Bool): Bool => {
  if (a) {
    if (b) {
      return false;
    } else {
      return true;
    }
  } else {
    if (b) {
      return true;
    } else {
      return false;
    }
  }
};

// NOTE: Using native boolean XOR for efficiency.
export const $xor = (a: Bool, b: Bool): Bool => a !== b;
export const  xor = (a: Bool) => (b: Bool) => a !== b;

// NOTE: Operator omitted: '_^_'.
