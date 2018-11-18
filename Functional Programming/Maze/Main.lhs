Maze - Practical
Functional Programming
Alex Tatomir
Main.lhs
----------------------

> import Geography
> import MyBinMaze
> import Generator

-> import MyMaze
-> import Maze
======================================================================

Draw a maze.

***************************************
*              Question 2             *
* Complete the definition of drawMaze *
***************************************

> drawMaze :: Maze -> IO()
> drawMaze maze = putStr(unlines result)
>       where result = reverse $ merge auxEW auxNS
>             auxEW = [drawEW maze i | i <- [0..m]] 
>             auxNS = [drawNS maze i | i <- [0..m - 1]]
>             (n, m) = sizeOf maze

> merge :: [a] -> [a] -> [a]
> merge (x:xs) ys = x:merge ys xs
> merge _ _ = []

> drawEW :: Maze -> Int -> String
> drawEW maze ln = concat aux ++ "+"
>       where aux = [if hasWall maze (i, ln) S then "+--" else "+  " | i <- [0..n - 1]]
>             (n, m) = sizeOf maze  

> drawNS :: Maze -> Int -> String
> drawNS maze ln = concat aux ++ "|"
>       where aux = [if hasWall maze (i, ln) W then "|  " else "   " | i <- [0..n - 1]]
>             (n, m) = sizeOf maze

Functions drawEW and drawNS help me draw different kinds of walls.
Function merge combines the two types of walls.

*Main> drawMaze smallMaze
+--+--+--+--+
|     |  |  |
+  +--+  +  +
|        |  |
+--+  +  +  +
|     |     |
+--+--+--+--+

*Main> drawMaze impossibleMaze
+--+--+--+
|     |  |
+  +  +--+
|  |     |
+  +--+  +
|        |
+--+--+--+

The drawing for the largeMaze can be seen later in this script.  

======================================================================

Solve the maze, giving a result of type:

> type Path = [Direction]

***************************************
*            Questions 3--4           *
*     Complete the definition of      *
*              solveMaze              *
***************************************

> solveMaze :: Maze -> Place -> Place -> Path
> solveMaze maze start target = solveMazeIter maze target [(start, [])]

> solveMazeIter :: Maze -> Place -> [(Place, Path)] -> Path
> solveMazeIter maze target (p:ps)
>       | fst p == target = snd p
>       | otherwise = solveMazeIter maze target $ ps ++ expand maze p
> solveMazeIter _ _ _ = error "can not move from here"

> expand :: Maze -> (Place, Path) -> [(Place, Path)]
> expand maze (p, pth) = try_move p pth N ++ 
>                        try_move p pth S ++
>                        try_move p pth E ++
>                        try_move p pth W
>       where try_move p pth dir = if hasWall maze p dir then [] else [(move dir p, pth ++ [dir])]  

Function expand takes a position with a path and returns all adjacent cell (with the corresponding path) that are accessible from this point. Try_move just checks if some position is reachable from the current point.

*Main> solveMaze smallMaze (0, 0) (3, 2)
[E,N,E,S,E,N,N]
(0.00 secs, 382,496 bytes)

*Main> solveMaze largeMaze (0, 0) (1, 4)
[N,N,N,E,S,S,S,E,N,N,N,N,W]
(0.45 secs, 1,146,795,456 bytes)

Now, let's improve these functions:

> solveMaze2 :: Maze -> Place -> Place -> Path
> solveMaze2 maze start target = fastSolveMazeIter maze target [(start, [])] []

> fastSolveMazeIter :: Maze -> Place -> [(Place, Path)] -> [Place] -> Path
> fastSolveMazeIter maze target (p:ps) vis
>       | fst p == target = snd p
>       | (fst p) `elem` vis = fastSolveMazeIter maze target ps vis
>       | otherwise = fastSolveMazeIter maze target (ps ++ expand maze p) (fst p:vis)
> fastSolveMazeIter _ _ _ _ = error "impossible maze for given start and target positions"

This version is very similar to the first one but has a polynomial complexity compared to an exponential one. The main difference is that we do not expand from a place already expanded before. 
Note that my function keeps in vis all cells already expanded, not the cells that we found a path for. This does not influence the complexity since any cell may be added at most 4 times in the 'queue' and considered only once as a valid candidate (first time).

