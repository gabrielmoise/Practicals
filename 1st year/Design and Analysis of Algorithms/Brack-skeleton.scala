/** Import is for readLine so that we can write input directly to the program */
import scala.io.StdIn

object Brack{
	//Maximum length of word so we can define our arrays in dynamic programming
	val MAXWORD = 850 // Changed to deal with bigger tests
    
	//Operation to take 'A', 'B' and 'C' to corresponding Ints
    def LetterToInt(a: Char) : Int = {
        if(a == 'A' || a == 'B' || a == 'C'){
			return (a.toInt - 'A'.toInt);
		} else{
			println("Please only Letters from A,B,C.")
			sys.exit
		}
	}
	
    //Defining the op array for everything to use
    val op = Array.ofDim[Int](3,3)  
    op(0)(0) = 1; op(0)(1) = 1; op(0)(2) = 0
	op(1)(0) = 2; op(1)(1) = 1; op(1)(2) = 0
	op(2)(0) = 0; op(2)(1) = 2; op(2)(2) = 2

    /** Read file into array (discarding the EOF character) */
    def readFile(fname: String) : Array[Char] = 
        scala.io.Source.fromFile(fname).toArray.init




 
    /* Functions below here need to be implemented */

    
	//TASK 1
	//PossibleRec checks whether bracketing to something is possible recursively
	//Checks whether w(i,j) can be bracketed to z

    // Post: returns true if and only if there is a bracketing of w[i, j) that results z
	def PossibleRec(w: Array[Int], i: Int, j: Int, z:Int): Boolean = {
	    if (i >= j) return false // empty interval
        if (i + 1 == j) return w(i) == z // singletone

        for (v1 <- 0 until 3) { // value of the first half
            for (v2 <- 0 until 3) { // value of the second half
                if (op(v1)(v2) == z) { // if they combine to z
                    for (k <- (i + 1) until j) // set the split point
                        if (PossibleRec(w, i, k, v1) && PossibleRec(w, k, j, v2))
                            return true // z can be resulted from [i, k) and [k, j)
                }
            }
        }
        false // no solution found
	} 

	
	//TASK 2
	//NumberRec which checks the ways you get a result recursively
	//Computes number of ways w(i,j) can be bracketed to get z

    // Post: returns the number of bracketings of w[i, j) that result into z
	def NumberRec(w: Array[Int], i: Int, j: Int, z:Int): Int = {
	    if (i >= j) return 0 // empty interval
        if (i + 1 == j) {
            if (w(i) == z) return 1; else return 0 // singletone
        }
        var count = 0 // no solution found yet
        for (v1 <- 0 until 3) { // value of the first half
            for (v2 <- 0 until 3) { // value the second half
                if (op(v1)(v2) == z) { // if they combine to z
                    for (k <- (i + 1) until j) // set the split point
                        count += NumberRec(w, i, k, v1) * NumberRec(w, k, j, v2) 
                        // a solution here is made out of any solution from the first half
                        // combined with any solution from the second half
                }
            }
        }

        count // return answer
	} 

	
	//TASK 3
    // Runtime analysis of recursive solution along with tests
	
