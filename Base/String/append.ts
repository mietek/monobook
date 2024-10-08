import { String } from '../../Base/String/String';

// Concatenates two strings.
// - s1: The first string.
// - s2: The second string.
// = The concatenation of s1 and s2.
export const $$append = (s1: String, s2: String): String => {
  return s1 + s2;
};

// NOTE: Using native string concatenation for efficiency.
export const $append = (s1: String, s2: String): String => s1 + s2;
export const  append = (s1: String) => (s2: String) => s1 + s2;

// NOTE: Operator omitted: '_++_'.