*Main> solveMaze2 largeMaze (0, 0) (22, 21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.08 secs, 4,416,440 bytes)
*Main> solveMaze2 impossibleMaze (0, 0) (2, 2)
*** Exception: impossible maze for given start and target positions
CallStack (from HasCallStack):
  error, called at Main.lhs:85:31 in main:Main
*Main> solveMaze2 smallMaze (0, 0) (3, 2)
[E,N,E,S,E,N,N]
(0.00 secs, 120,008 bytes)
*Main> solveMaze2 emptyMaze (0, 0) (10, 10)
[N,N,N,N,N,N,N,N,N,N,E,E,E,E,E,E,E,E,E,E]
(0.01 secs, 710,408 bytes)



Exercise 5
----------

Now, I will change
-> import Maze
to 
-> import MyMaze
Below you can find some tests that show that all functions from this module still work on the new representation.

=====drawMaze=====

*Main> drawMaze smallMaze 
+--+--+--+--+
|     |  |  |
+  +--+  +  +
|        |  |
+--+  +  +  +
|     |     |
+--+--+--+--+

*Main> drawMaze impossibleMaze 
+--+--+--+
|     |  |
+  +  +--+
|  |     |
+  +--+  +
|        |
+--+--+--+

=====solveMaze=====

*Main> solveMaze smallMaze (0, 0) (3, 2)
[E,N,E,S,E,N,N]
(0.00 secs, 381,336 bytes)

=====solveMaze2=====

*Main> solveMaze2 smallMaze (0, 0) (3, 2)
[E,N,E,S,E,N,N]
(0.00 secs, 104,000 bytes)
*Main> solveMaze2 impossibleMaze (0, 0) (2, 2)
*** Exception: impossible maze for given start and target positions
CallStack (from HasCallStack):
  error, called at Main.lhs:110:31 in main:Main
*Main> solveMaze2 emptyMaze (0, 0) (10, 10)
[N,N,N,N,N,N,N,N,N,N,E,E,E,E,E,E,E,E,E,E]
(0.01 secs, 664,896 bytes)
*Main> solveMaze2 largeMaze (0, 0) (22, 21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.02 secs, 3,785,072 bytes)

As it can be observed, the largeMaze is solved 4 times faster now. (0.02 compared to 0.08 secs)

Another good comparison:
*Main> solveMaze2 largeEmptyMaze (0, 0) (100, 100)
--path removed-- solved with MyMaze
(1.25 secs, 187,526,424 bytes)

*Main> solveMaze2 largeEmptyMaze (0, 0) (100, 100)
--path removed-- solved with Maze
(1.86 secs, 189,147,192 bytes)



Optional Exercise 6
----------

Here are some drawings of my mazes. Their description can be found at the bottom of this file.



*Main> drawMaze tunnelMaze 
+--+--+--+--+--+--+--+--+--+--+--+
|                                |
+  +--+--+--+--+--+--+--+--+--+--+
|                                |
+--+--+--+--+--+--+--+--+--+--+  +
|                                |
+  +--+--+--+--+--+--+--+--+--+--+
|                                |
+--+--+--+--+--+--+--+--+--+--+  +
|                                |
+  +--+--+--+--+--+--+--+--+--+--+
|                                |
+--+--+--+--+--+--+--+--+--+--+  +
|                                |
+  +--+--+--+--+--+--+--+--+--+--+
|                                |
+--+--+--+--+--+--+--+--+--+--+  +
|                                |
+  +--+--+--+--+--+--+--+--+--+--+
|                                |
+--+--+--+--+--+--+--+--+--+--+  +
|                                |
+--+--+--+--+--+--+--+--+--+--+--+
(0.02 secs, 1,125,776 bytes)
*Main> solveMaze2 tunnelMaze (0, 0) (10, 10)
[E,E,E,E,E,E,E,E,E,E,N,W,W,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,E,N,W,W,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,E,N,W,W,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,E,N,W,W,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,E,N,W,W,W,W,W,W,W,W,W,W,N,E,E,E,E,E,E,E,E,E,E]
(0.01 secs, 985,488 bytes)



*Main> drawMaze loopMaze 
+--+--+--+--+--+--+
|                 |
+  +--+--+--+--+  +
|  |           |  |
+  +  +--+--+  +  +
|  |  |     |  |  |
+  +  +  +  +  +  +
|  |  |     |  |  |
+  +  +--+--+  +  +
|  |           |  |
+  +--+--+--+--+  +
|                 |
+--+--+--+--+--+--+
(0.00 secs, 347,480 bytes)
*Main> solveMaze2 loopMaze (0, 0) (5, 5)
[N,N,N,N,N,E,E,E,E,E]
(0.00 secs, 127,848 bytes)



