/** Imperative Programming Part 1 & 2
  * Alex Tatomir
  * Practical CodeBreaker 
  * 21 January 2019
  */


object Cipher{
  /** Bit-wise exclusive-or of two characters */
  def xor(a: Char, b: Char) : Char = (a.toInt ^ b.toInt).toChar

  /** Print ciphertext in octal */
  def showCipher(cipher: Array[Char]) =
    for(c <- cipher){ print(c/64); print(c%64/8); print(c%8); print(" ") }

  /** Read file into array */
  def readFile(fname: String) : Array[Char] = 
    scala.io.Source.fromFile(fname).toArray

  /** Read from stdin in a similar manner */
  def readStdin() = scala.io.Source.stdin.toArray

  /* ----- Functions below here need to be implemented ----- */








    /** Encrypt plain using key; can also be used for decryption */
    def encrypt(key: Array[Char], plain: Array[Char]) : Array[Char] = {
        val n = key.length
        val m = plain.length
        var result = new Array[Char](m)
        var i = 0

        // variant m - i
        while (i < m) { // I: result(i' < i) is a prefix of the encrypted message
            result(i) = xor(key(i % n), plain(i)) // result(i' <= i) is ~~
            i += 1 // I
        }
        // result(i' < m) is ~~
        result
    } 

    /** Try to decrypt ciphertext, using crib as a crib */
    def tryCrib(crib: Array[Char], ciphertext: Array[Char]) = {
        val n = crib.length
        val m = ciphertext.length
        var text = new Array[Char](n)
        var i, j, found = 0

        // finds the appropriate element when exceeding the array size  
        def get_pos(pos: Int, limit: Int, key_length: Int): Int = {
            var aux = pos
            if (aux >= limit) aux -= key_length
            aux
        }
                
        while (i + n - 1 < m) {
            j = 0
            // invariant n - j
            while (j < n) { // I: text(j' < j) is the guessed text
                text(j) = xor(crib(j), ciphertext(i + j))
                j += 1 //I
            }
            // computed our guess

            var key_length = find_length(text)
            if (key_length > 0) {
                val position = (key_length - (i % key_length)) % key_length
                var key = new Array[Char](key_length)

                j = 0
                // invariant key_length - j
                while (j < key_length) { // I: key(j' < j) is the quessed key
                    key(j) = text(get_pos(position + j, n, key_length))
                    j += 1
                }
                // found the entire key

                println(new String(key))
                println(new String(encrypt(key, ciphertext)))
                found += 1
            }

            i += 1
        }

        println("You found " + found + " possible solution(s).")
    } 

    /** Uses KMP to find the largest common prefix-suffix (=u) in the given text
      * The length of the key is test.length - u */
    def find_length(text: Array[Char]): Int = {
        val n = text.length
        var pref = new Array[Int](n + 1)
        var u, i = 2

        pref(0) = 0; pref(1) = 0; u = 0

        // variant n - i
        while (i <= n) { // I: found the largest common pref-suffix of text(i' < i)
            while (u != 0 && text(u) != text(i - 1)) u = pref(u) // try smaller pref/suffix
            if (text(u) == text(i - 1)) u += 1 // u must be +1
            pref(i) = u; i += 1 //I
        }
        // u is the common pref/suffix of text
        if (u < 2) 0 else n - u // give a solution only if u >= 2
    }

    /** The first optional statistical test, to guess the length of the key */
    val max_dif = 50
    def crackKeyLen(ciphertext: Array[Char]) = {
        val n = ciphertext.length
        var i, j, count = 1

        i = 1 // variant n - i
        while (i < n && i <= max_dif) { //I: printed data for all i' < i 
            count = 0

            j = 0 // variant n - j
            while (j < n) { // I: counted for all j' < j
                if (ciphertext(j) == ciphertext((j + i) % n)) 
                    count += 1
                j += 1 // I
            }

            println(i + ": " + count)
            i += 1 //I
        }
    } 

    /** The second optional statistical test, to guess characters of the key. */
    def crackKey(klen: Int, ciphertext: Array[Char]) = {
        val n = ciphertext.length 
        var i, j = klen 

        // variant n - i
        while (i < n) { // I: printed data for all i' < i multiple of klen
            j = 0 // variant n - j
            while (j < n) { // I': printed all data for j' < j
                if (ciphertext(j) == ciphertext((j + i) % n)) {
                    var ch = xor(ciphertext(j), ' ')
                    if (32 <= ch.toInt && ch.toInt <= 127) // only visible chars
                        println((j % klen) + " " + ch)
                }
                j += 1 // I'
            }

            i += klen //I
        }
    } 

    // The key for file "private1"
    // 012345678
    // PEMBERLEY

    // The key for file "private2"  
    // 01234567
    // HOGWARTS

    /** How to decode private:
      *  -crackKeyLen private
      *  -crackKey k private | sort -n | uniq -c | sort -n
      *  -decrypt key file */










/** The main method just selects which piece of functionality to run */
  def main(args: Array[String]) = {
    // string to print if error occurs
    val errString = 
      "Usage: scala Cipher (-encrypt|-decrypt) key [file]\n"+
      "     | scala Cipher -crib crib [file]\n"+
      "     | scala Cipher -crackKeyLen [file]\n"+
      "     | scala Cipher -crackKey len [file]"

    // Get the plaintext, either from the file whose name appears in position
    // pos, or from standard input
    def getPlain(pos: Int) = 
      if(args.length==pos+1) readFile(args(pos)) else readStdin

    // Check there are at least n arguments
    def checkNumArgs(n: Int) = if(args.length<n){println(errString); sys.exit}

    // Parse the arguments, and call the appropriate function
    checkNumArgs(1)
    val command = args(0)
    if(command=="-encrypt" || command=="-decrypt"){
      checkNumArgs(2); val key = args(1).toArray; val plain = getPlain(2)
      print(new String (encrypt(key,plain)))
    }
    else if(command=="-crib"){
      checkNumArgs(2); val key = args(1).toArray; val plain = getPlain(2)
      tryCrib(key, plain)
    }
    else if(command=="-crackKeyLen"){
      checkNumArgs(1); val plain = getPlain(1)
      crackKeyLen(plain)
    }      
    else if(command=="-crackKey"){
      checkNumArgs(2); val klen = args(1).toInt; val plain = getPlain(2)
      crackKey(klen, plain)
    }
    else println(errString)
  }
}
