import com.sun.tools.corba.se.idl.StringGen

import scala.collection.mutable
import scala.util.hashing.Hashing.Default

// MiniBuffer.scala
// Copyright (c) 2015 J. M. Spivey

/** A small editing area that appears on the bottom line of the screen.
 * Clients can call commandLoop() to allow the minibuffer 
 * contents to be edited, or they can use the other methods to control
 * the minibuffer contents from their own command loop. */
class MiniBuffer(display: Display, val prompt: String, default: String) {
    private val text = new Text(100)
    private var _pos = 0
    private var _status = MiniBuffer.NORMAL

    /** needed for interactive search */
    private var to_do: Option[(MiniBuffer => Int)] = None
    private var mark = -1
    private var ed: EdBuffer = null
    private var default_string: String = ""
    private var first_command = true
    private var prev_occurence = new mutable.Stack[this.Memento]
    private var erase_prev = false

        
    if (default != null) {
        text.insert(0, default)
        pos = default.length
    }

    
    /** Get the status: ABORT if the editing was aborted with Ctrl-G. */
    def status = _status
    
    def setVisible(visible: Boolean) {
        display.setMiniBuf(if (visible) this else null)
    }
    
    /** Get the cursor position */
    def pos = _pos
    
    /** Set the cursor position.
     * Either the cursor should be in the range [0..length], or it should by
     * -1 to indicate that no cursor should be displayed. */
    def pos_=(pos: Int) { 
        assert(pos == -1 || 0 <= pos && pos <= length)
        _pos = pos
    } 
    
    def length = text.length

    def getText(buf: Text) {
        buf.clear()
        buf.insert(0, text)
    }

    override def toString() = text.toString()
    
    def clear() { text.clear(); if (pos >= 0) pos = 0 }
    
    def append(ch: Char) {
        if (pos == text.length) pos += 1
        text.insert(text.length, ch)
    }
    
    def append(s: String) {
        if (pos == text.length) pos += s.length
        text.insert(text.length, s)
    }
    
    def deleteLast() {
        assert(text.length > 0)
        if (pos == text.length) pos -= 1
        text.deleteLast()
    }

    /** Command: pressed CTRL+S */
    def ctrlS: Unit = {
        erase_prev = false
        if (first_command) {
            text.insert(0, default_string)
            pos = default_string.length
        } else {
            to_do match {
                case None => {
                    display.beep()
                }
                case Some(f) => {
                    prev_occurence.push(new Memento)

                    val where = f(this)
                    if (where == -1) {
                        display.beep()
                        prev_occurence.pop
                    } else {
                        mark = (where + 1) % ed.length
                    }
                }
            }
        }
    }

    /** Command: pressed CTRL-L to undo CTRL_S */
    def ctrlL = {
        erase_prev = false
        if (prev_occurence.isEmpty) {
            display.beep()
        } else {
            prev_occurence.pop().restore
        }
    }

    // Memento pattern
    class Memento {
        private var mk = mark
        def restore = {mark = mk}
    }
    
    // Editing commands
    def insertChar(ch: Char) { text.insert(pos, ch); pos += 1 }
    def moveRight() { if (pos < length) pos += 1 }
    def moveLeft() { if (pos > 0) pos -= 1 }
    def deleteRight() { if (pos < length) text.deleteChar(pos) }
    def deleteLeft() { if (pos > 0) { pos -= 1; text.deleteChar(pos) } }
    def moveHome() { pos = 0 }
    def moveEnd() { pos = length }
    def accept() { _status = MiniBuffer.DONE; first_command = false; ctrlS }
    def abort() { display.beep(); _status = MiniBuffer.ABORT }

    def commandLoop() {
        setVisible(true)
        while (status == MiniBuffer.NORMAL) {
            display.refreshMinibuf()

            erase_prev = true
            to_do match {
                case Some(f) => f(this) // do something
                case None => {}
            }

            val k = display.getKey()
            MiniBuffer.keymap.find(k) match {
                case Some(cmd) => cmd(this)
                case None => display.beep()
            }

            if (erase_prev) {
                while (!prev_occurence.isEmpty)
                    prev_occurence.pop()
            }
            first_command = false
        }
        setVisible(false)
    }
}

object MiniBuffer {
    /** Value returned by getStatus */
    val NORMAL = 0
    val DONE = 1
    val ABORT = 2

    val keymap = Keymap[MiniBuffer => Unit](
        Display.RIGHT -> (_.moveRight),
        Display.LEFT -> (_.moveLeft),
        Display.DEL -> (_.deleteRight),
        Display.HOME -> (_.moveHome),
        Display.END -> (_.moveEnd),
        Display.RETURN -> (_.accept),
        Display.ctrl('A') -> (_.moveHome),
        Display.ctrl('B') -> (_.moveLeft),
        Display.ctrl('D') -> (_.deleteRight),
        Display.ctrl('E') -> (_.moveEnd),
        Display.ctrl('F') -> (_.moveRight),
        Display.ctrl('G') -> (_.abort),
        Display.ctrl('?') -> (_.deleteLeft),
        Display.ctrl('S') -> (_.ctrlS),
        Display.ctrl('L') -> (_.ctrlL)
    )

    for (ch <- Display.printable)
        keymap += ch -> (_.insertChar(ch.toChar))
        

    // Utility functions

    def readString(display: Display, prompt: String, default: String) = {
        val mini = new MiniBuffer(display, prompt, default)
        mini.commandLoop()
        if (mini.status == MiniBuffer.ABORT)
            null
        else
            mini.toString()
    }

    /** Start an interactive search */
    def startInteractiveSearch(display: Display, prompt: String, default: String, _ed: EdBuffer): (Int, String) = {
        // this is function that is applied at the beginning of each iteration of the command loop
        val f: (MiniBuffer => Int) = (me:MiniBuffer) => {
            val where = me.ed.search(me.text.toString(), me.mark)
            if (where != -1) {
                display.refresh(EdBuffer.REWRITE, me.ed.getRow(where), me.ed.getColumn(where))
                display.moveCursor(me.ed.getRow(where), me.ed.getColumn(where))
            }
            where
        }

        val mini = new MiniBuffer(display, prompt, "")
        mini.ed = _ed
        mini.mark = _ed.point
        mini.to_do = Some(f)
        mini.default_string = default
        mini.commandLoop()

        if (mini.status == MiniBuffer.ABORT)
            (-2, "")
        else {
            (mini.mark, mini.toString())
        }

    }



    /** Use the minibuffer to display a message, then wait for a keypress */
    def message(display: Display, fmt: String, args: Any*) {
        val msg = fmt.format(args: _*)
        val mini = new MiniBuffer(display, msg + " (press RETURN)", null)
        display.beep()
        display.flush()
        mini.setVisible(true)
        display.getKey(); // Any key will do!
        mini.setVisible(false)
    }
    
    /** Use the minibuffer to ask a yes/no question.  Unless the user types
     * "yes" exactly, the default answer is "no". */
    def ask(display: Display, question: String) = {
        display.beep()
        val ans = readString(display, question + " (yes/no)", null)
        (ans == "yes")
    }

}

