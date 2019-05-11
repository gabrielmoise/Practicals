/** Change Log:
  * 1. Ctrl-Home & Ctrl-End move the cursor to the beggining and end of the file
  * 2. Ctrl-T transposes characters before and on the actual position
  *    Ctrl-Z & Ctrl-Y can be used to undo/redo
  * 3. Ctrl-M adds a mark to the current position
  *    Initially, mark is not defined. It resets when we load a new file.
  *    Ctrl-O exchanges the current cursor and the mark
  *    The mark moves when we insert/delete a character/string that should affect it.
  * 4. Ctrl-C, Ctrl-V, Ctrl-X were introduced with the basic meaning
  *    Paste and Cut can be undone/redone.
  *
  * (Optionals)
  * 1. Ctrl-J was added to make a simple search from the current point.
  *    It returns meaningful messages if the operation did not succeed.
  *    The previous not-aborted search is used as default for the following one.
  * 2. Ctrl-S to start an interactive search.
  *    When the string can be found in the text, the cursor indicated that occurence.
  *    Otherwise, the cursor is placed in the search dialog.
  *    The display automatically scrolls down/up in order to place the current occurence in the middle.
  *    Ctrl-S may paste the previous search string in the search dialog(if this is the first command), or...
  *    Ctrl-S goes to the next occurence(if there is one).
  *    Ctrl-L reverses the previous Ctrl-S(next occurence) command. It can be applied multiple times.
  *    Ctrl-L loses its effect if any other operation happens in the meantime.
  */



// Editor.scala
// Copyright (c) 2015 J. M. Spivey
// Amended 2017 by P.G. Jeavons

/** The controller class for a basic editor */
class Editor {
    /** The buffer being edited. */
    protected val ed = new EdBuffer

    /** The display. */
    protected var display: Display = null
    
    /** Whether the command loop should continue */
    private var alive = true

    /** The default string for a search */
    private var default_string: String = ""

    
    /** Show the buffer on a specified display */
    def activate(display: Display) {
        this.display = display
        display.show(ed)
        ed.register(display)
        ed.initDisplay()
    }

    /** Ask for confirmation if the buffer is not clean */
    def checkClean(action: String) = {
        if (! ed.isModified) 
            true
        else {
            val question = 
                "Buffer modified -- really %s?".format(action)
            MiniBuffer.ask(display, question)
        }
    }

    /** Load a file into the buffer */
    def loadFile(fname: String) = { ed.loadFile(fname); ed.point = 0; ed.update() }

    /** Command: Move the cursor in the specified direction */
    def moveCommand(dir: Int) {
        var p = ed.point
        val row = ed.getRow(p)


        dir match {
            case Editor.LEFT => 
                if (p > 0) p -= 1
            case Editor.RIGHT =>
                if (p < ed.length) p += 1
            case Editor.UP =>
                p = ed.getPos(row-1, goalColumn())
            case Editor.DOWN =>
                p = ed.getPos(row+1, goalColumn())
            case Editor.HOME =>
                p = ed.getPos(row, 0)
            case Editor.END =>
                p = ed.getPos(row, ed.getLineLength(row)-1)
            case Editor.PAGEDOWN =>
                p = ed.getPos(row + Editor.SCROLL, 0)
                display.scroll(+Editor.SCROLL)
            case Editor.PAGEUP =>
                p = ed.getPos(row - Editor.SCROLL, 0)
                display.scroll(-Editor.SCROLL)
            case Editor.CTRLHOME =>
                p = ed.getPos(0, 0)
            case Editor.CTRLEND =>
                p = ed.getPos(ed.numLines - 1, ed.getLineLength(ed.numLines - 1) - 1)
            case _ =>
                throw new Error("Bad direction for move")
        }

        ed.point = p
    }

    /** Command: Transpose two characters */
    def transposeCommand: Boolean = {
        var p = ed.point
        var row = ed.getRow(p)
        var col = ed.getColumn(p)
        if (col <= 0 || col >= ed.getLineLength(row) - 1) {beep(); return false}
        ed.transpose(p)
        ed.point = ed.point + 1
        true
    }

    /** Command: Set the mark at the current point */
    def setMarkCommand = {
        ed.mark = ed.point
    }

