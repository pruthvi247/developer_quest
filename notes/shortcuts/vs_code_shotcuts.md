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

### Integrated Terminal
- Navigate between terminals in a group by focusing the previous pane, ⌥⌘←, or the next pane, ⌥⌘→.
- To toggle the terminal panel, use the ⌃` keyboard shortcut.
- To create a new terminal, use the ⌃⇧` keyboard shortcut.
- The integrated terminal has find functionality that can be triggered with ⌘F.
- `Cmd + J` for terminal to hide or open
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
[Freecodecampm-video-Source](https://www.freecodecamp.org/news/increase-your-vs-code-productivity/)
Go to file. - command+P
Find in files - command+shift+P`
open file side by side : opt + click
Go to symbol: cmd+shift+O
Find and replace: 
Three ways
Inline: cmd + F
- **search bar** we can exclude and include folders/files
- we can also right click on the folder  and select `find in folder` option
- **open search editor** will open new tab and gives more context

**Multicursor editing**
> cmd+ F and enter search term and option+return

**peek definition**
Shows function definition below the method

## Refactoring
- Find all finds in comments also
- Find all references will not check in comments
- **Rename symbol** changes name across all file system(to update name of class or function- short cut -f2)
- 
open side bar - cmd+shift+E
close/open side bar - cmd + B



### List of extensions
#### HTML
- code peek
- html end tag label
- npm
- gitignore
- npm intellisense
- version lens
- import cost
- One Monokai Theme
#### Javascript
- jsDoc
- javascript code snippets
- path intellisense
- Turbo console Log
- javascript Booster
- auto imports
- code navigation + rename
- update imports on move
- code actions on save
- ESLint
- cmd + t -> symbols acros workspace
- cmd+shit+o -> symbol in current file
- settings.json-> editor.codeActionsOn save-> source.organizeimports
-
#### Vue.js
- vetur
- vue vscode snippets
- vs code Extension Pack
#### Tailwind
- Tailwind css intellisense
- Taiwind Docs
- Headwind
#### MarkDown
- markdown preview github styling
- markdown all in one
- markdown lint
#### Flutter
- Flutter
- Dart
- Awesome flutter snippets
- Flutter widget snippets
- Flutter code select
- Pubspec Assist
- version Lens
- tabout
- explorer exclude
- ToDo Tree
- code spell checker
- Bracket Pair Colorizer
- 
VS Code Settings
- renderIndentGuides
- LineHeight
- BreadCrumbs
- Theme - one dark pro
- settings -> cmd +,
- 

> move in to editor area -> we can move terminal to tab editor

#### Multiple projects in vs code
- Add folder to workspace
- Project Manager -> extension
- Peacock -> Extension


## Shortcuts
[source-medium](https://medium.com/flutter-community/flutter-visual-studio-code-shortcuts-for-fast-and-efficient-development-7235bc6c3b7d)
1. You can find the list of default keyboard shortcuts and also search for shortcuts by using `CTRL+K+S`
2. `Ctrl+Shift+P` to Show Command Palette with the recently used commands or also to search commands
3. `Ctrl+.` to find the quick fix options.
4. Prefix `stless`: Create a new subclass of `StatelessWidget`
5. Prefix `stful`: Create a new subclass of `StatefulWidget` and it’s associated State subclass.
6. Prefix `stanim`: Create a new subclass of `StatefulWidget`, and it’s associated State subclass including a field initialized with an `AnimationController`.
7. **Inorder to see the class hierarchy press `F4` on any `widget` and in a few seconds you will be able to see the widget hierarchy.**
8. Peek Definition" feature in VSCode. This allows you to quickly peek at the definition of a widget or function without navigating away from your current code. `Option + F12` (Mac).
9. `Cmd + Shift + O` gives out line of a class
# Debugging Shortcuts

These are some of the debugging shortcuts which will come in handy, hope you don’t need any examples for the same.

- `F5` - Start Debugging
- `Ctrl`+`F5` - Start Without Debugging
- `Shift`+`F5` - Stop Debugging
- `Ctrl`+`Shift`+`F5` (macOS: `Cmd`+`Shift`+`F5`) - Restart Debugging (Hot Reload when debugging Flutter apps)
- `Ctrl`+`F5` - Hot Restart (when debugging Flutter apps and in a debug session)
- `F9` - Toggle Breakpoint
- `F10` - Step Over
- `F11` - Step In
- `Shift`+`F11` - Step Out