*Main> drawMaze strangeMaze
+--+--+--+--+--+--+--+--+--+--+--+
|     |                    |     |
+--+  +--+--+  +  +--+--+  +--+  +
|              |  |              |
+--+  +  +--+--+--+--+  +  +--+  +
|     |                    |     |
+--+  +  +--+--+--+--+  +  +--+  +
|     |                    |     |
+--+  +--+--+  +  +--+--+  +--+  +
|              |  |              |
+--+  +  +--+--+--+--+  +  +--+  +
|     |                    |     |
+--+  +  +--+--+--+--+  +  +--+  +
|     |                    |     |
+--+  +--+--+  +  +--+--+  +--+  +
|              |  |              |
+--+  +  +--+--+--+--+  +  +--+  +
|     |                    |     |
+--+  +  +--+--+--+--+  +  +--+  +
|     |                    |     |
+--+  +--+--+  +  +--+--+  +--+  +
|              |  |              |
+--+--+--+--+--+--+--+--+--+--+--+
(0.02 secs, 1,226,728 bytes)
*Main> solveMaze2 strangeMaze (0, 0) (10, 10)
[E,N,N,N,N,N,N,E,E,E,N,E,E,E,N,N,E,E,E,N]
(0.01 secs, 553,456 bytes)


*Main> drawMaze strangeMaze2 
+--+--+--+--+--+--+--+--+--+--+--+
|  |     |  |  |  |  |  |        |
+  +  +  +  +  +--+--+  +  +--+--+
|  |  |  |  |  |                 |
+  +--+  +--+--+  +  +--+  +--+  +
|  |     |        |  |           |
+  +  +--+  +--+  +  +--+--+--+  +
|  |        |     |  |           |
+  +  +--+--+--+  +--+  +  +  +  +
|  |  |           |     |        |
+  +--+--+  +  +  +--+  +--+  +  +
|  |        |  |  |     |        |
+  +  +  +--+  +--+  +--+  +--+  +
|  |  |  |     |     |           |
+  +--+  +  +--+--+  +  +--+--+--+
|  |     |  |        |  |        |
+  +  +--+--+  +  +--+--+  +--+  +
|  |  |        |  |              |
+  +--+  +--+  +--+  +  +--+  +--+
|  |     |     |     |  |     |  |
+  +  +  +  +  +--+  +  +  +  +  +
|           |  |     |  |        |
+--+--+--+--+--+--+--+--+--+--+--+
(0.02 secs, 1,498,856 bytes)
*Main> solveMaze2 strangeMaze2 (0, 0) (10, 10)
[E,N,E,N,E,E,N,E,E,N,N,E,N,N,E,E,E,N,N,W,W,N,E,E]
(0.01 secs, 322,192 bytes)

Next two mazes are generated in a random way (see Generator.lhs for more details).

*Main> drawMaze smallRandomMaze 
+--+--+--+--+--+--+--+--+--+--+--+
|                    |           |
+  +  +--+--+--+--+  +  +--+--+  +
|  |  |           |  |     |     |
+--+  +  +--+  +--+  +--+--+  +--+
|     |     |              |     |
+  +--+--+--+--+--+--+--+  +  +  +
|     |     |        |  |  |  |  |
+  +  +  +  +  +--+  +  +  +  +  +
|  |     |        |  |     |  |  |
+  +--+--+--+--+--+  +  +--+--+  +
|  |        |        |        |  |
+--+  +--+  +  +--+--+--+--+  +  +
|     |  |     |     |        |  |
+  +--+  +--+--+  +--+  +--+--+  +
|     |     |           |        |
+  +  +--+  +  +--+--+--+--+--+  +
|  |  |     |  |              |  |
+  +  +  +--+  +  +--+  +--+  +  +
|  |  |     |  |     |  |     |  |
+--+  +  +  +  +--+--+  +  +--+  +
|     |  |              |        |
+--+--+--+--+--+--+--+--+--+--+--+

