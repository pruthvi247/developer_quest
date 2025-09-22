[source-medium](https://betterprogramming.pub/a-visual-guide-to-sed-a7a8abd2f675) Mastering text substitution tool

`sed` is a CLI tool for text substitution, like “Find and Replace” in GUI editors.

While `[sd](https://github.com/chmln/sd)` is a better alternative these days, learning `sed` has some advantages:

- It’s a standard UNIX tool, available everywhere.
- It shares syntax with `vim`’s command-mode.
- `sed` is based.

However, mastering `sed` takes some time — `sed` is actually a non-interactive text editor with a built-in Turing machine (you can even run [Tetris](https://github.com/uuner/sedtris) on it).

This guide will show you how it works.

![[Pasted image 20230611102953.png]]
The invocation is typically `sed SCRIPT FILE`. For instance, to replace all occurrences of `foo` with `bar` in `input.txt`, you would use:

> sed ` 's/foo/bar/g'` input.txt > output.txts

Sometimes you may want to edit the original file rather than create a new one. In that case, use the `-i/--in-place` option.

> sed 's/foo/bar/g'` input.txt > input.txt (clears file)
> sed -i 's/foo/bar/g'` input.txt (updates file)

By default, `sed` prints all processed input, reflecting any modifications made. You can suppress this output with the `-n/--quiet/--silent` option. In that case, you need to run specific commands to get any output at all, like the `p` command:

![[Pasted image 20230611103400.png]]
Above command prints only line 45

## Command Structure

At its core, a `sed` script consists of one or more commands. These commands follow the syntax `[addr]x[options]`, where:

- `x` is a single-letter command,
- `[addr]` is an optional line address that dictates when the command `x` will run (there can be empty spaces after the address), and
- `[options]` holds additional information for some commands.

`'3 s/foo/bar/g'` will search for the word `foo` on line 3 and replace it with `bar`. Not too difficult, right?

An address can also be a range: A pair of two addresses separated by a comma. In that case, the command will execute for every line within the range. The following example deletes lines 30 to 35 from a file:

`sed ‘30,35d’ input.txt`

You can even use a regular expression address to create interesting commands like this one, which prints all input until a line starting with `foo` is found:

`sed ‘/^foo/q’ input.txt`

When dealing with multiple sed commands, they can be separated by either semicolons (`;`) or newline characters:

`sed ‘/^foo/d ; s/hello/world/g’ input.txt`

## How sed works

Let’s take a closer look at `sed`’s internals.

![](https://miro.medium.com/v2/resize:fit:875/1*yXGthipr5NDCwhTL93SdZw.png)

Sed operates using two data buffers, which you can think of as internal  
variables: the **“pattern space”** and the **“hold space”**. These two buffers play a prominent role in `sed`’s execution, which occurs in cycles:

- First, `sed` reads one line from the input stream into the “pattern space.”
- Then the commands are executed, one after the other. As we’ve seen, each command can have an address associated with it: Addresses are a kind of condition code — The command is executed only if the address matches the “pattern space.”
- When the end of the script is reached, unless the `-n` option is in use, the contents of the “pattern space” are printed to the output stream.
- Then the next cycle starts.

Unlike the “pattern space”, the “hold space” keeps its data between cycles. The “hold space” remains usually empty and unused for the entire execution, unless special commands (like `h`, `H`, `g`, `G`) are used to move data between the buffers). It’s not actually empty — It’s initialized on the first cycle with a single newline (`\n`) character.

## Commands Overview

Here’s a list of every `sed` command, showing what happens when they run.

You’ll notice that some commands print to the output stream, some commands modify the “pattern space”, and a few commands interact with the “hold space.”

Also, some commands jump somewhere else in the execution cycle after running. Most notably the “goto-like” commands: `b`, `t` and `T`.

![[Pasted image 20230611103943.png]]

To use a “goto-like” label, you first need to define it with the `: LABEL` command. Then, jumping to `LABEL` will take you to that place in the execution.

The brackets `{}` are technically commands too. You can use them to group a set of commands so that they execute after a single address.

Broadly speaking, the uppercase commands are a way to do multi-line processing, and the “goto-like” commands are a way to compensate for the lack of `if/then` and loop constructs in `sed`. There’s sadly no way to add or subtract numbers.

> Gigachad-tip: If you need multi-line, branching, or arithmetic, you are probably better off with tools like `awk`, Perl, or Python.

## Example: Getting book authors

Let’s look at an advanced example.

This `sed` script operates on a list of books in the `library.txt` format. It finds authors of books with the word “the” in the title and a high star rating.

![[Pasted image 20230611104139.png]]







