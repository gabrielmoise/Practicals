Maze - Practical
Functional Programming
Alex Tatomir
MyMaze.lhs
----------------------

This is the module that defines Maze differently, using 4 lists of walls instead of one.

> module MyMaze (
>   Maze, 
>   makeMaze, -- :: Size -> [Wall] -> Maze
>   hasWall,  -- :: Maze -> Place -> Direction -> Bool
>   sizeOf    -- :: Maze -> Size
> )
> where

> import Geography

                           N       S       E       W

> data Maze = Maze Size [Place] [Place] [Place] [Place]

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
>  in Maze (x,y) nWalls sWalls eWalls wWalls

> reflect :: Wall -> Wall
> reflect ((i,j), d) = (move d (i,j), opposite d)

> hasWall :: Maze -> Place -> Direction -> Bool
> hasWall (Maze _ nWalls _ _ _) pos N = pos `elem` nWalls
> hasWall (Maze _ _ sWalls _ _) pos S = pos `elem` sWalls
> hasWall (Maze _ _ _ eWalls _) pos E = pos `elem` eWalls
> hasWall (Maze _ _ _ _ wWalls) pos W = pos `elem` wWalls

> sizeOf :: Maze -> Size
> sizeOf (Maze size _ _ _ _) = size
