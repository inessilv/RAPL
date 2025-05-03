import System.Environment (getArgs)
import Text.Read (readMaybe)

main :: IO ()
main = do
    args <- getArgs
    let n = case args of
                (x:_) -> maybe defaultN id (readMaybe x)
                []    -> defaultN
    print $ fib n
  where
    defaultN = 48  -- default value if no argument is provided

fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)
