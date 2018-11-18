Maze - Practical
Functional Programming
Alex Tatomir
Generator.lhs
----------------------

> module Generator (generateRandomWalls) where

> import Geography

> generateRandomWalls :: Int -> Int -> Int -> [Wall]
> generateRandomWalls seed n m = removeWalls rm_walls (allWalls n m) 
>     where rm_walls = rm_walls_part ++ (map reflect rm_walls_part)
>           rm_walls_part = generate (Rnd seed) [(0, 0)] (boundary n m ++ [(0, 0)]) [] 

> removeWalls :: [Wall] -> [Wall] -> [Wall]
> removeWalls to_remove init = foldr removeWall init to_remove 

> removeWall :: Wall -> [Wall] -> [Wall]
> removeWall w [] = []
> removeWall w (x:xs) 
>       | x == w = removeWall w xs
>       | otherwise = x:removeWall w xs

> allWalls :: Int -> Int -> [Wall]
> allWalls n m = aux ++ (map reflect aux) 
>    where aux = [((i, j), N) | i <- [0..n], j <- [0..m]] ++
>                [((i, j), E) | i <- [0..n], j <- [0..m]]

> reflect :: Wall -> Wall
> reflect (p, d) = (move d p, opposite d)

> generate :: Rnd -> [Place] -> [Place] -> [Wall] -> [Wall]
> generate _ [] _ walls = walls
> generate r (p:ps) vis ans  
>       | null nxt = generate (getNext r) ps vis ans
>       | otherwise = generate (getNext r) (fst (head nxt):p:ps) (fst (head nxt):vis) (head nxt:ans)
>       where nxt :: [Wall]
>             nxt = chooseRandom r.filter (not.((`elem` vis).fst)).expand $ p

> boundary :: Int -> Int -> [Place]
> boundary n m = [(i, -1) | i <- [0..m - 1]] ++
>                [(i, m)  | i <- [0..m - 1]] ++
>                [(-1, i) | i <- [0..n - 1]] ++
>                [(n, i)  | i <- [0..n - 1]]

> expand :: Place -> [Wall]
> expand p = [(move N p, S), (move S p, N), (move E p, W), (move W p, E)]


-------------------------

> data Rnd = Rnd Int

> getVal :: Rnd -> Int
> getVal (Rnd x) = x

> getValLim :: Rnd -> Int -> Int
> getValLim (Rnd x) modo = mod x modo

> getNext :: Rnd -> Rnd
> getNext (Rnd x) = Rnd (mod (formula x) 1000000007)
>      where formula x = 13 * x * x * x + 19 * x * x + 173 * x + 23

> chooseRandom :: Rnd -> [a] -> [a]
> chooseRandom _ [] = []
> chooseRandom randVar xs = [xs !! pos]
>           where pos = getValLim randVar (length xs)



