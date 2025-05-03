-- medium.hs
module Medium where

import Data.List (foldl', sort)
import Control.Monad (forM_)

-- | A binary tree data structure.
data Tree a = Empty 
            | Node a (Tree a) (Tree a)
            deriving (Show, Eq)

-- | Insert a value into a binary search tree.
insert :: Ord a => a -> Tree a -> Tree a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
  | x < y     = Node y (insert x left) right
  | x > y     = Node y left (insert x right)
  | otherwise = Node x left right

-- | Build a tree from a list of elements.
buildTree :: Ord a => [a] -> Tree a
buildTree = foldl' (flip insert) Empty

-- | Check if a value exists in the tree.
contains :: Ord a => a -> Tree a -> Bool
contains _ Empty = False
contains x (Node y left right)
  | x < y     = contains x left
  | x > y     = contains x right
  | otherwise = True

-- | Convert a tree to a sorted list (in-order traversal).
toList :: Tree a -> [a]
toList Empty = []
toList (Node x left right) = toList left ++ [x] ++ toList right

-- | Find the maximum value in a tree.
findMax :: Ord a => Tree a -> Maybe a
findMax Empty = Nothing
findMax (Node x _ right) =
  case findMax right of
    Nothing -> Just x
    Just maxRight -> Just maxRight

-- | Calculate tree height.
height :: Tree a -> Int
height Empty = 0
height (Node _ left right) = 1 + max (height left) (height right)

-- | Example usage function.
example :: IO ()
example = do
  let numbers = [5, 3, 8, 1, 7, 9, 2, 6, 4]
      tree = buildTree numbers
  
  putStrLn "Original list:"
  print numbers
  
  putStrLn "\nTree structure:"
  print tree
  
  putStrLn "\nSorted list from tree:"
  print (toList tree)
  
  putStrLn "\nContains 7?"
  print (contains 7 tree)
  
  putStrLn "\nContains 10?"
  print (contains 10 tree)
  
  putStrLn "\nMaximum value:"
  print (findMax tree)
  
  putStrLn "\nTree height:"
  print (height tree)