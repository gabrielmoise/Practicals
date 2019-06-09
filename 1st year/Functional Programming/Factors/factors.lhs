Author : Alex Tatomir, University of Oxford
Date : 18.10.2018
Practical 1 - Factoring Numbers
-----------------------------------

Practical 1: Factoring Numbers

Here is a simple method for finding the smallest prime factor of a positive
integer:

> factor :: Integer -> (Integer, Integer)
> factor n = factorFrom 2 n

> factorFrom :: Integer -> Integer -> (Integer, Integer)
> factorFrom m n | r == 0    = (m,q)
>                | otherwise = factorFrom (m+1) n
>    where (q,r) = n `divMod` m

for example

*Main> factor 7654321
(19,402859)

because 

*Main> 19 * 402859
7654321

Repeatedly extracting tyhe smallest factor will return a list
of prime factors:

> factors :: Integer -> [Integer]
> factors n = factorsFrom 2 n

> factorsFrom :: Integer -> Integer -> [Integer]
> factorsFrom m n | n == 1    = []
>                 | otherwise = p:factorsFrom p q
>    where (p,q) = factorFrom m n

for example

*Main> factor 123456789
(3,41152263)
*Main> factors 123456789
[3,3,3607,3803]

-- ^up^ The initial script ^up^ ----- 

Exercise 1
---------
"factor 1" will never stop because the remainder of any m >= 2 when dividing n = 1
will be 1 /= 0. 
On the other hand, "factor 0" will end immediately and return the result (2, 0). 
This is an exepected result because 0 is divisible by any other natural number.

Exercise 2
----------
*Main> factor 1
... Interrupted
*Main> factor 0
(2, 0)

Exercise 3
----------
Claim : The smallest factor of n >= 2 can not be greater that sqrt(n) and less than n.
Proof : Let d be the smallest factor of n, with n > d > sqrt(n).
Then, n = d * m, where (m = div n d). 'm' can not be less than d because this means that 
(i) m is a smaller prime number than d (Contradiction with the statement)
or (ii) m has a prime factor that is less than d (Contradiction)
Hence, sqrt(n) < d <= m. 
It is easy to observe that (d * m) > sqrt(n) * sqrt(n) = n (Impossible)
Thus, the initial assumption is false, proving that d <= sqrt(n).
One special case is when n is a prime number. In this case, d = n. 


> factor1 :: Integer -> (Integer, Integer)
> factor1 n = factorFrom1 2 n

> factorFrom1 :: Integer -> Integer -> (Integer, Integer)
> factorFrom1 m n | r == 0    = (m,q)
>                 | n <= m * m = (n, 1)                 
>                 | otherwise = factorFrom1 (m+1) n
>       where (q,r) = n `divMod` m

*Main> factor1 1000000007
(1000000007, 1)
(0.04 secs, 14,750,752 bytes)

*Main> factor1 (666013 * 666019)
(666013, 666019)
(0.50 secs, 309,109,040 bytes)

The order of guards matters because they are evaluated one by one in that order.
e.g. (n <= m * m) can not be placed after 'otherwise' because its effect would be cancelled
(n <= m * m) can not be placed before (r == 0) because we would lose the case when n is a 
square number
In the worst case, function factor1 will be called sqrt(n) times. After O(sqrt n) steps, it can
be concluded that n is a prime number or the smallest factor has been found. 

Exercise 4
----------

> factor2 :: Integer -> (Integer, Integer)
> factor2 n = factorFrom2 2 n

> factorFrom2 :: Integer -> Integer -> (Integer, Integer)
> factorFrom2 m n | r == 0    = (m,q)
>                 | q < m = (n, 1)                 
>                 | otherwise = factorFrom2 (m+1) n
>       where (q,r) = n `divMod` m

*Main> factor2 1000000007
(1000000007,1)
(0.04 secs, 12,979,512 bytes)
*Main> factor2 (666013 * 666019)
(666013,666019)
(0.50 secs, 271,810,696 bytes)

For any divisor m of n, q = n / m. Considering that m is the smallest factor,
q should be greater that m. If it is not, it means that q <= sqrt(n) <= m(*), 
an expression that defines the same condition as (n <= m * m)
(*) I proved in Exercise 3 that m and q can not be both > sqrt(n)
Similarly, m and q can not be both < sqrt(n) because their product would be
less than n (Impossible).
Hence, m must be less than or equal to q, in order to be the smallest factor of a
composite number.
Changing the guards from (n <= m * m) to (q < m) improves the efficiency because
we now use only values already computed, removing the multiplication of m by itself.

