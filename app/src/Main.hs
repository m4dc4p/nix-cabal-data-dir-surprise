{-# Language CPP #-}
module Main where

import Library
#if INCLUDE_PATHS
import Paths_library
#endif

main = do
  foo "hello, world"
#if INCLUDE_PATHS
  getDataDir >>= foo
#endif
