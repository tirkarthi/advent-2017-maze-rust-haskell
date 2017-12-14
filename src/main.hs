{-# LANGUAGE ScopedTypeVariables, BangPatterns, GADTs, OverloadedStrings #-}
module Main (main) where

import           Control.Monad
import qualified Data.ByteString as S
import qualified Data.ByteString.Unsafe as B
import qualified Data.Vector.Unboxed.Mutable as MV
import           Formatting
import           Formatting.Clock
import           System.Clock

main :: IO ()
main = do
  start <- getTime Monotonic
  content <- S.readFile "xmas5.txt"
  end <- getTime Monotonic
  fprint ("reading file into bytestring took " % timeSpecs % "\n") start end

  start1 <- getTime Monotonic
  kay :: MV.IOVector Int <- MV.new 1058
  mapLinesM (\x line -> MV.write kay x (readInt line)) content
  end1 <- getTime Monotonic
  fprint ("parsing " % int % " lines took " % timeSpecs % "\n") (MV.length kay) start1 end1

  start2 <- getTime Monotonic
  let while !(counter::Int) !(ind::Int) = do
        if ind < fromIntegral (MV.length kay)
          then let i = fromIntegral ind
               in do curr <- MV.read kay i
                     MV.write
                       kay
                       i
                       (if curr >= 3
                          then curr - 1
                          else curr + 1)
                     while (counter + 1) (ind + curr)
          else pure counter
  !counter <- while 0 0
  end2 <- getTime Monotonic
  fprint (int % ", is the answer, it took " % timeSpecs % "\n") counter start2 end2

-- | This lines iterator is faster than iterating with @lines@. It
-- shaves off some time for reading the ints in.
mapLinesM :: (Int -> S.ByteString -> IO ()) -> S.ByteString -> IO ()
mapLinesM cons xs = go 0 xs
  where
    go !line str =
      case S.elemIndex 10 str of
        Nothing -> pure ()
        Just index -> do
          let sample = S.take index str
          unless (S.null sample) (cons line sample)
          go (line + 1) (S.drop (index+1) str)
{-# INLINE mapLinesM #-}

-- | Reading directly without returning a remainder or Maybe is
-- faster, also inlining. It shaves off time for reading ints.
readInt :: S.ByteString -> Int
readInt as
  | S.null as = 0
  | otherwise =
    case B.unsafeHead as of
      45 -> loop True 0 0 (B.unsafeTail as)
      43 -> loop False 0 0 (B.unsafeTail as)
      _ -> loop False 0 0 as
  where
    loop :: Bool -> Int -> Int -> S.ByteString -> Int
    loop neg !i !n !ps
      | S.null ps = end neg i n
      | otherwise =
        case B.unsafeHead ps of
          w
            | w >= 0x30 && w <= 0x39 ->
              loop
                neg
                (i + 1)
                (n * 10 + (fromIntegral w - 0x30))
                (B.unsafeTail ps)
            | otherwise -> end neg i n
    end _ 0 _ = 0
    end True _ n = negate n
    end _ _ n = n
{-# INLINE readInt #-}
