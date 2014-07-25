module Paths_pandoc_types (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [1,12,4], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/suZe/Library/Haskell/ghc-7.6.3/lib/pandoc-types-1.12.4/bin"
libdir     = "/Users/suZe/Library/Haskell/ghc-7.6.3/lib/pandoc-types-1.12.4/lib"
datadir    = "/Users/suZe/Library/Haskell/ghc-7.6.3/lib/pandoc-types-1.12.4/share"
libexecdir = "/Users/suZe/Library/Haskell/ghc-7.6.3/lib/pandoc-types-1.12.4/libexec"
sysconfdir = "/Users/suZe/Library/Haskell/ghc-7.6.3/lib/pandoc-types-1.12.4/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "pandoc_types_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "pandoc_types_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "pandoc_types_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "pandoc_types_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "pandoc_types_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
