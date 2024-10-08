import { Char } from '../../Base/Char/Char';
import { Bool } from '../../Base/Bool/Bool';

// Checks if a character is a digit.
// - c: The character to check.
// = True if the character is a digit, False otherwise.
export const $is_digit = (c: Char): Bool => {
  return /^\d$/.test(c);
};

export const is_digit = (c: Char) => $is_digit(c);

// NOTE: Using a regular expression to check if the character is a digit.
// This is equivalent to the primitive 'primIsDigit' in Agda.
