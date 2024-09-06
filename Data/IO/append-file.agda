module Data.IO.append-file where

open import Data.String.Type
open import Data.IO.Type
open import Data.Unit.Type

postulate
  append-file  : String → String → IO Unit

{-# FOREIGN GHC import qualified Data.Text    as T   #-}
{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}

{-# COMPILE GHC append-file = TIO.appendFile . T.unpack #-}
{-# COMPILE JS append-file = function(path) { return function(content) { return function() { require('fs').appendFileSync(path, content); return {}; }; }; } #-}