    /** First of all, let's analyze the time comparison for diffrent strings:
      *
      *  String               Time/NumberRec           Time/PossibleRec
      *  4  ABBA                  0.720                     0.715
      *  5  ABBAC                 0.730                       -
      *  6  ABBACA                0.760                       -  
      *  7  ABBACAB               0.870                       -
      *  8  ABBACABA              1.280                       -
      *  9  ABBACABAC             1.590                       -
      *  10 ABBACABACA            4.000                     0.723
      *  11 ABBACABACAB          19.900                     0.735
      *
      *  Note that the time needed to run PossibleRec is a lot better that the time needed to run NumberRec.
      *  This happens because PossibleRec stops as soon as it finds a solution. Conversely, NumberRec has to compute how many solutions there are.
      *
      *  Another useful observations is that the time is lower bounded by 0.700 second which probably represents the memory access and JVM initialization. Thus, we can remove this value from all figures to have a better picture of the complexity.
      *  From one step to another, the times roughly triples(or even more). Let's have a look at T(n), the estimated complexity for an input of size n.
      * T(n) = sum(1 <= i < n)( 3* (T(i) + T(n - 1))) + n
      * T(n) = 6 * sum(1 <= i < n)(T(i)) + n
      *
      * Constant 3 comes from the need to interate through all possible combinations of the results of left and right bracketings. The final "n" comes from the iteration.
      *
      * Suppose that T(n) <= c * n * 7^n for a positive constant c and n up to some point (N - 1)
      * T(N) <= 6 * c * sum(1 <= i < N)(i * 7^i) + N
      * T(N) <= 6 * c * sum(i <= i < N)((N - 1) * 7^i) + N
      * T(N) <= 6 * c * (N - 1) * (7^N - 7) / 6 + N
      * T(N) <= c * (N - 1) * (7^N) + N
      * T(N) <= c * N * (7^N) + (N - c * 7^N)
      * T(N) <= c * N * (7^N)                    for a suitable constant.
      *
      * Thus, we can say that T(n) = O(n * 7^n) which can be observed also in the sample data.
      *
      * On the other hand, we can prove that T(n) = Omega(7^n).  
      * Suppose that T(n) >= c * 7^n for n < N
      * Then, T(N) >= 6 * c * sum(7^i) + n
      *       T(N) >= 6 * c * (7^N) / 6 + n
      *       T(N) >= c * (7^N)
      * So T(n) = Omega(7^n)
      * Therefore, T(n) is bounded by Omega(7^n) and O(n * 7^n). Actually, It can be simulated that T(n)/7^n -> constant so T(n) = BigTheta(7^n). 
      **/



	
	//You may find the following class useful for Task 7
	// Binary tree class
	abstract class BinaryTree
	case class Node (left : BinaryTree, right : BinaryTree) extends BinaryTree
	case class Leaf (value : Char) extends BinaryTree

	//Printing for a binary tree
	def print_tree(t : BinaryTree): Unit = {
	    t match {
            case Leaf(value: Char) => print(value) // just print the char
            case Node(left: BinaryTree, right: BinaryTree) => {
                print("(") // open bracket
                print_tree(left) // print left half
                print_tree(right) // print right half
                print(")")  // close bracket
            }
        }
	}

    def evaluate_tree(t: BinaryTree): Int = {
        t match {
            case Leaf(value: Char) => (value.toInt - 'A'.toInt) // evaluates to its own value
            case Node(left: BinaryTree, right: BinaryTree) => op(evaluate_tree(left))(evaluate_tree(right))
            // combine left half with right half
        }
    }

	//These arrays should hold the relevant data for dynamic programming
	var poss = Array.ofDim[Boolean](MAXWORD, MAXWORD, 3)
	var ways = Array.ofDim[Int](MAXWORD, MAXWORD, 3)
	var exp = Array.ofDim[BinaryTree](MAXWORD, MAXWORD, 3)


	//Task 4, 5, and 7(optional)
   
    // Post: poss, ways, exp are computed as required
	def Tabulate(w: Array[Int], n: Int): Unit = {
        var j = 0;

        /** Subproblem: Find values of poss, ways, exp for each [i, j), 0 <= i < j <= n
          * Optimal substructure:
          * - poss(i)(j)(v) only if exists v1, v2, k such that poss(i)(k)(v1) && poss(k)(j)(v2) && 0 <= i < j <= n && op(v1)(v2) == v
          * - each bracketing counted in ways(i)(j)(v) is uniquely counted in ways(i)(k)(v1) and ways(k)(j)(v2) for 0 <= i < j <= n && op(v1)(v2) == v
          * - exp(i)(j)(v) can be made of exp(i)(k)(v1) && exp(k)(j)(v2) with the same conditions as before.
          *
          * Briefly, any bracketing can be splitted into two halves that are bracketed independently.
          */

        // initialization
        for (i <- 0 until n) {
            for (j <- 0 until 3) {
                poss(i)(i + 1)(j) = false // assume that all are false
                ways(i)(i + 1)(j) = 0
            }
            poss(i)(i + 1)(w(i)) = true // set the only possibility to true
            ways(i)(i + 1)(w(i)) = 1
            exp(i)(i + 1)(w(i)) = Leaf((w(i) + 'A'.toInt).toChar) // generate Leaf
        }

        for (len <- 2 to n) { // iterate from small lengths to big lengths
            for (i <- 0 to n - len) { // choose interval begin
                j = i + len // find interval end
                
                for (k <- 0 until 3) { // initialize all with 0
                    poss(i)(j)(k) = false
                    ways(i)(j)(k) = 0
                }

                for (k <- i + 1 until j) { // set split point 
                    for (v1 <- 0 until 3) { // set first half value
                        for (v2 <- 0 until 3) { // set second half value
                            if (poss(i)(k)(v1) && poss(k)(j)(v2)) { // if possible to combine
                                poss(i)(j)(op(v1)(v2)) = true
                                exp(i)(j)(op(v1)(v2)) = Node(exp(i)(k)(v1), exp(k)(j)(v2))
                            }
                            // a combination of one bracketing way for the first half
                            // with one bracketing way for the second half
                            ways(i)(j)(op(v1)(v2)) += ways(i)(k)(v1) * ways(k)(j)(v2)
                        }
                    }
                }
            }
        }

	}

    
	//Task 6
	// Runtime analysis of dynamic programming version with tests
     
