import { Equal, $refl } from '../../Base/Equal/Equal';

// Symmetry property of equality.
// If x is equal to y, then y is equal to x.
// - x: The 1st value.
// - y: The 2nd value.
// - p: Proof that x is equal to y.
// = Proof that y is equal to x.
export const $sym = <A>(_x: A, _y: A, _p: Equal<A>): Equal<A> => $refl;
export const  sym = <A>(_x: A) => (_y: A) => (_p: Equal<A>): Equal<A> => $refl;