*Main> drawMaze largeRandomMaze 
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|     |        |     |     |           |                       |
+  +  +--+  +  +  +--+  +  +  +--+  +--+  +--+--+--+--+--+--+  +
|  |     |  |     |     |  |  |  |        |     |        |  |  |
+  +--+  +  +--+--+  +--+  +  +  +--+--+--+  +  +  +--+  +  +  +
|     |  |  |        |  |  |     |           |     |  |     |  |
+  +  +  +  +  +--+--+  +  +--+  +  +--+--+--+--+--+  +  +--+  +
|  |  |  |  |           |           |        |        |  |     |
+  +  +  +  +--+--+--+  +--+--+--+--+  +--+  +--+  +  +  +  +--+
|  |  |           |     |     |        |  |     |  |  |  |     |
+  +  +--+--+--+  +  +--+  +  +  +--+--+  +--+  +  +--+  +--+  +
|  |     |        |        |  |     |        |  |           |  |
+  +--+  +--+--+--+--+--+--+  +--+  +--+--+  +  +--+--+--+--+  +
|  |  |     |     |              |     |     |        |        |
+  +  +--+  +  +  +  +--+--+--+--+--+  +  +  +--+--+  +  +--+  +
|  |     |  |  |     |                 |  |        |  |     |  |
+  +--+  +  +  +--+--+  +--+--+--+--+--+  +--+  +--+  +  +  +  +
|        |           |  |                 |     |     |  |  |  |
+--+  +--+--+--+  +--+  +  +--+--+--+  +--+  +--+  +--+  +  +  +
|     |        |  |     |  |     |     |     |     |     |  |  |
+  +--+  +--+  +--+  +--+  +--+  +  +  +--+--+  +--+--+--+  +  +
|  |     |     |     |  |        |  |  |        |        |  |  |
+  +  +--+  +--+  +--+  +--+--+  +  +  +  +--+--+  +--+  +  +--+
|  |  |  |  |        |        |  |  |  |     |  |     |  |     |
+--+  +  +  +--+--+  +  +--+--+  +  +--+--+  +  +  +  +  +--+  +
|     |              |     |     |     |     |     |  |        |
+  +--+--+--+--+--+--+--+  +  +--+--+  +  +--+  +--+  +  +--+--+
|     |     |        |     |     |  |     |  |     |  |  |     |
+  +  +  +  +  +--+  +  +--+--+  +  +--+--+  +--+  +  +  +  +  +
|  |     |        |  |  |        |     |           |  |  |  |  |
+  +--+--+--+--+--+  +  +  +--+--+  +--+  +--+--+--+  +--+  +  +
|  |        |        |     |        |     |     |     |     |  |
+--+  +--+  +  +--+--+  +--+  +--+--+  +--+  +  +  +--+  +--+  +
|     |  |     |  |     |           |  |     |  |  |     |     |
+  +--+  +--+--+  +  +--+  +--+--+  +  +  +--+  +  +  +--+  +--+
|     |     |     |  |           |     |  |     |        |     |
+  +  +  +--+  +  +  +--+--+--+--+  +--+--+  +  +--+--+--+--+  +
|  |  |        |  |     |        |           |     |           |
+  +  +  +--+--+  +--+  +  +--+  +--+--+--+--+--+--+  +--+--+  +
|  |  |     |        |     |  |                    |  |     |  |
+--+  +--+  +  +--+--+--+--+  +--+--+--+--+--+--+  +  +  +  +  +
|     |     |                                         |  |     |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

Exercise 7
----------


Now, I will change
-> import MyMaze
to 
-> import MyBinMaze
Below you can find some tests that show that all functions from this module still work on the new representation.

=====drawMaze=====