    /** One useful observation is that the number of possible bracketings (resulting A, B or C) is exactly the Catalan number. Thus, we have to find the moment when the Catalan number exceeds the limit of three Ints.  
      *  
      * For string ABBAABBAABBAABBAABBA of 20 character, the results are:
      * A: 676401522
      * B: 459691873
      * C: 631169795
      * total: 1767263190 still less than the upper bound of Ints
      *
      * For string ABBAABBAABBAABBAABBAA of 21 characters, the results are:
      * A: 1145233526
      * B: - too big -
      * C: 1242529772
      * expected total 6564120420 which expains why b could not be computed
      *
      * Thus, this dynammic programming can not give relevant result for all A, B and C, when the length of the word is more than 20 characters.
      *
      * Now, let's analyze the complexity:
      * We compute a (cubic) matrix of size n by n by 3, but
      * each cell (i, j, k) takes O(j - i) time to be computed
      * Thus, the total complexity is BigTheta(N^3) with a constant of 3/6 (approximatively)
      * 3 comes from the alphabet size
      * 1/6 comes from the numbers of triples 0 <= i < p < j <= n
      *
      * Unfortunately, all tests give answers after roughly 0.750 seconds so no difference can be observed for such small cases.
      * However, we can force some tests with length 400 and 800 to find a difference, even though the answer is not relevant 
      * word of 400 chars -> 6.84  seconds (without printing a solution)
      * word of 800 chars -> 31.00 seconds (without printing a solution)
      *
      * word of 400 chars -> 7.80  seconds (printing a solution)
      * word of 800 chars -> 42.00 seconds (printing a solution)
      *
      * for the length doubled, the time increased five-six times. However, it will increase roughly 8 times when the length goes to infinity.
      *
      *
      * Obviously, the dynamic programming version is a lot more efficient than the recursive one.
      * The recursive one works exponentially (Omega(7^n)) compared to polynomial (BigTheta(n^3)) time of dp.
      * Clearly, it is better to choose the dynamic programming method.
      **/

    //Task 7

    // You can find my implementation for print_tree about 100 lines above. There you can also find the modifications done to function Tabulate to also compute a possible solution. I implemented another function evaluate_tree that returns the result of a specific bracketing. If you scroll down, you will find an assert that ensures that the given solution to -Tabulate is valid.

// -> assert(evaluate_tree(exp(0)(len)(v)) == v) // extra safety


// Some interesting tests:

/*
Bracketing values for ABCABCAACBBCBACBBCAC
A can be achieved in 780688807 ways
For example:(((((((((((((((A(BC))A)B)C)A)(AC))B)B)(CB))(AC))B)B)C)A)C)
B can be achieved in 579447996 ways
For example:((((((((((((((A(BC))A)B)C)A)(AC))B)B)(CB))(AC))B)B)C)(AC))
C can be achieved in 407126387 ways
For example:((((((((((((((A(BC))A)B)C)A)(AC))B)B)(CB))A)(CB))(BC))A)C)

real	0m0.876s
user	0m2.436s
sys	0m0.156s
*/

/*
Bracketing values for BBBBBBBBBBBBBBBBBBBB
A cannot be achieved
B can be achieved in 1767263190 ways
For example:(((((((((((((((((((BB)B)B)B)B)B)B)B)B)B)B)B)B)B)B)B)B)B)B)
C cannot be achieved

real	0m0.883s
user	0m2.538s
sys	0m0.158s
*/

/*
Bracketing values for ABBBAACAACBACBACBACA
A can be achieved in 440550547 ways
For example:(((((((((((((A((BB)(BA)))A)C)A)A)(CB))A)(CB))(AC))B)A)C)A)
B can be achieved in 963450014 ways
For example:(((((((((((((A((BB)(BA)))A)C)A)A)(CB))A)(CB))A)(CB))A)C)A)
C can be achieved in 363262629 ways
For example:((((((((((((A((BB)(BA)))A)C)A)A)(CB))A)(CB))A)(CB))(AC))A)

real	0m0.894s
user	0m2.583s
sys	0m0.164s
*/

// And a small checker(run with -checker):
    
