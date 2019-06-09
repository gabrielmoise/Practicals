Maze - Practical
Functional Programming
Alex Tatomir
MyBinMaze.lhs
----------------------

This is the module that defines Maze differently, using 4 lists of walls instead of one.
Each list is stored as a binary search tree.

> module MyBinMaze (
>   Maze, 
>   makeMaze, -- :: Size -> [Wall] -> Maze
>   hasWall,  -- :: Maze -> Place -> Direction -> Bool
>   sizeOf    -- :: Maze -> Size
> )
> where

> import Data.List 
> import Geography

                             N            S            E            W

> data Maze = Maze Size (Tree Place) (Tree Place) (Tree Place) (Tree Place)

> makeMaze :: Size -> [Wall] -> Maze
> makeMaze (x,y) walls = 
>   let boundaries = -- the four boundaries
>         [((0,j),   W) | j <- [0..y-1]] ++ -- westerly boundary
>         [((x-1,j), E) | j <- [0..y-1]] ++ -- easterly boundary
>         [((i,0),   S) | i <- [0..x-1]] ++ -- southerly boundary
>         [((i,y-1), N) | i <- [0..x-1]]    -- northerly boundary
>       allWalls = walls ++ boundaries ++ map reflect (walls ++ boundaries)
>       nWalls = map fst $ filter ((== N).snd) allWalls
>       sWalls = map fst $ filter ((== S).snd) allWalls
>       eWalls = map fst $ filter ((== E).snd) allWalls
>       wWalls = map fst $ filter ((== W).snd) allWalls
>  in Maze (x,y) (get_tree nWalls) (get_tree sWalls) (get_tree eWalls) (get_tree wWalls)

> reflect :: Wall -> Wall
> reflect ((i,j), d) = (move d (i,j), opposite d)

> hasWall :: Maze -> Place -> Direction -> Bool
> hasWall (Maze _ nWalls _ _ _) pos N = pos `elemTree` nWalls
> hasWall (Maze _ _ sWalls _ _) pos S = pos `elemTree` sWalls
> hasWall (Maze _ _ _ eWalls _) pos E = pos `elemTree` eWalls
> hasWall (Maze _ _ _ _ wWalls) pos W = pos `elemTree` wWalls

> sizeOf :: Maze -> Size
> sizeOf (Maze size _ _ _ _) = size


--- Definitions of Binary Search Trees below ------

> data Tree a = Tree (Tree a) a (Tree a) | Empty 

> get_tree :: Ord a => [a] -> Tree a
> get_tree = build.sort

> build :: Ord a => [a] -> Tree a
> build [] = Empty
> build xs = Tree lSon midVal rSon
>          where len = length xs
>                mid = (len - 1) `div` 2
>                lSon = build (take mid xs)
>                rSon = build (drop (mid + 1) xs)
>                midVal = xs !! mid 

> elemTree :: Ord a => a -> Tree a -> Bool
> elemTree _ Empty = False
> elemTree x (Tree lSon here rSon)
>       | x == here = True
>       | x < here = elemTree x lSon
>       | otherwise = elemTree x rSon

In order to build a balanced binary search tree, we need to sort the values first and apply divide and conquer technique. At each step, we set the middle element as being the root and split the other elements in the left and right sons. 

Function elemTree is similar to standard function `elem`, but works on binary search trees.

