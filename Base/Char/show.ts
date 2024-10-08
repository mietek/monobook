import { Char } from '../../Base/Char/Char';
import { String } from '../../Base/String/String';
import { $append } from '../../Base/String/append';
import { $from_char } from '../../Base/String/from-char';

export const $show = (c: Char): String => {
  return $append("'", $append($from_char(c), "'"));
};

export const show = (c: Char) => $show(c);

// NOTE: For efficiency, we can use native string concatenation
export const $$show = (c: Char): String => `'${c}'`;