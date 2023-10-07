[source: https://betterprogramming.pub/15-useful-vscode-shortcuts-to-boost-your-productivity-415de3cb1910]

Open the palette to search for a file:
> cmd +P

Add cursors to all matching selections:
> CMD + SHIFT +L

Add cursor to next matching selection:
> CMD +D

Undo last cursor operation:
> CMD + U

Select current line:
> CMD + L

Go to a specific Line:
> CTRL +G

Close all open editor tabs
> CMD +K+W

Toggle block comment:
> SHIFT + OPTION + A

Fold code block:
> CMD + OPTION + [
unfold:
> CMD + OPTION + ]

Move line up or down:
> OPTIION + UP/DOWN

open integrated terminal:'
> CTRL + `

Split editor view:
CMD +\

Format document:
> SHIFT + OPTION+ F

Duplicate selection up or down
> OPTION + SHIFT +UP/DOWN

Toggle side bar:
> CMD + B

[source](https://betterprogramming.pub/vs-code-shortcuts-to-code-like-youre-playing-a-piano-e5db7b272d1)
### Multiple Cursors
> Quickly create multiple cursors to change multiple sections of code
-   Mac: `Cmd + Opt + Arrow Up / Arrow Down`
![[1_Xws0GwbHeJux8Uwh17SMSQ.gif]]
### select next
> select the next occurrence of whatever you have currently selected

-   Mac: `Cmd + D`
- ![[1_x5sLfCWFDQncjUHMleBXIA.gif]]
# Undo Select Next

> Rollback the last select-next by one step

-   Mac: `Cmd + U`
# Scroll the Screen Without Moving the Cursor

> Keep your cursor in place while scrolling up and down in your code

-   Mac: `Ctrl + Fn + Up Arrow / Down Arrow`
# Expand / Shrink Selection

> Expand the scope of your selection to include more / less scope (i.e string, function, etc.)

Only the cool kids use this one.

-   Mac: `Ctrl + Shift + Left Arrow / Right Arrow`
![[1_Z70jxpqDWsR8k_QaivzLvQ.gif]]

# Show / Hide Terminal / Go back to code

> Toggle terminal focus / visibility and move focus back to your code

-   Mac: `Cmd + J` for terminal, `Cmd + 1` for code
					or
- ctrl + ~



[Vandad Nahavandipoor-vscode-hack](https://twitter.com/vandadnp/status/1594903766418997250?s=20)


VSCode generate not only your constructor but add required keywords to the params!

**settings.json**

```json
"quickfix.add.required": true
"quickfix.add.required.multi": true
"quickfix.create.constructorForFinalFields": true
```

![[Pasted image 20230403173658.png]]