Exercise 5 
----------

> factor3 :: Integer -> (Integer, Integer)
> factor3 n  
>       | even n = (2, div n 2) -- check separately for 2
>       | otherwise = factorFrom3 3 n

> factorFrom3 :: Integer -> Integer -> (Integer, Integer)
> factorFrom3 m n | r == 0    = (m,q)
>                 | q < m = (n, 1)                 
>                 | otherwise = factorFrom3 (m+2) n
>       where (q,r) = n `divMod` m

This version of factor has half of the trial divisors from factor2 (except 2 which is
checked separately). Hence, this function is expected to run twice faster than factor2.

Exercise 6
----------

*Main> factor3 1000000007
(1000000007,1)
(0.02 secs, 6,528,592 bytes)
*Main> factor3 (666013 * 666019)
(666013,666019)
(0.28 secs, 135,945,776 bytes)
*Main> factor3 (9 * 17 * 19 * 27 * 613 * 11234)
(2,270254973069)
(0.01 secs, 78,192 bytes)


Exercise 7
----------

> factor4 :: Integer -> (Integer, Integer)
> factor4 n  
>       | even n = (2, div n 2) -- check 2 separately
>       | (mod n 3) == 0 = (3, div n 3)  -- check 3 separately
>       | otherwise = factorFrom4 5 n 2

> factorFrom4 :: Integer -> Integer -> Integer -> (Integer, Integer)
> factorFrom4 m n s | r == 0    = (m,q)
>                   | q < m = (n, 1)                 
>                   | otherwise = factorFrom4 (m + s) n (6 - s)
>       where (q,r) = n `divMod` m

*Main> factor4 (666013 * 666019)
(666013,666019)
(0.20 secs, 106,639,912 bytes)
*Main> factor4 1000000007
(1000000007,1)
(0.02 secs, 5,134,768 bytes)
*Main> factor4 (666013 * 17 * 666019 * 13)
(13,7540814308199)
(0.00 secs, 79,552 bytes)

Exercise 8
----------

Using only prime numbers as trial divisors would be perfect because all the other composite
divisors are useless. However, we need to know all the prime divisors (or generate them
efficiently) beforehand. This is impossible without preprocessing. 
Processing the list of prime numbers up to some limit is a good idea if we want to
factorize multiple numbers after that. 

Prime factorisation
------------------
*copied from the beggining of this script

factors :: Integer -> [Integer]
factors n = factorsFrom 2 n

factorsFrom :: Integer -> Integer -> [Integer]
factorsFrom m n | n == 1    = []
                | otherwise = p:factorsFrom p q
   where (p,q) = factorFrom m n

Exercise 9
---------

*Main> factors (666013 * 666019 * 17)
[17,666013,666019]
(0.33 secs, 239,847,000 bytes)
*Main> factors (9 * 4 * 17 * 17 * 17 * 92)
[2,2,2,2,3,3,17,17,17,23]
(0.00 secs, 98,096 bytes)
*Main> factors 71254898
[2,11,13,249143]
(0.14 secs, 89,768,824 bytes)


> factors2 :: Integer -> [Integer]
> factors2 n 
>       | even n = 2 : (factors2 (div n 2)) -- check 2 separately
>       | (mod n 3) == 0 = 3 : (factors2 (div n 3)) -- check 3 separately
>       | otherwise = factorsFrom2 5 n

> gets :: Integer -> Integer
> gets m 
>       | (mod m 3) == 2 = 2
>       | (mod m 3) == 1 = 4
>       | otherwise = error "gets m : m must not be a multiple of 3"

> factorsFrom2 :: Integer -> Integer -> [Integer]
> factorsFrom2 m n | n == 1    = []
>                  | otherwise = p:factorsFrom2 p q
>    where (p,q) = factorFrom4 m n (gets m) 

Function 'gets' computes the appropriate s according to the actual m.
We know that s must alternate 2, 4, 2, 4, ... but we do not know the next step, it can be 
2 or 4, depending on (mod m 3). 

