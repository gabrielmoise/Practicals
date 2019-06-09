Maze - Practical
Functional Programming
Alex Tatomir
Maze.lhs
----------------------

> module Maze (
>   Maze, 
>   makeMaze, -- :: Size -> [Wall] -> Maze
>   hasWall,  -- :: Maze -> Place -> Direction -> Bool
>   sizeOf    -- :: Maze -> Size
> )
> where

> import Geography

> data Maze = Maze Size [Wall]

> makeMaze :: Size -> [Wall] -> Maze
> makeMaze (x,y) walls = 
>   let boundaries = -- the four boundaries
>         [((0,j),   W) | j <- [0..y-1]] ++ -- westerly boundary
>         [((x-1,j), E) | j <- [0..y-1]] ++ -- easterly boundary
>         [((i,0),   S) | i <- [0..x-1]] ++ -- southerly boundary
>         [((i,y-1), N) | i <- [0..x-1]]    -- northerly boundary
>       allWalls = walls ++ boundaries ++ map reflect (walls ++ boundaries)
>  in Maze (x,y) allWalls

> reflect :: Wall -> Wall
> reflect ((i,j), d) = (move d (i,j), opposite d)

> hasWall :: Maze -> Place -> Direction -> Bool
> hasWall (Maze _ walls) pos d = (pos,d) `elem` walls

> sizeOf :: Maze -> Size
> sizeOf (Maze size _) = size
