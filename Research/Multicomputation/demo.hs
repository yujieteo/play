module Main where

-- Basic Types and Type Aliases
type Name = String
type Age = Int

-- 1. Basic Function: Adds two integers
add :: Int -> Int -> Int
add x y = x + y

-- 2. Recursive Function: Factorial
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- 3. Higher-Order Function: Applies a function to two numbers
applyFunction :: (a -> b -> c) -> a -> b -> c
applyFunction f x y = f x y

-- 4. Pattern Matching: Determine if a number is positive, negative, or zero
sign :: Int -> String
sign n
  | n > 0 = "Positive"
  | n < 0 = "Negative"
  | otherwise = "Zero"

-- 5. List Comprehension: Filter and map over a list
evenSquares :: [Int] -> [Int]
evenSquares xs = [x * x | x <- xs, even x]

-- 6. Type Classes: Show and Eq
-- Show allows us to convert data into a string for printing
data Person = Person Name Age
  deriving (Show, Eq)

-- 7. Lazy Evaluation: Infinite list of Fibonacci numbers
fib :: [Int]
fib = 0 : 1 : zipWith (+) fib (tail fib)

-- 8. IO Operations: Printing and taking input
greet :: IO ()
greet = do
  putStrLn "What's your name?"
  name <- getLine
  putStrLn ("Hello, " ++ name ++ "!")

-- 9. Monad Example: Maybe Monad for safe operations
safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide x y = Just (x `div` y)

-- 10. Use of Fold (foldr)
sumList :: [Int] -> Int
sumList = foldr (+) 0

-- 11. Tuple usage: Return a pair
createPair :: a -> b -> (a, b)
createPair x y = (x, y)

-- 12. Modules: Importing the Prelude (done automatically)
-- Haskell has an automatic Prelude imported, which includes basic functionality
-- You could import specific modules like:
-- import Data.List
-- import Control.Monad

main :: IO ()
main = do
  -- 1. Basic addition
  putStrLn $ "5 + 3 = " ++ show (add 5 3)

  -- 2. Factorial of 5
  putStrLn $ "Factorial of 5 = " ++ show (factorial 5)

  -- 3. Higher-Order function: Applying 'add' function to two numbers
  putStrLn $ "Applying add to 5 and 3: " ++ show (applyFunction add 5 3)

  -- 4. Sign of a number
  putStrLn $ "Sign of -3 = " ++ sign (-3)

  -- 5. List comprehension: Even squares of numbers 1 through 10
  putStrLn $ "Even squares of [1..10]: " ++ show (evenSquares [1..10])

  -- 6. Type classes: Person data type with Eq and Show
  let p1 = Person "Alice" 30
      p2 = Person "Bob" 25
  putStrLn $ "Are Alice and Bob the same person? " ++ show (p1 == p2)

  -- 7. Lazy evaluation: First 10 Fibonacci numbers
  putStrLn $ "First 10 Fibonacci numbers: " ++ show (take 10 fib)

  -- 8. IO: Greeting the user
  greet

  -- 9. Safe division using Maybe monad
  let divResult = safeDivide 10 2
  putStrLn $ "10 / 2 = " ++ show divResult
  
  -- 10. Summing a list of numbers
  putStrLn $ "Sum of [1, 2, 3, 4, 5]: " ++ show (sumList [1, 2, 3, 4, 5])

  -- 11. Using a tuple
  let pair = createPair 10 "Ten"
  putStrLn $ "Created pair: " ++ show pair
