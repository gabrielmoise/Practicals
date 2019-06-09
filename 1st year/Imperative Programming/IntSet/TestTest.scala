/**  With Scala 2.12 on Lab machines:

 * In normal circumstances the CLASSPATH is already set for you:

fsc TestTest.scala
scala org.scalatest.run TestTest

 * If you use jar files in your own space:

fsc -cp ./scalatest_2.12-3.0.5.jar:./scalactic_2.12-3.0.5.jar TestTest.scala
scala -cp ./scalatest_2.12-3.0.5.jar:./scalactic_2.12-3.0.5.jar org.scalatest.run TestTest

 * (Once this is working you can set your CLASSPATH in .bashrc) 
*/
import org.scalatest.FunSuite


class TestTest extends FunSuite{
  
  test("toString") {
      var set = IntSet(5, 7, 13, 2, 5, 13);
      assert(set.toString == "{2, 5, 7, 13}")
      set.add(5)
      assert(set.toString == "{2, 5, 7, 13}")
      set.remove(5)
      assert(set.toString == "{2, 7, 13}")
  }

  test("add && size") {
      var set = new IntSet
      assert(set.toString == "{}")
      assert(set.size == 0)
      set.add(13);
      assert(set.size == 1)
      set.add(9);
      assert(set.size == 2)
      assert(set.toString == "{9, 13}")
      set.add(19);
      assert(set.size == 3)
      set.add(9);
      assert(set.size == 3)
      assert(set.toString == "{9, 13, 19}")
  }
  
  test("contains && remove && any") {
      var set = IntSet(5, 7, 13, 12, 19)
      assert(set.contains(7) == true)
      assert(set.contains(13) == true)
      assert(set.contains(18) == false)
      assert(set.contains(19) == true)
      assert(set.remove(12) == true)
      assert(set.remove(12) == false)
      assert(set.contains(12) == false)
      set.add(12)
      assert(set.contains(12) == true)
      assert(set.contains(set.any) == true)
      set.add(3)
      assert(set.contains(set.any) == true)
      set.remove(3)
      assert(set.contains(set.any) == true)

      while (set.size != 0)
          assert(set.remove(set.any) == true)
      intercept[IllegalArgumentException]{set.any}
  }

  test("subsetOf") {
      var set1 = IntSet(1, 4, 3, 4)
      var set2 = IntSet(3, 2, 1);
      assert(set2.subsetOf(set1) == false)
      assert(set2.remove(2) == true)
      assert(set2.subsetOf(set1) == true)
  }

  test("union && intersect && equals") {
      assert(IntSet(1, 7, 3).union(IntSet(9, 1, 3)).equals(IntSet(1, 3, 7, 9)))
      assert(IntSet(1, 1, 2, 3).union(IntSet(1, 3, 3, 3, 2, 1, 2, 3)).equals(IntSet(1, 2, 3)))

      assert(IntSet(5, 7, 12, 11, 0, 3).intersect(IntSet(0, 11, 2, 19, 11, 3)).equals(IntSet(0, 11, 3)) == true)
      assert(IntSet(13, 12, 11, 9).intersect(IntSet(19, 3, 10, 14)).equals(IntSet()) == true)
  }

  test("map") {
      assert(IntSet(1, 5, 6, 9, 3).map({_ % 3}).equals(IntSet(0, 1, 2)) == true)
      assert(IntSet(1, 3, 5, 7, 10).map( x => { (2 * x) % 7 }).equals(IntSet(2, 6, 3, 0)) == true)
  }

  test("filter") {
      assert(IntSet(7, 19, 3, 2, 4, 0, 21).filter(x => (x % 2) == 0).equals(IntSet(0, 4, 2)))
      assert(IntSet(10, 100, 1000, 10000).filter(x => (99 <= x && x <= 101)).equals(IntSet(100)))
      assert(IntSet(10, 102, 1000, 10000).filter(x => (99 <= x && x <= 101)).equals(IntSet()))
  }

  test("toSet") {
      assert(IntSet(7, 5, 13, 2, 7).toSet == scala.collection.mutable.HashSet[Int](7, 5, 13, 2, 7))
      assert(IntSet(0, 13, 2, 1, 9, 0).toSet == scala.collection.mutable.HashSet[Int](0, 1, 2, 9, 13))
  }


  test("combined test") {
      var s1 = new IntSet
      var s2 = new IntSet

      s1.add(7)
      s2.add(3)
      assert((s1 == s2) == false)
      s1.add(3)
      s2.add(7)
      assert((s1 == s2) == true)
      assert(s1.remove(10) == false)
      assert(s2.remove(3) == true)

      s1.add(10)
      s1.add(93)
      s2.add(173)
      s1.add(37)
      s2 = s1.union(s2)
      assert(s1.subsetOf(s2) == true)
      assert(s2.subsetOf(s1) == false)
      s2 = s1.intersect(s2)
      assert(s2.subsetOf(s1) == true)

      assert(s1 == s1.map(x => ((x * 2 + 17) - 13) / 2 - 2))
      assert(s1.filter(x => (x % 3 == 2) && (x % 6 == 1)).size == 0)
      
      for (i <- 0 to 1000) s2.add(i)
      for (i <- 0 to 1000) {  
          assert(s2.any == i) // depends on implementation
          assert(s2.remove(s2.any) == true)
      }

      assert(s2.intersect(s1).union(IntSet(1, 2, -1)).toString == "{-1, 1, 2}")
  }
  
} 