    def checker(){
        val data = Array[String]("ABACA", "BBBBA", "ABACAA", "BABBCAC", "CCCAB", "ACC", "ABACABAC",
                                 "AAAAAA", "BBBBBB", "CCCCCC", "CCCAAA", "BBBCCC", "ABCABC", "ABBBCC",
                                 "ACABACACBA", "ACCCBBACBA", "ABCBACBACC", "ABCCBAABCA", "CCCAAACCCB")
        for (ww <- data) {
            print("Now checking " + ww + " ")
            val w = ww.toArray.map(LetterToInt)
            val n = w.length
            
            Tabulate(w, n)
            print(ways(0)(n)(0) + " ")
            print(ways(0)(n)(1) + " ")
            print(ways(0)(n)(2) + " ")
            assert(NumberRec(w, 0, n, 0) == ways(0)(n)(0))
            assert(NumberRec(w, 0, n, 1) == ways(0)(n)(1))
            assert(NumberRec(w, 0, n, 2) == ways(0)(n)(2))
            println(" OK")
        }

        println("All tests passed")
    }

/** The main method just selects which piece of functionality to run */
  def main(args: Array[String]) = {

    // string to print if error occurs
    val errString = 
      "Usage: scala Brack -PossibleRec [file]\n"+
      "     | scala Brack -NumberRec [file]\n"+
      "     | scala Brack -Tabulate [file]\n"
		
		if (args.length > 2){
			println(errString)
			sys.exit
		}

    //Get the plaintext, either from the file whose name appears in position
    //pos, or from standard input
    def getPlain(pos: Int) = 
      if(args.length==pos+1) readFile(args(pos)) else StdIn.readLine.toArray

    // Check there are at least n arguments
    def checkNumArgs(n: Int) = if(args.length<n){println(errString); sys.exit}

    // Parse the arguments, and call the appropriate function
    checkNumArgs(1)
    val plain = getPlain(1)
    val command = args(0)

		//Making sure the letters are of the right type
		val len = plain.length
		var plainInt = new Array[Int](len)
		if (len > MAXWORD){
			println("Word Too Long! Change MAXWORD")
			sys.exit;
		} else {
    	for (i <- 0 until len){
				plainInt(i) = LetterToInt(plain(i))
			}
		}
		
		//Executing appropriate command
    if(command=="-PossibleRec"){
		println("Bracketing values for "+ plain.mkString(""))
		for(i<-0 to 2){
			if(PossibleRec(plainInt, 0, len, i)){
				println(('A'.toInt + i).toChar + " is Possible");
			}
			else{
				println(('A'.toInt + i).toChar + " is not Possible");
			}
		}
    }
    else if(command=="-NumberRec"){
		var z: Int = 0
		println("Bracketing values for "+ plain.mkString(""))
		for(i<-0 to 2){
			z = NumberRec(plainInt, 0, len, i)
			if(z == 1){
				printf(('A'.toInt + i).toChar+ " can be achieved in %d way\n", z)
			}
			else{
				printf(('A'.toInt + i).toChar+ " can be achieved in %d ways\n", z)
			}
		}
    }

    else if(command=="-Tabulate"){
		Tabulate(plainInt,len)
		println("Bracketing values for "+ plain.mkString(""))
		for(v<-0 to 2){
		var z: Int = ways(0)(len)(v)
			if(z==0){
			println(('A'.toInt + v).toChar+ " cannot be achieved")
			}
			else if(z==1){
				printf(('A'.toInt + v).toChar+ " can be achieved in %d way\n", z)
				printf("For example:")
				print_tree(exp(0)(len)(v))
				printf("\n")
            
                assert(evaluate_tree(exp(0)(len)(v)) == v) // extra safety
			}
			else if (z > 1){
				printf(('A'.toInt + v).toChar+ " can be achieved in %d ways\n", z)
				printf("For example:")
				print_tree(exp(0)(len)(v))
				printf("\n")
                
                assert(evaluate_tree(exp(0)(len)(v)) == v) // extra safety
			}
		}
    }   
    else if (command=="-checker") {
        checker()
    }
    else println(errString)
  }
}
