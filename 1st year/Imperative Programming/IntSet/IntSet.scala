// A class of objects to represent a set
//
//
// Qustions:
//-->Do you use a dummy header node?
//   Yes, I use a dummy header node to make functions like find "easier" to code, even though it is useless for "union", "intersect" etc.
//
//-->Can your linked list store the same integer several times, or do you avoid repetitions?
//   I avoid repetitions by not adding the same element twice in the list. Attention is needed when implementing the optional questions. 
//
//-->Do you store the elements of the set in increasing order?
//   Yes. It makes it possible to do union, intersection and subsetOf in linear time. Almost all operations traverse all nodes in worst case so keeping data in incresing order can be done without any drawback. It brings only advantages.  
//
//-->Do you include anything else in your state, for efficiency?
//   I added another variable "set_size" which agrees with the length of set's linked list. It can be updated in constant time while executing operations and provides very useful necessary conditions for equals, subsetOf. Besides that, it makes operation "size" to run in constant time. 
//
//

// The companion object
object IntSet{
  /** The type of nodes defined in the linked list */
  private class Node(var datum: Int, var next: Node)

  /** Factory method for sets.
    * This will allow us to write, for example, IntSet(3,5,1) to
    * create a new set containing 3, 5, 1 -- once we have defined 
    * the main constructor and the add operation. 
    * post: returns res s.t. res.S = {x1, x2,...,xn}
    *       where xs = [x1, x2,...,xn ] */
  def apply(xs: Int*) : IntSet = {
    val s = new IntSet; for(x <- xs) s.add(x); s
  }
}


class IntSet{
  // State: S in P(Int) (where "P" represents power set)
  // Abs: S = toSet(theSet.next)
  // DTI: toSet(theSet.next) is in strictly increasing order
  //      && set_size == len(theSet.next)
  //
  // where
  //    toSet(null) = {}
  //    toSet(act) = act.datum:toSet(act.next)
  //
  //    len(act) = size of toSet(act)

  private type Node = IntSet.Node
  private def Node(datum: Int, next: Node) = new IntSet.Node(datum, next)
  private val inf = 1000000; // just a definition for the dummy node 

  // Init: S = {}
  private var theSet : Node = Node(-inf, null); // dummy head 
  private var set_size: Int = 0; // no element in set 

  /** Convert the set to a string. */
  // post: S = S0 && returns the string definition of the set
  override def toString : String = {
      var answer: String = "{"
      var first: Int = 1;
      var act: Node = theSet.next; 
      // invariant: answer keeps the answer for all nodes before act
      // variant: len(act) 
      while (act != null) { // I && something to add
          if (first == 0) answer = answer + ", "; // add comma
          first = 0; 
          answer = answer + act.datum.toString; // I for act.next
          act = act.next // I
      }
      // I && act == null so answer is complete
      answer + "}"
  }
  // Complexity: O(|S|)
  //

  // post: returns the Node before the one where the new node should be inserted
  //       && S = S0
  private def find(e:Int): Node = {
      var act: Node = theSet;
      // invariant: all nodes until here have datum < e
      // variant: len(act)
      while (act.next != null && act.next.datum < e)
          act = act.next // I
      act // next node is the appropriate place to insert e
  }
  // Complexity: O(|S|)


  /** Add element e to the set
    * Post: S = S_0 U {e} */
  def add(e: Int) = {
      var where = find(e); 
      if (where.next == null || where.next.datum != e) { 
          // e not in set
          set_size += 1
          val newNode = Node(e, where.next); // link to the next node
          where.next = newNode; // update link
      }
  }
  // Complexity: O(|S|)


  /** Length of the list
    * Post: S = S_0 && returns #S */
  def size : Int = set_size
  // Complexity: O(1)


  /** Does the set contain e?
    * Post: S = S_0 && returns (e in S) */
  def contains(e: Int) : Boolean = {
      var where = find(e)
      if (where.next != null && where.next.datum == e)
          return true
      return false
  }
  // Complexity: O(|S|)


  /** Pre: S != {}
    * Post: S = S_0 && returns e s.t. e smallest element in S */
  def any : Int = {
      require(set_size > 0) // precondition not satisfied => Error
      return theSet.next.datum
  }
  // Complexity: O(1)

  /** Does this equal that?
    * Post: S = S_0 && returns that.S = S */
  override def equals(that: Any) : Boolean = that match {
    case s: IntSet => {
        if (set_size != s.size) return false // sizes disagree
        toString == s.toString // resulting strings must be equal
        // considering that the sets are already sorted
    }
    case _ => false
  }
  // Complexity: O(|S| + |that|)
  