    /** Command: Copy the text between point and mark */
    def copyCommand: Boolean = {
        if (!ed.onRow(ed.mark) || !ed.onRow(ed.point)) {beep(); return false}
        ed.copyText(Math.min(ed.point, ed.mark), Math.max(ed.point, ed.mark))
        true
    }

    /** Command: Cut the text between point and mark */
    def cutCommand: Boolean = {
        if (!copyCommand) {beep(); return false}
        val lstart = Math.min(ed.point, ed.mark)
        val lend = Math.max(ed.point, ed.mark)
        ed.deleteRange(lstart, lend - lstart + 1)
        if (ed.point == lend) ed.point = lstart
        true
    }

    /** Command: Paste the text where the point is placed */
    def pasteCommand = {
        ed.point += ed.pasteText(ed.point)
    }

    /** Command: Swap point with the mark */
    def swapPointMarkCommand: Boolean = {
        if (ed.mark == -1) {beep(); return false}
        val aux = ed.point
        ed.point = ed.mark
        ed.mark = aux
        true
    }


    /** Command: Search for a given text */
    def searchText: Boolean = {
        val s = MiniBuffer.readString(display, "Search: ", default_string)

        // invalid input
        if (s == null || s == "") {
            if (s == "") default_string = ""
            MiniBuffer.message(display, "Can not search for an empty string")
            return false
        }
        default_string = s // for further searches

        var where: Int = ed.search(s, ed.point)
        if (where != -1) {
            if (where + 1 == ed.point)
                MiniBuffer.message(display, "No other occurence of " + s)
            ed.point = where + 1;
            true
        } else {
            MiniBuffer.message(display, "No occurence of " + s)
            false
        }

    }

    /** Command: Search for a text interactively */
    def interactiveSearchText: Boolean = {
        val (where, s) = MiniBuffer.startInteractiveSearch(display, "Search interactively: ", default_string, ed)
        if (where >= 0) ed.point = where
        if (where >= -1) default_string = s
        true
    }

    /** Command: Insert a character */
    def insertCommand(ch: Char) {
        ed.insert(ch)
        ed.point += 1
    }

    /** Command: Delete in a specified direction */
    def deleteCommand(dir: Int): Boolean = {
        var p = ed.point
 
        dir match {
            case Editor.LEFT =>
                if (p == 0) { beep(); return false }
                p -= 1
                ed.deleteChar(p)
                ed.point = p
            case Editor.RIGHT =>
                if (p == ed.length) { beep(); return false }
                ed.deleteChar(p)
            case _ =>
                throw new Error("Bad direction for delete")
        }
        return true
     }
    
    /** Command: Save the file */
    def saveFileCommand() {
        val name = 
            MiniBuffer.readString(display, "Write file", ed.filename)
        if (name != null && name.length > 0)
            ed.saveFile(name)
    }

    /** Prompt for a file to read into the buffer.  */
    def replaceFileCommand(): Boolean = {
        if (! checkClean("overwrite")) return false
        val name = 
            MiniBuffer.readString(display, "Read file", ed.filename)
        if (name != null && name.length > 0) {
            if (ed.loadFile(name)) { 
                ed.point = 0
                return true
            }
        }
        return false
    }

    /** Command: recenter and rewrite the display */
    def chooseOrigin() { 
        display.chooseOrigin() 
        ed.forceRewrite()
    }
    
    /** Quit, after asking about modified buffer */
    def quit() {
        if (checkClean("quit")) alive = false
    } 

    // Command execution protocol
    
    /** Goal column for vertical motion. */
    private var goal = -1
    private var prevgoal = 0
     
    /** Execute a command, wrapping it in actions common to all commands */
    protected def obey(cmd: Editor.Command) {
        prevgoal = goal; goal = -1
        display.setMessage(null)
        cmd(this)
        ed.update()
     }
    
    /** The desired column for the cursor after an UP or DOWN motion */
    private def goalColumn() = {        
        /* Successive UP and DOWN commands share the same goal column,
         * but other commands cause it to be reset to the current column */
        if (goal < 0) {
            val p = ed.point
            goal = if (prevgoal >= 0) prevgoal else ed.getColumn(p)
        }
        
        goal
    }

