module Base.IO.read-file where

open import Base.String.String
open import Base.IO.IO

-- Reads the contents of a file.
-- 1st: The path of the file to read.
-- = IO action that returns the contents of the file as a string.
postulate read-file : String -> IO String

{-# FOREIGN GHC import qualified Data.Text    as T   #-}
{-# FOREIGN GHC import qualified Data.Text.IO as TIO #-}
{-# FOREIGN GHC import qualified System.IO           #-}
{-# FOREIGN GHC import qualified Control.Exception   #-}
{-# FOREIGN GHC

  -- Reads a finite file. Raises an exception if the file path refers
  -- to a non-physical file (like "/dev/zero").
  readFiniteFile :: T.Text -> IO T.Text
  readFiniteFile f = do
    h <- System.IO.openFile (T.unpack f) System.IO.ReadMode
    Control.Exception.bracketOnError (return ()) (\_ -> System.IO.hClose h)
                                                 (\_ -> System.IO.hFileSize h)
    TIO.hGetContents h
#-}
{-# COMPILE GHC read-file   = readFiniteFile            #-}