===================================
https://www.youtube.com/watch?v=Ftg8fjY_YWU
===================================

fork():
	creates a clone of current process

exec() :
	replaces current program code

> Among general-purpose programming languages, C and Python are semi-compact; Perl, Java, Emacs Lisp, and shell are not

orthogonality:
-------------

> An orthogonal language enables software developers to independently change one operation of a system, without triggering a ripple effect of changes to subsidiary or dependent operations.

> Your monitor has orthogonal controls. You can change the brightness independently of the contrast level, and (if the monitor has one) the color balance control will be independent of both. 
> Constants, tables, and metadata should be declared and initialized once and imported elsewhere. Any time you see duplicate code, that's a danger sign. Complexity is a cost; don't pay it twice.
> Are you duplicating data because you're caching intermediate results of some computation or lookup? Consider carefully whether this is premature optimization; stale caches (and the layers of code needed to keep caches synchronized) are a fertile source of bugs,[44] and can even slow down overall performance if (as often happens) the cache-management overhead is higher than you expected.
> constraint has encouraged not only economy, but also a certain elegance of design
> simplicity came from trying to think not about how much a language or operating system could do, but of how little it could do — not by carrying assumptions but by starting from zero
> To design for compactness and orthogonality, start from zero. Zen teaches that attachment leads to suffering; experience with software design teaches that attachment to unnoticed assumptions leads to non-orthogonality, noncompact designs, and projects that fail or become maintenance nightmares.
> Broadly speaking, there are two directions one can go in designing a hierarchy of functions or objects. Which direction you choose, and when, has a profound effect on the layering of your code.
> Perfection is attained not when there is nothing more to add, but when there is nothing more to remove
> break up a subprogram when there are too many local variables. Another clue is [too many] levels of indentation. I rarely look at length.
> A good API makes sense and is understandable without looking at the implementation behind it. The classic test is this: Try to describe it to another programmer over the phone. If you fail, it is very probably too complex, and poorly designed.
> if you need a larger value in a text format, just write it. It may be that a given program can't receive values in that range, but it's usually easier to modify the program than to modify all the data stored in that format
> A program is transparent when it is possible to form a simple mental model of its behavior that is actually predictive for all or most cases, because you can see through the machinery to what is actually going on
> Software systems are discoverable when they include features that are designed to help you build in your mind a correct mental model of what they do and how they work. So, for example, good documentation helps discoverability to a user. Good choice of variable and function names helps discoverability to a programmer. Discoverability is an active quality. To achieve it in your software you cannot merely fail to be obscure, you have to go out of your way to be helpful.

> If we believe in data structures, we must believe in independent (hence simultaneous) processing. For why else would we collect items within a structure? Why do we tolerate languages that give us the one without the other?

> The classic Unix case of shelling out is calling an editor from within a mail or news program. In the Unix tradition one does not bundle purpose-built editors into programs that require general text-edited input. Instead, one allows the user to specify an editor of his or her choice to be called when editing needs to be done.

> ls | wc

 from above command,It's important to note that all the stages in a pipeline run concurrently. Each stage waits for input on the output of the previous one, but no stage has to exit before the next can run. This property will be important later on when we look at interactive uses of pipelines, like sending the lengthy output of a command to more(1)

> Pipelines have many uses. For one example, Unix's process lister ps(1) lists processes to standard output without caring that a long listing might scroll off the top of the user's display too quickly for the user to see it. Unix has another program, more(1), which displays its standard input in screen-sized chunks, prompting for a user keystroke after displaying each screenful.

Thus, if the user types “ps | more”, piping the output of ps(1) to the input of more(1), successive page-sized pieces of the list of processes will be displayed after each keystroke.

The ability to combine programs like this can be extremely useful. But the real win here is not cute combinations; it's that because both pipes and more(1) exist, other programs can be simpler. Pipes mean that programs like ls(1) (and other programs that write to standard out) don't have to grow their own pagers — and we're saved from a world of a thousand built-in pagers (each, naturally, with its own divergent look and feel). Code bloat is avoided and global complexity reduced.


> When writing daemons, follow the Rule of Least Surprise: use these conventions, and read the manual pages to look for existing models.

> A ‘race condition’ is a class of problem in which correct behavior of the system relies on two independent events happening in the right order, but there is no mechanism for ensuring that they actually will. Race conditions produce intermittent, timing-dependent problems that can be devilishly difficult to debug.


