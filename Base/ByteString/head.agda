module Base.ByteString.head where

open import Base.Word8.Type
open import Base.ByteString.Type

postulate head : ByteString -> Word8

{-# FOREIGN GHC import qualified Data.ByteString as BS #-}
{-# COMPILE GHC head = BS.head #-}
