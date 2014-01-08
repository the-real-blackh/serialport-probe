module System.Hardware.Serialport.Probe where

import Control.Applicative
import Control.Monad
import System.Directory
import System.FilePath
import System.Posix.Files

-- | Probe the system's serial ports.
--
-- Each pair consists of the device filename and a description string.
probeSerialPorts :: IO [(FilePath, String)]
probeSerialPorts = do
    exists <- doesDirectoryExist dir
    if exists then do
        links <- filterM (\f -> isSymbolicLink <$> getSymbolicLinkStatus (dir </> f))
                           =<< getDirectoryContents dir
        forM links $ \f -> (,) <$> readSym f
                               <*> pure f
      else
        return []
  where
    dir = "/dev/serial/by-id"
    readSym f = do
        dest <- readSymbolicLink (dir </> f)
        if isRelative dest
            then canonicalizePath $ dir </> dest 
            else return dest
