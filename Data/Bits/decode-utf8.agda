module Data.Bits.decode-utf8 where

open import Data.List.Type
open import Data.Char.Type
import Data.Char.from-nat as C
open import Data.String.Type
open import Data.String.from-list
open import Data.Bits.Type
open import Data.Bits.to-char
open import Data.Bits.split-chunks
open import Data.Bits.reverse
open import Data.Bits.append

-- The Unicode replacement character (U+FFFD) used for invalid sequences.
utf8-replacement-character : Char
utf8-replacement-character = C.from-nat 0xfffd

-- Decodes a UTF-8 encoded Bits representation into a String.
-- - bits: The input Bits representing a UTF-8 encoded string.
-- = The decoded String.
decode-utf8 : Bits → String
decode-utf8 bits = from-list (go (split-chunks 8 (reverse bits)))
  where
    -- Helper function to process the list of 8-bit chunks.
    -- - bits: List of 8-bit chunks to process.
    -- = List of decoded characters.
    go : List Bits → List Char
    go bits with bits
    -- End of string
    ... | [] = []
    -- 1-byte character (0xxxxxxx)
    ... | (O bits₁) :: rest
      = to-char (reverse bits₁) :: go rest
    -- 2-byte character (110xxxxx 10xxxxxx)
    ... | (I (I (O bits₁))) :: (I (O (bits₂))) :: rest
      = to-char (reverse bits₂ ++ reverse bits₁) :: go rest
    -- 3-byte character (1110xxxx 10xxxxxx 10xxxxxx)
    ... | (I (I (I (O bits₁)))) :: (I (O (bits₂))) :: (I (O bits₃)) :: rest
      = to-char (reverse bits₃ ++ reverse bits₂ ++ reverse bits₁) :: go rest
    -- 4-byte character (11110xxx 10xxxxxx 10xxxxxx 10xxxxxx)
    ... | (I (I (I (I (O bits₁))))) :: (I (O bits₂)) :: (I (O bits₃)) :: (I (O bits₄)) :: rest
      = to-char (reverse bits₄ ++ reverse bits₃ ++ reverse bits₂ ++ reverse bits₁) :: go rest
    -- Invalid sequence: replace with the replacement character
    ... | _ :: rest = utf8-replacement-character :: go rest