*Main> drawMaze largeMaze
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                       |                 |  |     |     |           |
+  +--+--+--+--+--+--+  +  +  +--+--+--+  +  +  +  +  +  +  +--+--+--+
|                    |  |  |  |           |  |  |  |  |  |  |     |  |
+--+--+--+--+--+--+  +  +  +  +  +--+--+--+  +  +  +  +  +  +  +  +  +
|                    |  |  |  |  |           |  |  |  |     |  |  |  |
+  +--+--+--+--+--+--+  +  +  +  +  +--+--+  +  +  +  +--+--+  +  +  +
|        |           |  |  |  |  |  |        |  |  |           |  |  |
+--+--+  +  +--+--+--+  +--+  +  +  +  +--+--+--+  +--+--+--+  +  +  +
|     |  |           |        |     |  |        |     |        |  |  |
+  +  +  +--+--+--+  +--+--+--+--+--+  +  +  +  +--+  +  +--+--+  +  +
|  |  |     |     |  |                 |  |  |  |     |        |  |  |
+  +  +--+  +  +  +  +  +--+--+--+--+--+  +  +  +  +--+--+--+  +  +  +
|  |        |  |  |  |           |     |  |  |  |     |        |     |
+  +--+--+--+  +  +  +--+--+--+  +  +--+  +  +  +--+  +  +--+--+--+--+
|              |  |  |           |  |  |  |  |        |              |
+--+--+--+--+--+  +  +  +--+--+--+  +  +  +  +--+--+--+--+--+--+--+  +
|                 |     |           |  |  |                       |  |
+  +--+--+--+--+--+--+  +  +--+--+--+  +  +--+--+--+--+--+--+--+  +  +
|           |        |  |           |  |        |                 |  |
+--+--+--+  +--+--+  +  +--+--+--+  +  +--+--+  +  +--+--+--+--+--+  +
|           |     |  |     |     |  |  |     |  |                    |
+  +--+--+--+  +  +  +  +  +  +  +  +  +  +  +  +--+--+--+--+--+--+--+
|           |  |  |  |  |  |  |  |  |  |  |  |                       |
+--+--+--+  +  +  +  +  +  +  +  +  +  +  +  +  +--+--+--+--+--+--+  +
|           |  |  |  |  |  |  |  |  |  |  |     |     |     |     |  |
+  +--+--+--+  +  +  +  +  +  +  +  +  +  +--+--+--+  +  +  +  +  +  +
|  |     |     |     |  |     |  |  |  |           |  |  |  |  |     |
+  +  +  +  +  +--+--+--+--+--+  +  +  +--+--+--+  +  +  +  +  +--+--+
|  |  |  |  |        |           |  |           |  |     |     |     |
+  +  +  +  +--+--+  +  +--+--+--+  +--+--+--+  +  +--+--+--+--+  +  +
|  |  |  |  |     |  |           |     |     |  |  |              |  |
+  +  +  +  +  +  +  +--+--+--+  +  +  +  +  +  +  +  +--+--+--+--+  +
|  |  |     |  |  |  |           |  |  |  |  |  |        |     |     |
+  +  +--+  +  +  +  +  +--+--+--+--+  +  +  +  +--+--+  +  +  +  +--+
|  |     |  |  |  |  |              |  |  |  |           |  |  |     |
+  +--+  +  +  +  +--+--+--+--+--+  +  +  +  +--+--+--+  +  +  +--+  +
|     |  |  |  |           |     |  |     |              |  |        |
+  +  +  +  +  +--+--+--+  +  +  +  +--+--+--+--+--+--+--+  +--+--+--+
|  |  |  |  |  |           |  |  |                       |           |
+  +  +  +  +  +  +--+--+--+  +  +--+--+--+--+--+--+--+  +--+--+  +  +
|  |  |  |  |  |           |  |                       |           |  |
+  +  +  +  +--+--+--+--+  +  +--+--+--+--+--+--+--+--+--+--+--+--+  +
|  |     |                 |                                         |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
(0.03 secs, 6,432,248 bytes)

=====solveMaze=====

*Main> solveMaze smallMaze (0, 0) (3, 2)
[E,N,E,S,E,N,N]
(0.00 secs, 572,256 bytes)

=====solveMaze2=====

*Main> solveMaze2 largeMaze (0, 0) (22, 21)
[N,N,N,N,N,N,N,N,N,E,E,E,N,W,W,W,N,E,E,E,N,W,W,W,N,E,E,E,E,E,N,N,N,W,S,S,W,W,W,W,N,N,N,E,S,S,E,E,N,W,N,N,W,W,N,E,E,E,E,E,E,N,W,W,W,W,W,W,N,E,E,E,E,E,E,E,S,S,S,S,E,E,N,N,N,N,E,E,E,E,S,W,W,W,S,S,S,E,N,N,E,E,E,S,W,W,S,S,W,W,W,W,W,S,E,E,E,S,W,W,W,S,S,S,E,S,S,S,E,N,N,N,E,S,S,S,S,W,W,W,S,E,E,E,S,W,W,W,S,E,E,E,E,S,S,E,E,E,E,E,E,E,S,E,E,E,N,W,W,N,N,N,E,S,S,E,E,N,W,N,E,N,N,W,S,W,W,W,W,S,W,N,N,N,W,W,W,N,N,N,E,S,S,E,N,N,N,W,W,N,N,N,N,N,E,S,S,S,S,E,E,E,E,E,E,E,S,W,W,W,W,W,S,E,E,E,E,E,E,N,N,N,W,W,W,W,N,E,E,N,W,W,N,E,E,N,W,W,W,N,N,N,E,S,S,E,N,N,E,E,E]
(0.03 secs, 7,309,984 bytes)
*Main> solveMaze2 impossibleMaze (0, 0) (2, 2)
*** Exception: impossible maze for given start and target positions
CallStack (from HasCallStack):
  error, called at Main.lhs:111:31 in main:Main
