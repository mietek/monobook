import { Float } from '../../Base/Float/Type';
import { Maybe, $Some, $None } from '../../Base/Maybe/Type';
import { U64 } from '../../Base/U64/Type';

// Converts a float to its U64 representation.
// - x: The float to convert
// = The U64 representation of x, or nothing if conversion fails.
export const $to_u64 = (x: Float): Maybe<U64> => {
  if (x >= 0 && x <= 18446744073709551615 && Number.isInteger(x)) {
    return $Some(BigInt(x));
  } else {
    return $None;
  }
};

export const to_u64 = (x: Float) => $to_u64(x);

// NOTE: This implementation checks if the float is within the valid range for U64
// and is an integer before converting. It returns None for values outside this range
// or for non-integer values.
