############ VI Editor ###########
source - https://www.washington.edu/computing/unix/vi.html

Command Summary
STARTING vi

     vi filename    edit a file named "filename"
     vi newfile     create a new file named "newfile"
ENTERING TEXT

     i         insert text left of cursor
     a	       begin insert at right of cursor
     A	       begin insert at end of line
     i         begin insert at left of cursor
     I	       insert at beginning of line
     o	       open line below, ready for insertion
     O	       open line above, ready for insertion
MOVING THE CURSOR

     h            left one space
     j            down one line
     k            up one line
     l            right one space
BASIC EDITING

     x         delete character
     nx        delete n characters
     X         delete character before cursor
     dw        delete word
     ndw       delete n words
     dd        delete line
     ndd       delete n lines
     D         delete characters from cursor to end of line
     r         replace character under cursor
     cw        replace a word
     ncw       replace n words
     C         change text from cursor to end of line
     o         insert blank line below cursor
                  (ready for insertion)
     O         insert blank line above cursor
                  (ready for insertion)
     J         join succeeding line to current cursor line
     nJ        join n succeeding lines to current cursor line
     u         undo last change
     U         restore current line
    CTRL-R     (keeping CTRL key pressed while hitting R) a few times to redo the commands (undo the undo's).
MOVING AROUND IN A FILE

     w            forward word by word
     b            backward word by word
     $            to end of line
     0 (zero)     to beginning of line
     H            to top line of screen
     M            to middle line of screen
     L            to last line of screen
     G            to last line of file
     1G           to first line of file
     GG           jump to the top of the file
     <Control>f   scroll forward one screen
     <Control>b   scroll backward one screen
     <Control>d   scroll down one-half screen
     <Control>u   scroll up one-half screen
     n            repeat last search in same direction
     N            repeat last search in opposite direction
     }            move to next paragraph
     {            move to previous paragraph
     )            move to next sentence
     (            move to previous sentence
CLOSING AND SAVING A FILE

     ZZ            	save file and then quit
     :w            	save file
     :q!            	discard changes and quit file
     vi -r filename	retrieve saved version of file after system or editor crash

Changing, Replacing, and Copying Text
	.	                repeat last change
	n.	                repeat last change n times
	cwtext	                mark end of a word with $ and change to text (press <Esc> to end)
	rx	                replace character under cursor with character x
	nrx	                replace n characters with character x
	Rtext	                write over existing text, (<Esc> to end)
	J	                join succeeding line to current cursor line
	:s/pat1/pat2	        on the current line, substitute the first occurence of pattern 1 with pattern 2
	:s/pat1/pat2/g	        on the current line, substitute all occurences of pattern 1 with pattern 2
	:&	                ;repeat the last :s request
	:%s/pat1/pat2/ g	substitute all occurences of pattern 1 with pattern 2 throughout the file
	:.,$s/pat1/pat2/ g	substitute all occurences of pattern 1 with pattern 2 from cursor to end of file
	:#,#s/old/new/g		To substitute phrases between two line #'s (to replace characters between lines)
	:%s/old/new/g		To substitute all occurrences in the file type
	:%s/old/new/gc		To ask for confirmation each time add 'c'
	:%s:pat1:pat2:g		Replace '/' with ':' if you want to replace special characters


[source: http://www2.geog.ucl.ac.uk/~plewis/teaching/unix/vimtutor]

	dw  			to delete to the end of a word,(delete a word)
	d$			to delete to the end of the line(will will delete a line with out empty space unlike 'dd' command where empty line will be present)
	2dd			deletes two lines from the cursor position
	CTRL-R 			(keeping CTRL key pressed while hitting R) a few times to redo the commands (undo the undo's).
	P			To put last deleted/copied(yy) line
	nyy			Copy required text, n-> number of lines
	r			Replace a character under the cursor
	cw			to replace all the characters of the word from cursor position to end of the word
	c$			same operation as above, it will replace all the words from the cursor position to end of the line
	CTRL-g 			To show your location in the file and the file status.
	line number and SHIFT+g  Will take you to that particular line
	:!			followed by an external command to execute that command.
	:#,# w FILENAME		To save part of the file
	":help" command.  Try these (don't forget pressing <ENTER>):

	:help w
	:help c_<T
	:help insert-index
	:help user-manual
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		    Lesson 5.3: A SELECTIVE WRITE COMMAND
	** To save part of the file, type   :#,# w FILENAME **

  1. Once again, type  :!dir  or  :!ls  to obtain a listing of your directory
     and choose a suitable filename such as TEST.

  2. Move the cursor to the top of this page and type  Ctrl-g  to find the
     number of that line.  REMEMBER THIS NUMBER!

  3. Now move to the bottom of the page and type  Ctrl-g again.  REMEMBER THIS
     LINE NUMBER ALSO!

  4. To save ONLY a section to a file, type   :#,# w TEST   where #,# are
     the two numbers you remembered (top,bottom) and TEST is your filename.

  5. Again, see that the file is there with  :!dir  but DO NOT remove it.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		   Lesson 5.4: RETRIEVING AND MERGING FILES
       ** To insert the contents of a file, type   :r FILENAME **

  1. Type   :!dir   to make sure your TEST filename is present from before.

  2. Place the cursor at the top of this page.

NOTE:  After executing Step 3 you will see Lesson 5.3.	Then move DOWN to
       this lesson again.

  3. Now retrieve your TEST file using the command   :r TEST   where TEST is
     the name of the file.

NOTE:  The file you retrieve is placed starting where the cursor is located.

  4. To verify that a file was retrieved, cursor back and notice that there
     are now two copies of Lesson 5.3, the original and the file version.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			    Lesson 6.4: SET OPTION
	  ** Set an option so a search or substitute ignores case **

  1. Search for 'ignore' by entering:
     /ignore
     Repeat several times by hitting the n key
  2. Set the 'ic' (Ignore case) option by typing:
     :set ic
  3. Now search for 'ignore' again by entering: n
     Repeat search several more times by hitting the n key
  4. Set the 'hlsearch' and 'incsearch' options:
     :set hls is
  5. Now enter the search command again, and see what happens:
     /ignore

Moving by searching:
-------------------

To move quickly by searching for text, while in command mode:
	1: Type "/"
	2: Enter the text to search for
	3: Press <Retrun>
	4: To repeat the search in a forward direction type - n
	5: To repeat the search in a backward direction type - N

[source : https://pragmaticpineapple.com/why-should-you-learn-vim-in-2020/]

> To quickly you can select characters along a column, in Vim, press CTRL+v - now you can select columns. The following command is 8j, letting Vim know that I want to go eight lines down. Then, I press s to substitute a character, and I type in the character t, which I want to put there. Finally, I press Esc twice, and the whole column is changed.


[source : https://stackoverflow.com/questions/253380/how-to-insert-text-at-beginning-of-a-multi-line-selection-in-vi-vim]

insert text at beginning of a multi-line selection in vi/Vim 

Press Esc to enter 'command mode'
Use Ctrl+V to enter visual block mode
Move Up/Downto select the columns of text in the lines you want to comment.
Then hit Shift+i and type the text you want to insert.
Then hit Esc, wait 1 second and the inserted text will appear on every line.