    /** Beep */
    def beep() { display.beep() }
 
    
    /** Read keystrokes and execute commands */
    def commandLoop() {
        //activate(display)

        while (alive) {
            val key = display.getKey()
            Editor.keymap.find(key) match {
                case Some(cmd) => obey(cmd)
                case None => beep()
            }
        }
    }
}

object Editor {
    /** Direction for use as argument to moveCommand or deleteCommand. */
    val LEFT = 1
    val RIGHT = 2
    val UP = 3
    val DOWN = 4
    val HOME = 5
    val END = 6
    val PAGEUP = 7
    val PAGEDOWN = 8
    val CTRLHOME = 9
    val CTRLEND = 10
    
    /** Amount to scroll the screen for PAGEUP and PAGEDOWN */
    val SCROLL = Display.HEIGHT - 3

    /** Possible value for damage. */
    val CLEAN = 0
    val REWRITE_LINE = 1
    val REWRITE = 2

    /** Keymap for editor commands */
    type Command = (Editor => Boolean)
    
    // This implicit conversion allows methods that return Unit to
    // be used as commands, that always succeed
    import scala.language.implicitConversions
    implicit def fixup(v: Unit): Boolean = true

    
    val keymap = Keymap[Command](
        Display.RETURN -> (_.insertCommand('\n')),
        Display.RIGHT -> (_.moveCommand(RIGHT)),
        Display.LEFT -> (_.moveCommand(LEFT)),
        Display.UP -> (_.moveCommand(UP)),
        Display.DOWN -> (_.moveCommand(DOWN)),
        Display.HOME -> (_.moveCommand(HOME)),
        Display.END -> (_.moveCommand(END)),
        Display.PAGEUP -> (_.moveCommand(PAGEUP)),
        Display.PAGEDOWN -> (_.moveCommand(PAGEDOWN)),
        Display.ctrl('?') -> (_.deleteCommand(LEFT)),
        Display.DEL -> (_.deleteCommand(RIGHT)),
        Display.ctrl('A') -> (_.moveCommand(HOME)),
        Display.ctrl('B') -> (_.moveCommand(LEFT)),
        Display.ctrl('D') -> (_.deleteCommand(RIGHT)),
        Display.ctrl('E') -> (_.moveCommand(END)),
        Display.ctrl('F') -> (_.moveCommand(RIGHT)),
        Display.ctrl('G') -> (_.beep),
        Display.ctrl('L') -> (_.chooseOrigin),
        Display.ctrl('N') -> (_.moveCommand(DOWN)),
        Display.ctrl('P') -> (_.moveCommand(UP)),
        Display.ctrl('Q') -> (_.quit),
        Display.ctrl('R') -> (_.replaceFileCommand),
        Display.ctrl('W') -> (_.saveFileCommand),
        Display.CTRLHOME -> (_.moveCommand(CTRLHOME)),
        Display.CTRLEND -> (_.moveCommand(CTRLEND)),
        Display.ctrl('T') -> (_.transposeCommand),
        Display.ctrl('M') -> (_.setMarkCommand),
        Display.ctrl('O') -> (_.swapPointMarkCommand),
        Display.ctrl('C') -> (_.copyCommand),
        Display.ctrl('X') -> (_.cutCommand),
        Display.ctrl('V') -> (_.pasteCommand),
        Display.ctrl('J') -> (_.searchText),
        Display.ctrl('S') -> (_.interactiveSearchText)
        )

    for (ch <- Display.printable)
        keymap += ch -> (_.insertCommand(ch.toChar))
        
    /** Main program for the entire Ewoks application. */
    def main(args: Array[String]) {
        // Check number of arguments
        if (args.length > 1) {
            Console.err.println("Usage: ewoks [file]")
            scala.sys.exit(2)
        }

        // Initial setup
        val terminal = new Terminal("EWOKS")
        terminal.activate()
        val display = new Display(terminal)
        val app = new Editor()
        app.activate(display)
        if (args.length > 0) app.loadFile(args(0))
        
        // Main execution loop
        app.commandLoop()
        scala.sys.exit(0)
    }
}
