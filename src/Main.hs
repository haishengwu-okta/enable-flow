module Main where

import System.Environment
import Control.Monad
import System.Directory
import System.FilePath.Posix
import qualified System.IO.Strict as S


main :: IO ()
main = do
  args <- getArgs
  case args of
    [x] -> enableFlowDir x
    _ -> error "Please specify an single directory"

enableFlowDir :: FilePath -> IO ()
enableFlowDir dir = do
  fullPath <- (</> dir) <$> getCurrentDirectory
  isDir <- doesDirectoryExist fullPath
  unless isDir (error $ fullPath ++ " is not an directory")
  allPaths <- map (fullPath </>) <$> listDirectory fullPath
  allFiles <- filterM doesFileExist allPaths
  allDirs <- filterM doesDirectoryExist allPaths
  mapM_ enableFlowFile allFiles
  mapM_ enableFlowDir allDirs

enableFlowFile :: FilePath -> IO ()
enableFlowFile file = do
  print ("Insert // @flow annotation for file: " ++ file)
  fileContent <- S.readFile file
  writeFile file ("// @flow\n" ++ fileContent)