> Software systems are transparent when they don't have murky corners or hidden depths. Transparency is a passive quality. A program is transparent when it is possible to form a simple mental model of its behavior that is actually predictive for all or most cases, because you can see through the machinery to what is actually going on.

> Transparency and discoverability are important for both users and software developers. But they're important in different ways. Users like these properties in a UI because they mean an easier learning curve. UI transparency and discoverability are a large part of what people mean when they say a UI is ‘intuitive’; most of the rest is the Rule of Least Surprise. 

> Simplicity plus transparency lowers costs, reduces everybody's stress, and frees people to concentrate on new problems rather than cleaning up after old mistakes.

[source: https://stackoverflow.com/questions/16956810/how-do-i-find-all-files-containing-specific-text-on-linux]

find files with text:

>> grep -rnw '/path/to/somewhere/' -e 'pattern'
##### Find High Memory/CPU Usage Processes
You can use the following command to find out the high memory consumption processes in order:
> ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -10
you can find out high CPU usage processes:
> ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -10

##### View TCP Connection Status
$ netstat -nat | awk '{print $6}' | sort | uniq -c | sort -rn


[https://vimtricks.com/p/50-useful-vim-commands/]
Here are 50 useful Vim commands that work in normal mode. Many of these can be combined and modified to produce dozens more. Use these as inspiration for your own repeatable workflows. In no particular order:



| Shortcut      | Description |
| ----------- | ----------- |
| gg     | Move to the first line of the file|
| G     | Move to the last line|
| gg=G    | Reindent the whole file|
| gv     | Reselect the last visual selection|
| g_     | Move the last non-blank character of the line (but you remove trailing whitespace, right)|
| ^     | Move to first non-blank character of the line|
| g_lD     | Delete all the trailing whitespace on the line|
| ea     | Append to the end of the current word|
| gf     | Jump to the file name under the cursor|
| xp     | Swap character forward|
| Xp     | Swap character backward|
| yyp     | Duplicate the current line|
| yapP     | Duplicate the current paragraph|
| dat     | Delete around an HTML tag, including the tag|
| dit     | Delete inside an HTML tag, excluding the tag|
| w     | Move one word to the right|
| b     | Move one word to the left|
| dd     | Delete the current line|
| zc     | Close current fold|
| zo     | Open current fold|
| za     | Toggle current fold|
| zi     | Toggle folding entirely|
| z=     | Show spelling corrections|
| >>     | Indent current line|
| <<     | Outdent current line|
| zg     | Add to spelling dictionary|
| zw     | Remove from spelling dictionary|
| ~     | Toggle case of current character|
| gUw     | Uppercase until end of word (u for lower, ~ to toggle)|
| gUiw     | Uppercase entire word (u for lower, ~ to toggle)|
| gUU     | Uppercase entire line|
| gu$     | Lowercase until the end of the line|
| da"     | Delete the next double-quoted string|
| +     | Move to the first non-whitespace character of the next line|
| S     | Delete current line and go into insert mode|
| I     | Insert at the beginning of the line|
| ci"     | Change what's inside the next double-quoted string|
| ca{     | Change inside the curly braces (try \[, (, etc.) |
| Vaw     | Visually select word|
|dap      | Delete the whole paragraph|
|r      |Replace a character |
|`\[      |Jump to beginning of last yanked text |
|`\]      |Jump to the end of last yanked text |
|g;      |Jump to the last change you made |
|g,     |Jump back forward through the change list |
|&      |Repeat last substitution on current lines |
|g&      |Repeat last substitution on all lines |
|ZZ      |Save current file and close it |
#### [special shell variables](https://www.bogotobogo.com/Linux/linux_shell_programming_tutorial3_special_variables.php)

These are special shell variables which are set internally by the shell and which are available to the user:


| Variable      | Description |
| ----------- | ----------- |
|$0      | The filename of the current script.|
|$n      | These variables correspond to the arguments with which a script was invoked. Here n is a positive decimal number corresponding to the position of an argument (the first argument is $1, the second argument is $2, and so on).|
|  $\$      | The process ID of the current shell. For shell scripts, this is the process ID under which they are executing.|
|$#      | The number of arguments supplied to a script.|
|$@      | All the arguments are individually double quoted. If a script receives two arguments, $@ is equivalent to $1 $2.|
|$*      | All the arguments are double quoted. If a script receives two arguments, $* is equivalent to $1 $2.|
|$?      | The exit status of the last command executed.|
|$!      | The process ID of the last background command.|
|$_      | The last argument of the previous command.|