*Main> solveMaze2 strangeMaze2 (0, 0) (10, 10)
[E,N,E,N,E,E,N,E,E,N,N,E,N,N,E,E,E,N,N,W,W,N,E,E]
(0.01 secs, 1,357,088 bytes)
*Main> solveMaze2 strangeMaze (0, 0) (10, 10)
[E,N,N,N,N,N,N,E,E,E,N,E,E,E,N,N,E,E,E,N]
(0.01 secs, 1,627,528 bytes)


In order to test the time efficiency, I designed a special maze called "strangeMaze3" which is described at the bottom of this script. It has a lot of walls and a size of (101, 101).
Time comparison:
Maze - 21.11 secs
MyMaze - 4.43 secs
MyBinMaze - 1.12 secs

I will paste the result for the latter one.
*Main> solveMaze2 strangeMaze3 (0, 0) (100, 100)
[N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,E,N,N,E,E,N,E,E,N,N,N,N,N,E,N,E,N,N,E,E,N,E,E,N,N,N,E,E,E,E,E,E,E,N,E,E,E,N,E,E,E,N,N,N,E,E,E,N,E,E,E,E,E,N,N,E,N,E,E,E,E,E,E,E,N,E,E,E,E,N,E,E,E,E,N,N,E,N,E,E,N,E,E,E,E,E,E,N,E,E,E,E,E,N,E,E,N,E,E,E,E,N,E,E,E,N,E,E,N,N,N,E,E,N,E,N,N,E,N,N,N,E,E,E,N,N,N,E,E,N,E,N,E,N,E,E,E,N,N,E,N,E,E,E,E,E,E,E,E,E,E,E,E]
(1.24 secs, 233,099,912 bytes)

======================================================================
-> checker

Final note: I checked my results with the following function:

> check :: Maze -> Place -> Place -> Path -> Bool
> check maze start target [] = start == target
> check maze start target (p:pth) 
>       | hasWall maze start p = False
>       | otherwise = check maze (move p start) target pth

> sol_smallMaze = solveMaze2 smallMaze (0, 0) (3, 2)
> sol_largeMaze = solveMaze2 largeMaze (0, 0) (22, 21)
> sol_largeEmptyMaze = solveMaze2 largeEmptyMaze (0, 0) (100, 100)
> sol_strangeMaze = solveMaze2 strangeMaze (0, 0) (10, 10)
> sol_strangeMaze2 = solveMaze2 strangeMaze2 (0, 0) (10, 10)
> sol_strangeMaze3 = solveMaze2 strangeMaze3 (0, 0) (100, 100)
> sol_tunnelMaze = solveMaze2 tunnelMaze (0, 0) (10, 10)

> chk_smallMaze = check smallMaze (0, 0) (3, 2) sol_smallMaze
> chk_largeMaze = check largeMaze (0, 0) (22, 21) sol_largeMaze
> chk_largeEmptyMaze = check largeEmptyMaze (0, 0) (100, 100) sol_largeEmptyMaze
> chk_strangeMaze = check strangeMaze (0, 0) (10, 10) sol_strangeMaze
> chk_strangeMaze2 = check strangeMaze2 (0, 0) (10, 10) sol_strangeMaze2
> chk_strangeMaze3 = check strangeMaze3 (0, 0) (100, 100) sol_strangeMaze3
> chk_tunnelMaze = check tunnelMaze (0, 0) (10, 10) sol_tunnelMaze

> check_results = [chk_smallMaze, chk_largeMaze, chk_largeEmptyMaze, 
>                  chk_strangeMaze, chk_strangeMaze2, chk_strangeMaze3,
>                  chk_tunnelMaze, chk_smallRandomMaze, chk_largeRandomMaze];

> all_fine = and check_results

======================================================================
-> random

And here is the way I use my maze generator (in file Generator.lhs).

> smallRandomMaze = makeMaze (11, 11) (generateRandomWalls 666013 11 11)
> largeRandomMaze = makeMaze (21, 21) (generateRandomWalls 666013 21 21)