*Main> factors2 (666013 * 666019 * 16 * 27 * 25)
[2,2,2,2,3,3,3,5,5,666013,666019]
(0.21 secs, 106,655,544 bytes)
*Main> factors2 (49)
[7,7]
(0.00 secs, 71,576 bytes)
*Main> factors2 (6)
[2,3]
(0.00 secs, 70,288 bytes)
*Main> factors2 (2)
[2]
(0.00 secs, 70,256 bytes)
*Main> factors2 (3^30)
[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
(0.01 secs, 128,608 bytes)

Exercise 10
----------
The test data can be found in the additional file "exercise10".
The answer to Jevon's problem is :
factor2 8616460799
(89681,96079)
(0.09 secs, 36,664,088 bytes)
taking about 0.10 seconds to compute it.

Optional Exercises
------------------

n odd = u * v, so both u and v must be odd
x = (u + v) / 2, (u + v) = (odd + odd) = even
y = (u - v) / 2, (u - v) = (odd - odd) = even
thus, x and y are whole numbers

Exercise 11
-----------
We know that x >= p and y >= q 
Also, r = p^2 - q^2 - n
(i) if r == 0 then (p, q) is the required pair
(ii) if r < 0 then we must increase p^2 - q^2
We can do this only by increasing p, because decreasing q is not possible.
(iii) if r > 0 then we must decrease p^2 - q^2
We can do this only by increasing q, because decreasing p is not possible.

This method surely terminates because it will finally find the pair (u, v) = (n, 1) with
(x, y) = ((n + 1) / 2, (n - 1) / 2).

Function search finds the pair (x, y) for some p, q, n given

> search :: Integer -> Integer -> Integer -> (Integer, Integer) 
> search p q n 
>       | r == 0 = (p, q)
>       | r < 0 = (search (p + 1) q n)
>       | r > 0 = (search p (q + 1) n)
>       where r = p * p - q * q - n
>
> fermat :: Integer -> (Integer, Integer)
> fermat n 
>       | even n = error "n is not odd"
>       | otherwise = (x + y, x - y)
>       where (x, y) = search 0 0 n 

*Main> fermat (666013 * 666019)
(666019,666013)
(0.58 secs, 341,080,008 bytes)
*Main> fermat 8616460799
(96079,89681)
(0.11 secs, 49,553,336 bytes)
*Main> fermat 1000000007
*too much time*

It looks like this procedure is very inefficient for prime numbers.

Exercise 12
----------
First of all, I will write the given function isqrt that computes the whole part of sqrt(n).

> isqrt :: Integer -> Integer
> isqrt = truncate . sqrt . fromInteger

It is easy to observe that x should be at least sqrt(n) to make sure that x^2 - y^2 has
any chance to be >= n.
The following function is faster than the initial one.

> fermat1 :: Integer -> (Integer, Integer)
> fermat1 n 
>       | even n = error "n is not odd"
>       | otherwise = (x + y, x - y)
>       where (x, y) = search (isqrt n) 0 n 

*Main> fermat1 (666013 * 666019)
(666019,666013)
(0.01 secs, 81,176 bytes)
*Main> fermat1 (8616460799)
(96079,89681)
(0.01 secs, 2,025,968 bytes)
*Main> fermat1 (1000000007)
*too much time*

Exercise 13
-----------

I used Jevon's number right above. One more time, the factors of 8616460799 are
*Main> fermat1 8616460799
(96079,89681)
(0.01 secs, 2,026,296  bytes)

*Main> fermat1 1963272347809
(8123471,241679)
(6.65 secs, 3,877,702,528 bytes)

Exercise 14
-----------

> search2 :: Integer -> Integer -> Integer -> Integer -> (Integer, Integer) 
> search2 p q n r
>       | r == 0 = (p, q)
>       | r < 0 = (search2 (p + 1) q n (r + 2 * p + 1))
>       | r > 0 = (search2 p (q + 1) n (r - 2 * q - 1)) 

>
> fermat2 :: Integer -> (Integer, Integer)
> fermat2 n 
>       | even n = error "n is not odd"
>       | otherwise = (x + y, x - y)
>       where aux = (isqrt n)
>             (x, y) = search2 aux 0 n (aux * aux - 0 * 0 - n) 

*Main> fermat2 8616460799
(96079,89681)
(0.01 secs, 1,972,720 bytes)
*Main> fermat2 (8616460799 * 13333)
(17846519,6437293)
(5.93 secs, 4,083,208,464 bytes)
*Main> fermat2 1963272347809
(8123471,241679)
(5.58 secs, 3,770,144,624 bytes)

A good comparison of function fermat# can be seen below
*Main> fermat2 (8616460799 * 13333)
(17846519,6437293)
(5.93 secs, 4,083,208,464 bytes)
*Main> fermat1 (8616460799 * 13333)
(17846519,6437293)
(6.95 secs, 4,197,257,808 bytes)
*Main> fermat (8616460799 * 13333)
(17846519,6437293)
(15.59 secs, 9,685,058,760 bytes)

Exercise 15
-----------

isqrt does not work properly for big numbers

*Main> isqrt (10^100)
99999999999999986860582406952576489172979654066176
(0.01 secs, 106,480 bytes)

The following function can be used as isqrt for big numbers.

> bigsqrt :: Integer -> Integer
> bigsqrt n = sqrtFrom 1 n
>
> sqrtFrom :: Integer -> Integer -> Integer
> sqrtFrom m n 
>       | m * m > n = m - 1
>       | otherwise = sqrtFrom (m + 1) n

*Main> bigsqrt (10^14)
10000000
(3.64 secs, 2,240,074,488 bytes) 

A more efficient way would be 

> fastsqrt :: Integer -> Integer
> fastsqrt n = sqrtstep 1 1 n
>
> square :: Integer -> Integer
> square x = x * x
>
> sqrtstep :: Integer -> Integer -> Integer -> Integer
> sqrtstep answer step target 
>       | step == 0 = answer
>       | square (answer + step) <= target = sqrtstep (answer + step) (step * 2) target
>       | otherwise = sqrtstep answer (div step 2) target

this version computes fastsqrt (10 ^ 20000) in 2.22 secs

The algorithm:
We try to add powers of 2 to the answer 1, 2, 4, 8, ... as long as its square does not exceed the target.
Afterwards, it is enough to check once again all powers in reversed order.
Complexity O(log (sqrt n)) = O(log n), without taking into account the cost of operations on big 
numbers.

(fastsqrt (2^105))^2 - 2^105
-7192236498376048
(0.01 secs, 161,888 bytes)

Exercise 16
-----------

> split :: (Integer, Integer) -> Integer -> (Integer, Integer)
> split (l, r) n 
>     | v1 > n = (l, mid - 1)
>     | v2 <= n = (mid + 1, r)
>     | otherwise = (mid, mid)
>     where mid = div (l + r) 2
>           v1 = mid * mid
>           v2 = v1 + 2 * mid + 1

*Main> split (1, 10) 25
(5,5)
(0.00 secs, 65,880 bytes)
*Main> split (1, 10) 36
(6,10)
(0.00 secs, 69,952 bytes)
*Main> split (1, 10) 49
(6,10)
(0.00 secs, 74,088 bytes)

Exercise 17
-----------

> isqrt2 :: Integer -> Integer 
> isqrt2 n = binary_search (1, n) n
>
> binary_search :: (Integer, Integer) -> Integer -> Integer
> binary_search (l, r) n 
>       | l == r = l
>       | otherwise = binary_search (split (l, r) n) n

*Main> (isqrt2 (10^20000))^2 - (10^20000) 
0
(2.83 secs, 1,494,607,744 bytes)

It is easy to observe that isqrt2 takes roughly (log n) operations
* (log n) represents the logarithm in base 2 of n

Exercise 18
-----------

> expected :: Integer -> Integer  -> Integer
> expected n m 
>       | m * m >= n = m
>       | otherwise = (expected n (2 * m))

> isqrt3 :: Integer -> Integer
> isqrt3 n = binary_search (1, expected n 1) n

Observation : we can use the same trick for the lower bound. It can be set to 
div (expected n 1) 2

*Main> (isqrt3 (10^20000))^2 - (10^20000)
0
(1.18 secs, 967,533,432 bytes)

*Main> (isqrt3 (2^105))^2 - 2^105
-7192236498376048
(0.01 secs, 142,832 bytes)

This function simulates (more or less) what I did before in function fastsqrt.
It takes :
log (sqrt n) = 1/2 * log (n) steps to find the expected value
log (sqrt n) = 1/2 * log (n) steps to find the real value
= log(n) steps to find the answers

Hence, it is not worth the extra effort, unless we take in consideration that the cost
for operations on big numbers is significantly reduced. 

A final comparison for "# (2^100000)"
fastsqrt - 3.74 secs
isqrt2 - 4.82
isqrt3 - 4.00

** time may vary depending on machine **