  /** Remove e from the set; result says whether e was in the set initially
    * Post S = S_0 - {e} && returns (e in S_0) */
  def remove(e: Int) : Boolean = {
      var where = find(e)
      if (where.next == null || where.next.datum != e)
          return false
      where.next = where.next.next
      set_size -= 1
      true
  }
  // Complexity: O(|S|)
    

  /** Test whether this is a subset of that.
    * Post S = S_0 && returns S subset-of that.S */
  def subsetOf(that: IntSet) : Boolean = {
      if (set_size > that.size) return false
      var act: Node = theSet.next
      var act2: Node = that.theSet.next
      // invariant: all nodes before act in this are in that
      // variant: len(act)
      while (act != null) {
          // invariant: all nodes before act2 in that are different than act
          // variant: len(act2)
          while (act2 != null && act2.datum != act.datum)
              act2 = act2.next
          if (act2 == null) return false
          act = act.next
          act2 = act2.next // I
      }
      true 
  }
  // Complexity: O(|S| + |that|)
  


  // ----- optional parts below here -----

  /** return union of this and that.  
    * Post: S = S_0 && returns res s.t. res.S = this U that.S */
  def union(that: IntSet) : IntSet = {
      var answer = new IntSet;
      var tail = answer.theSet

      var act: Node = theSet.next
      var act2: Node = that.theSet.next
      // invariant: answer keeps the reunion of
      //            * all nodes before act in this
      //            * all nodes before act2 in that
      // variant: len(act) + len(act2)
      while (act != null || act2 != null) {
          if (act == null) {
              tail.next = Node(act2.datum, null)
              tail = tail.next
              act2 = act2.next
          } else
          if (act2 == null) {
              tail.next = Node(act.datum, null);
              tail = tail.next
              act = act.next
          } else {
              if (act.datum == act2.datum)
                  act2 = act2.next
              if (act2 == null || act.datum < act2.datum) {
                  tail.next = Node(act.datum, null);
                  tail = tail.next
                  act = act.next
              } else {
                  tail.next = Node(act2.datum, null);
                  tail = tail.next
                  act2 = act2.next
              }
          }
          answer.set_size += 1
      }
      answer
  }
  // Complexity: O(|S| + |that|)


  /** return intersection of this and that.  
    * Post: S = S_0 && returns res s.t. res.S = this intersect that.S */
  def intersect(that: IntSet) : IntSet = {
      var answer = new IntSet;
      var tail = answer.theSet
      // invariant: answer keeps the intersection of
      //            * all nodes before act in this
      //            * all nodes before act2 in that
      // variant: len(act) + len(act2)

      var act: Node = theSet.next
      var act2: Node = that.theSet.next
      while (act != null && act2 != null) {
          if (act.datum < act2.datum) {
            act = act.next
          } else
          if (act.datum > act2.datum) {
            act2 = act2.next
          } else {
            tail.next = Node(act.datum, null)
            tail = tail.next
            act = act.next
            act2 = act2.next
            answer.set_size += 1
          }
      }
      answer
  }
  // Complexity: O(|S| + |that|)


  /** map
    * Post: S = S_0 && returns res s.t. res.S = {f(x) | x <- S} */
  def map(f: Int => Int) : IntSet = {
      var data = new Array[Int](set_size)
      var act = theSet.next
      // extract data from set into a vector and apply f
      for (i <- 0 until set_size) {
          data(i) = f(act.datum)
          act = act.next
      }
  
      // sort data
      data = data.sorted

      // add data to the set without any duplicates
      var answer = new IntSet
      var tail = answer.theSet
      for (i <- 0 until set_size) {
          if (i == 0 || data(i - 1) != data(i)) {
              tail.next = Node(data(i), null)
              tail = tail.next
              answer.set_size += 1
          }
      }

      answer       
  }
  // Complexity: O(|S| * log(|S|))


  /** filter
    * Post: S = S_0 && returns res s.t. res.S = {x | x <- S && p(x)} */
  def filter(p : Int => Boolean) : IntSet = {
      var answer = new IntSet
      var tail = answer.theSet
      var act = theSet.next
      // invariant: all nodes before act which satisfy p were added
      // variant: len(act)
      while (act != null) {
          if (p(act.datum)) {
              tail.next = Node(act.datum, null)
              tail = tail.next
              answer.set_size += 1
          }
          act = act.next
      }
      
      answer
  }
  // Complexity: O(|S|)
  
  // just a function from IntSet to Set
  def toSet(): scala.collection.mutable.HashSet[Int] = {
      var answer = new scala.collection.mutable.HashSet[Int]
      var act: Node = theSet.next
      while (act != null) {
          answer.add(act.datum)
          act = act.next
      }
      answer
  }
}