> sol_smallRandomMaze = solveMaze2 smallRandomMaze (0, 0) (10, 10)
> sol_largeRandomMaze = solveMaze2 largeRandomMaze (0, 0) (20, 20)

> chk_smallRandomMaze = check smallRandomMaze (0, 0) (10, 10) sol_smallRandomMaze 
> chk_largeRandomMaze = check largeRandomMaze (0, 0) (20, 20) sol_largeRandomMaze 


======================================================================


Some test mazes.  In both cases, the task is to find a path from the bottom
left corner to the top right.

First a small one

> smallMaze :: Maze
> smallMaze = 
>   let walls = [((0,0), N), ((2,2), E), ((2,1),E), ((1,0),E), 
>                ((1,2), E), ((1,1), N)]
>   in makeMaze (4,3) walls

Now a large one.  Define a function to produce a run of walls:

> run (x,y) n E = [((x,y+i),E) | i <- [0..n-1]]
> run (x,y) n N = [((x+i,y),N) | i <- [0..n-1]]

And here is the maze.

> largeMaze :: Maze 
> largeMaze =
>   let walls = 
>         run (0,0) 3 E ++ run (1,1) 3 E ++ [((1,3),N)] ++ run (0,4) 5 E ++
>         run (2,0) 5 E ++ [((2,4),N)] ++ run (1,5) 3 E ++
>         run (1,8) 3 N ++ run (2,6) 3 E ++
>         run (3,1) 7 E ++ run (4,0) 4 N ++ run (4,1) 5 E ++ run (5,2) 3 N ++
>         run (4,6) 2 N ++ run (5,4) 3 E ++ run (6,3) 5 N ++ run (8,0) 4 E ++
>         run (6,1) 3 N ++ run (0,9) 3 N ++ run (1,10) 3 N ++ run (0,11) 3 N ++
>         run (1,12) 6 N ++ run (3,9) 4 E ++ run (4,11) 2 N ++
>         run (5,9) 3 E ++ run (4,8) 3 E ++ run (5,7) 5 N ++ run (6,4) 9 E ++
>         run (7,5) 3 N ++ run (8,4) 4 N ++ run (8,6) 3 N ++ run (10,5) 7 E ++
>         run (9,8) 3 E ++ run (8,9) 3 E ++ run (7,8) 3 E ++ run (8,11) 3 N ++
>         run (0,13) 5 N ++ run (4,14) 2 E ++ run (0,15) 2 E ++ 
>         run (1,14) 3 N ++ run (3,15) 2 E ++ run (0,17) 2 N ++ 
>         run (1,16) 2 E ++ run (2,15) 1 N ++ run (3,16) 3 N ++
>         run (2,17) 2 E ++ run (1,18) 6 N ++ run (4,17) 3 N ++ 
>         run (6,14) 7 E ++ run (5,13) 4 E ++ run (7,12) 2 E ++
>         run (8,13) 3 N ++ run (7,14) 3 N ++ run (10,14) 2 E ++
>         run (8,15) 5 N ++ run (7,16) 5 N ++ run (9,1) 2 E ++
>         run (10,0) 12 N ++ run (21,1) 1 E ++ run (10,2) 2 E ++
>         run (11,1) 7 N ++ run (17,1) 1 E ++ run (11,3) 3 E ++
>         run (12,2) 7 N ++ run (18,2) 2 E ++ run (19,1) 2 N ++
>         run (15,3) 3 N ++ run (14,4) 3 E ++ run (13,3) 3 E ++
>         run (12,4) 3 E ++ run (12,6) 3 N ++ run (11,7) 8 E ++ 
>         run (9,12) 3 N ++ run (12,14) 1 N ++ run (12,8) 10 E ++
>         run (0,19) 6 N ++ run (1,20) 6 N ++ run (7,18) 8 E ++
>         run (8,17) 1 N ++ run (8,18) 3 E ++ run (9,17) 4 E ++ 
>         run (10,18) 2 E ++ run (11,17) 2 E ++ run (10,20) 3 N ++
>         run (11,19) 3 N ++ run (12,18) 2 N ++ run (13,17) 2 N ++
>         run (13,13) 4 E ++ run (14,12) 7 N ++ run (13,11) 2 N ++
>         run (14,10) 2 E ++ run (13,9)2 E ++ run (14,8) 3 N ++ 
>         run (13,7) 3 N ++ run (15,5) 3 E ++ run (16,6) 3 E ++
>         run (18,5) 4 N ++ run (16,4) 2 N ++ run (13,20) 2 E ++
>         run (14,18) 4 E ++ run (20,2) 3 N ++ run (19,3) 2 E ++
>         run (18,4) 2 E ++ run (23,4) 1 E ++ run (22,4) 1 N ++
>         run (21,3) 1 N ++ run (20,4) 2 E ++ run (17,6) 4 N ++ 
>         run (20,7) 2 E ++ run (21,7) 2 N ++ run (21,6) 1 E ++ 
>         run (15,9) 1 E ++ run (17,8) 2 E ++ run (18,7) 2 E ++ 
>         run (19,8) 2 E ++ run (21,9) 1 E ++ run (16,9) 6 N ++
>         run (16,10) 7 N ++ run (15,11) 2 E ++ run (17,11) 5 N ++ 
>         run (14,14) 3 E ++ run (15,15) 6 E ++ run (17,14) 4 E ++
>         run (16,18) 4 E ++ run (15,17) 1 N ++ run (17,17) 3 N ++
>         run (15,13) 7 N ++ run (21,12) 2 E ++ run (16,16) 1 N ++
>         run (16,14) 1 N ++ run (17,15) 3 N ++ run (19,14) 4 N ++
>         run (20,15) 5 E ++ run (19,16) 2 N ++ run (21,16) 5 E ++
>         run (17,19) 2 E ++ run (18,20) 2 E ++ run (19,19) 2 E ++
>         run (18,18) 2 N ++ run (20,20) 3 N
>   in makeMaze (23,22) walls

And now an impossible maze

> impossibleMaze :: Maze
> impossibleMaze =
>   let walls = [((0,1), E), ((1,0),N), ((1,2), E), ((2,1), N)]
>   in makeMaze (3,3) walls

Now some other mazes defined by me

> emptyMaze :: Maze
> emptyMaze = makeMaze (11, 11) []

> largeEmptyMaze :: Maze
> largeEmptyMaze = makeMaze (101, 101) []

> tunnelMaze :: Maze
> tunnelMaze = 
>   let walls = 
>         concat [run (0, i) 10 N ++ run (1, i + 1) 10 N | i <- [0, 2 .. 10]]    
>   in makeMaze (11, 11) walls

> loopMaze :: Maze
> loopMaze = 
>   let walls =
>         run (1, 0) 4 N ++ run (1, 4) 4 N ++
>         run (0, 1) 4 E ++ run (4, 1) 4 E ++
>         run (1, 2) 2 E ++ run (3, 2) 2 E ++
>         run (2, 1) 2 N ++ run (2, 3) 2 N
>   in makeMaze (6, 6) walls 

> strangeMaze :: Maze
> strangeMaze = 
>   let walls = 
>         [getOne i j | i <- [0..10], j <- [0..10]] 
>
>   in makeMaze (11, 11) walls

> getOne :: Int -> Int -> Wall
> getOne x y 
>       | aux < 3 = ((x, y), N)
>       | aux < 6 = ((x, y), E)
>       | otherwise = ((0, 0), S)
>       where formula = x * x * 7 + x * y * 3 * y * y * y * x * 2
>             aux = mod formula 9


> strangeMaze2 :: Maze
> strangeMaze2 = 
>   let walls = 
>         [getTwo i j | i <- [0..10], j <- [0..10]] 
>
>   in makeMaze (11, 11) walls

> getTwo :: Int -> Int -> Wall
> getTwo x y 
>       | aux < 3 = ((x, y), N)
>       | aux < 6 = ((x, y), E)
>       | otherwise = ((0, 0), S)
>       where formula = (x^y) + x + (y^(x*x)*3) + x * x * 2 + y * y * y * 7 + 2
>             aux = mod formula 7


> strangeMaze3 :: Maze
> strangeMaze3 = 
>   let walls = 
>         [getThree i j | i <- [0..100], j <- [0..100]] 
>
>   in makeMaze (101, 101) walls


> getThree :: Int -> Int -> Wall
> getThree x y 
>       | aux < 3 = ((x, y), N)
>       | aux < 6 = ((x, y), E)
>       | otherwise = ((0, 0), S)
>       where formula = (x^y) + x + (y^(x*x)*3) + x * x * 2 + y * y * y * 7 + 2
>             aux = mod formula 9


