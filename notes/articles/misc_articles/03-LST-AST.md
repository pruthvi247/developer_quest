
# Abstract Syntax Tree (AST) vs Lossless Syntax Tree (LST/CST)

## A Deep Dive into Compiler Theory & Language Tooling

---

# PART 1: THE FOUNDATION — WHY DO THESE TREES EXIST?

Before comparing them, let's understand the **problem they both solve**.

When a compiler or language tool reads source code, it gets a flat string of characters:

```plaintext
let x = 10 + 20;
```

This is just **bytes**. No structure. No meaning. The compiler needs to:

1. Break it into tokens (lexing)
2. Understand the grammatical structure (parsing)
3. Represent that structure in memory as a **tree**

The question is: **How much information do you keep in that tree?**

This is where AST and LST diverge dramatically.

---

# PART 2: ABSTRACT SYNTAX TREE (AST)

## 2.1 Core Philosophy

> **"Keep only what is semantically meaningful. Throw away everything else."**

An AST is a **lossy, simplified, semantic representation** of source code. It discards:

- Whitespace
- Comments
- Parentheses (when precedence is already encoded in tree structure)
- Semicolons
- Commas (sometimes)
- Formatting information

## 2.2 Concrete Example: Building an AST

### Source Code:

```javascript
let x = (10 + 20) * 3;
```

### Step 1: Lexing (Tokenization)

```plaintext
KEYWORD(let)
IDENTIFIER(x)
OPERATOR(=)
PUNCTUATION(()
NUMBER(10)
OPERATOR(+)
NUMBER(20)
PUNCTUATION())
OPERATOR(*)
NUMBER(3)
PUNCTUATION(;)
```

### Step 2: The AST Result

```plaintext
VariableDeclaration
├── kind: "let"
├── id: Identifier
│       └── name: "x"
└── init: BinaryExpression
              ├── operator: "*"
              ├── left: BinaryExpression
              │           ├── operator: "+"
              │           ├── left: NumericLiteral
              │           │           └── value: 10
              │           └── right: NumericLiteral
              │                       └── value: 20
              └── right: NumericLiteral
                          └── value: 3
```

### What got THROWN AWAY:

```plaintext
(   )   ;   whitespace   let(keyword syntax itself)
```

The `(` and `)` are **gone** — but their meaning (grouping, precedence) is preserved by the tree structure itself. The fact that `+` is a child of `*` encodes the grouping.

## 2.3 Real AST Node Definitions

Let's look at how AST nodes are actually defined in code:

```typescript
// TypeScript-style AST node definitions

interface ASTNode {
  type: string;
  // NOTE: No position? Some ASTs store it, many don't
}

interface NumericLiteral extends ASTNode {
  type: "NumericLiteral";
  value: number;           // Just the number — not "10", not whitespace
}

interface Identifier extends ASTNode {
  type: "Identifier";
  name: string;            // Just the name string
}

interface BinaryExpression extends ASTNode {
  type: "BinaryExpression";
  operator: string;        // "+", "*", etc.
  left: ASTNode;           // Left child
  right: ASTNode;          // Right child
  // No parentheses stored — structure encodes this
}

interface VariableDeclaration extends ASTNode {
  type: "VariableDeclaration";
  kind: "var" | "let" | "const";
  id: Identifier;
  init: ASTNode | null;
  // No ";" stored
  // No "=" stored
}
```

## 2.4 A More Complex AST Example

### Source Code:

```python
# Calculate area
def calculate_area(width, height):
    result = width * height
    return result
```

### The AST:

```plaintext
Module
└── FunctionDef
        ├── name: "calculate_area"
        ├── args: Arguments
        │           ├── arg: "width"
        │           └── arg: "height"
        └── body: [
                    Assign
                    ├── target: Name("result")
                    └── value: BinaryOp
                                ├── op: Mult
                                ├── left: Name("width")
                                └── right: Name("height")
                    ,
                    Return
                    └── value: Name("result")
                  ]
```

### What's MISSING from the AST:

```plaintext
# Calculate area        ← comment, completely gone
def                     ← keyword presence implied by FunctionDef node type
( ) :                   ← punctuation, gone
    (indentation)       ← gone
```

**The comment is completely erased.** This is fine for a compiler — it doesn't affect execution. But it's **catastrophic for a code formatter or IDE**.

---

# PART 3: THE PROBLEM WITH AST FOR TOOLING

## 3.1 The Reconstruction Problem

If you have an AST and you want to **reprint the original source code**, you **cannot**. You would have to make up:

- How many spaces after `=`?
- Was there a trailing newline?
- Did the user write `1+1` or `1 + 1`?
- Were there any comments? Where were they?

This is called the **round-trip problem**: `source → AST → source` **does not give you back the original source**.

## 3.2 Real Consequences

|Tool|Problem with AST|
|---|---|
|**Code Formatter** (Prettier)|Can't preserve original formatting decisions|
|**Refactoring Tool**|Moves code but loses comments attached to it|
|**IDE Syntax Highlighting**|AST doesn't know where every token is positioned|
|**Error Recovery**|Broken code often can't form valid AST|
|**Incremental Parsing**|Can't efficiently update tree for single character changes|
|**Semantic Highlighting**|Need exact token positions|

---

# PART 4: LOSSLESS SYNTAX TREE (LST) / CONCRETE SYNTAX TREE (CST)

## 4.1 Core Philosophy

> **"Keep EVERYTHING. Every character of source code must be recoverable from the tree. The tree IS the source code."**

An LST (also called CST — Concrete Syntax Tree, or "full fidelity syntax tree") is a **complete, lossless representation** where:

- Every token is stored
- All whitespace is stored
- All comments are stored
- All punctuation is stored
- The original source = concatenating all leaf nodes

## 4.2 The Golden Rule of LST

```plaintext
tree.root.fullText() === originalSourceCode
```

**This equality must always hold.** Always. No exceptions.

## 4.3 Building the Same Example as LST

### Source Code:

```javascript
let x = (10 + 20) * 3;
```

### The LST:

```plaintext
VariableDeclaration
├── LetKeyword          → "let"
├── WhitespaceTrivia    → " "
├── Identifier          → "x"
├── WhitespaceTrivia    → " "
├── EqualsToken         → "="
├── WhitespaceTrivia    → " "
└── BinaryExpression [* expression]
        ├── ParenthesizedExpression
        │       ├── OpenParenToken      → "("
        │       └── BinaryExpression [+ expression]
        │               ├── NumericLiteral  → "10"
        │               ├── WhitespaceTrivia → " "
        │               ├── PlusToken       → "+"
        │               ├── WhitespaceTrivia → " "
        │               └── NumericLiteral  → "20"
        │       └── CloseParenToken     → ")"
        ├── WhitespaceTrivia    → " "
        ├── AsteriskToken       → "*"
        ├── WhitespaceTrivia    → " "
        └── NumericLiteral      → "3"
└── SemicolonToken      → ";"
```

Now notice: If you **concatenate every leaf node** in order:

```plaintext
"let" + " " + "x" + " " + "=" + " " + "(" + "10" + " " + "+" + " " + "20" + ")" + " " + "*" + " " + "3" + ";"
= "let x = (10 + 20) * 3;"
```

✅ **Exact original source recovered!**

## 4.4 The Trivia System — Key Innovation

The most important design decision in modern LST implementations is **trivia**.

### What is Trivia?

Trivia is any content that **doesn't affect semantics** but **must be preserved**:

- Whitespace
- Newlines
- Comments (single-line `//`, multi-line `/* */`, doc comments `/** */`)
- Preprocessor directives (in some languages)
- Byte Order Marks (BOM)

### How Trivia is Attached

Every token owns trivia in two buckets:

```plaintext
┌─────────────────────────────────────────────────────────┐
│  LEADING TRIVIA  │  TOKEN ITSELF  │  TRAILING TRIVIA    │
└─────────────────────────────────────────────────────────┘
```

But most LST implementations use a simpler rule:

> **Leading trivia belongs to the NEXT token. Trailing trivia belongs to the CURRENT token.**

Or alternatively (used by Roslyn/C#):

> **Every token has leading trivia. The last token has trailing trivia (EOF's leading trivia).**

### Trivia Example with Comments:

```javascript
// This calculates sum
let result = a + b; // inline comment
```

Token trivia breakdown:

```plaintext
Token: "let"
  LeadingTrivia:  [LineComment("// This calculates sum"), Newline("\n")]
  TrailingTrivia: [Whitespace(" ")]

Token: "result"
  LeadingTrivia:  []
  TrailingTrivia: [Whitespace(" ")]

Token: "="
  LeadingTrivia:  []
  TrailingTrivia: [Whitespace(" ")]

Token: "a"
  LeadingTrivia:  []
  TrailingTrivia: [Whitespace(" ")]

Token: "+"
  LeadingTrivia:  []
  TrailingTrivia: [Whitespace(" ")]

Token: "b"
  LeadingTrivia:  []
  TrailingTrivia: []

Token: ";"
  LeadingTrivia:  []
  TrailingTrivia: [Whitespace(" "), LineComment("// inline comment"), Newline("\n")]
```

## 4.5 Complete LST Example with Comments

### Source Code:

```javascript
// Calculate area
function area(w, h) {
    /* multiply dimensions */
    return w * h;
}
```

### Full LST:

```plaintext
SourceFile
├── FunctionDeclaration
│       ├── [LeadingTrivia: LineComment("// Calculate area"), Newline]
│       ├── FunctionKeyword → "function"
│       ├── [Trivia: Space]
│       ├── Identifier → "area"
│       ├── OpenParenToken → "("
│       ├── Parameter
│       │       └── Identifier → "w"
│       ├── CommaToken → ","
│       ├── [Trivia: Space]
│       ├── Parameter
│       │       └── Identifier → "h"
│       ├── CloseParenToken → ")"
│       ├── [Trivia: Space]
│       └── Block
│               ├── OpenBraceToken → "{"
│               ├── [Trivia: Newline, 4xSpace]
│               ├── ReturnStatement
│               │       ├── [LeadingTrivia: BlockComment("/* multiply dimensions */"), Newline, 4xSpace]
│               │       ├── ReturnKeyword → "return"
│               │       ├── [Trivia: Space]
│               │       ├── BinaryExpression
│               │       │       ├── Identifier → "w"
│               │       │       ├── [Trivia: Space]
│               │       │       ├── AsteriskToken → "*"
│               │       │       ├── [Trivia: Space]
│               │       │       └── Identifier → "h"
│               │       └── SemicolonToken → ";"
│               ├── [Trivia: Newline]
│               └── CloseBraceToken → "}"
└── EndOfFileToken → ""
    [LeadingTrivia: Newline]
```

---

# PART 5: INTERNAL WORKINGS OF LST — DEEP DIVE

## 5.1 Node Categories in LST

Modern LST implementations (like Roslyn, rust-analyzer, tree-sitter) distinguish between:

### Category 1: SyntaxToken (LEAF nodes)

These are the **terminal nodes** — actual text content.

```typescript
interface SyntaxToken {
  kind: TokenKind;          // What TYPE of token (keyword, operator, etc.)
  text: string;             // The actual text: "let", "+", "myVar"
  leadingTrivia: Trivia[];  // Whitespace/comments BEFORE this token
  trailingTrivia: Trivia[]; // Whitespace/comments AFTER this token
  
  // Positional information
  position: number;         // Absolute position in source file
  
  // Derived properties
  get fullText(): string {  // leadingTrivia + text + trailingTrivia
    return this.leadingTrivia.map(t => t.text).join('') 
         + this.text 
         + this.trailingTrivia.map(t => t.text).join('');
  }
  
  get fullWidth(): number { // Total width including trivia
    return this.fullText.length;
  }
  
  get width(): number {     // Width WITHOUT trivia
    return this.text.length;
  }
}
```

### Category 2: SyntaxNode (INTERNAL nodes)

These are **non-terminal nodes** — they have children.

```typescript
interface SyntaxNode {
  kind: SyntaxKind;           // What type of syntax construct
  children: (SyntaxNode | SyntaxToken)[];  // Children
  parent: SyntaxNode | null;  // Parent reference
  
  // Derived
  get fullText(): string {
    // Concatenate all children's fullText
    return this.children.map(c => c.fullText).join('');
  }
  
  get span(): TextSpan {
    // Start and end position in file
    return { start: this.position, end: this.position + this.fullWidth };
  }
}
```

### Category 3: SyntaxTrivia

```typescript
interface SyntaxTrivia {
  kind: TriviaKind;   // Whitespace, NewLine, SingleLineComment, etc.
  text: string;       // The actual trivia text
  token: SyntaxToken; // The token this trivia belongs to
}

enum TriviaKind {
  Whitespace,
  EndOfLine,
  SingleLineComment,      // // comment
  MultiLineComment,       // /* comment */
  DocumentationComment,   // /** comment */
  DisabledText,           // #if false ... #endif
  ConflictMarker,         // <<<< ==== >>>> merge conflicts
}
```

## 5.2 The Green Tree / Red Tree Architecture (Roslyn's Innovation)

This is the most sophisticated LST internal architecture, used by C#'s Roslyn compiler. Understanding this reveals the TRUE internal workings.

### The Problem to Solve

An LST can have **millions of nodes** for large files. If every node stores:

- Its absolute position in the file
- A parent pointer
- Full source text

Then:

1. Memory usage explodes
2. Small edits (typing one character) require **updating position information in every subsequent node**

### Solution: TWO SEPARATE TREES

```plaintext
┌──────────────────────────────────────────────────────────┐
│                    GREEN TREE                            │
│  • Immutable                                             │
│  • Position-independent (stores only WIDTHS)            │
│  • Shareable across edits                               │
│  • No parent pointers                                   │
│  • Can be cached and reused                             │
└──────────────────────────────────────────────────────────┘
                          ↕ wraps
┌──────────────────────────────────────────────────────────┐
│                     RED TREE                             │
│  • Lazily constructed                                   │
│  • Has ABSOLUTE positions                               │
│  • Has parent pointers                                  │
│  • Created on demand when you navigate the tree        │
│  • Thrown away after use                               │
└──────────────────────────────────────────────────────────┘
```

### Green Node (Position-Independent):

```typescript
class GreenNode {
  readonly kind: SyntaxKind;
  readonly fullWidth: number;     // Width INCLUDING trivia
  readonly children: GreenNode[]; // Children (no parent pointer!)
  
  // NOTE: No position! No parent!
  // This node doesn't know WHERE it is in the file
  // It only knows HOW WIDE it is
  
  constructor(kind: SyntaxKind, children: GreenNode[]) {
    this.kind = kind;
    this.children = children;
    // Width is sum of all children's widths
    this.fullWidth = children.reduce((sum, c) => sum + c.fullWidth, 0);
  }
}

class GreenToken extends GreenNode {
  readonly text: string;
  readonly leadingTrivia: GreenTrivia[];
  readonly trailingTrivia: GreenTrivia[];
  
  // fullWidth = leadingTriviaWidth + textWidth + trailingTriviaWidth
}
```

### Red Node (Position-Aware Wrapper):

```typescript
class RedNode {
  readonly green: GreenNode;       // The underlying green node
  readonly parent: RedNode | null; // Parent RED node
  readonly position: number;       // ABSOLUTE position in file
  
  // Children are computed lazily!
  private _children: (RedNode | null)[] | null = null;
  
  get children(): RedNode[] {
    if (!this._children) {
      // Compute children's absolute positions
      let childPosition = this.position;
      this._children = this.green.children.map(greenChild => {
        const redChild = new RedNode(greenChild, this, childPosition);
        childPosition += greenChild.fullWidth; // Advance by child's width
        return redChild;
      });
    }
    return this._children;
  }
  
  // Absolute span in the source file
  get span(): { start: number; end: number } {
    return {
      start: this.position,
      end: this.position + this.green.fullWidth
    };
  }
  
  get fullText(): string {
    return this.green.fullText; // Delegate to green
  }
}
```

### How an Edit Works (The Magic):

```plaintext
Original: "let x = 10 + 20;"
Edit: User types a space → "let x  = 10 + 20;"
                                ^extra space here
```

#### Without Green/Red:

- Would need to update position of EVERY token after the edit
- On large files, this is O(n) — slow!

#### With Green/Red:

```plaintext
Step 1: Find the green token for "x"
        Old: GreenToken { text: "x", trailingTrivia: [Space(" ")] }
        New: GreenToken { text: "x", trailingTrivia: [Space("  ")] }  // Two spaces now

Step 2: Create new green nodes from bottom up
        - New GreenToken for "x" (changed)
        - New GreenNode for the VariableDeclarator (changed — wraps new "x")
        - New GreenNode for the VariableDeclaration (changed)
        - New GreenNode for the root (changed)
        
Step 3: ALL OTHER GREEN NODES are REUSED unchanged!
        The green nodes for "=", "10", "+", "20", ";" are shared
        with the old tree

Step 4: The OLD tree is still valid (immutable!)
        - Undo/redo is FREE — just keep old green roots
        - No copying needed for unchanged subtrees
```

This is called **persistent data structure** or **structural sharing**:

```plaintext
OLD TREE:                  NEW TREE:
    Root ──────────────────── Root (new)
      │                         │
  VarDecl ────────────────── VarDecl (new)
      │                         │
    "x" ←───────────────────  "x" (new, 2 spaces)
      │                         
     "=" ─────────────────── "=" (SHARED — same green node!)
      │                         
    "10" ────────────────── "10" (SHARED)
      │
    "+" ─────────────────── "+" (SHARED)
```

## 5.3 Error Recovery in LST

Unlike AST (which usually gives up on invalid code), LST **must handle errors gracefully** because IDEs need to work on incomplete code being typed.

### Strategies:

#### 1. Missing Token Insertion

```javascript
// User typed this (missing closing paren):
let x = foo(a, b;
```

LST creates a **MissingToken** — a zero-width token with the expected kind:

```plaintext
CallExpression
├── Identifier → "foo"
├── OpenParenToken → "("
├── ArgumentList
│       ├── Identifier → "a"
│       ├── CommaToken → ","
│       └── Identifier → "b"
├── CloseParenToken → "" ← MISSING TOKEN (zero width, marks error)
└── [Error: Expected ')']
```

The tree is still **complete** and **walkable**. The error is a decoration, not a crash.

#### 2. Skipped Token Nodes

```javascript
let x = 10 @@@ 20; // "@@@" is invalid
```

The `@@@` becomes a **SkippedToken** trivia attached to the nearest real token:

```plaintext
BinaryExpression (ERROR)
├── NumericLiteral → "10"
├── [SkippedTokenTrivia: "@@@"]
└── NumericLiteral → "20"
```

#### 3. Error Nodes

Sometimes an entire region can't be parsed:

```plaintext
ErrorNode
├── fullText: "@@@ totally broken !!!"
└── diagnostics: [ParseError("Unexpected token '@'")]
```

## 5.4 Position Tracking & Text Spans

Every node in an LST can tell you exactly where it is:

```typescript
interface TextSpan {
  start: number;  // Inclusive start offset (0-based)
  end: number;    // Exclusive end offset
  length: number; // end - start
}

interface TextSpanWithTrivia {
  fullSpan: TextSpan;  // INCLUDING leading and trailing trivia
  span: TextSpan;      // EXCLUDING leading and trailing trivia
}
```

### Example:

```javascript
  let x = 10;
// ^ position 0 (or wherever in file)
```

```plaintext
Token "let":
  position:    2     (skipping 2 spaces of leading trivia)
  fullSpan:    { start: 0, end: 5 }    // "  let "
  span:        { start: 2, end: 5 }    // "let"
  
  leadingTrivia  = "  "  (positions 0-1)
  text           = "let"  (positions 2-4)
  trailingTrivia = " "   (position 5)
```

---

# PART 6: SIDE-BY-SIDE COMPARISON

## 6.1 Same Code, Both Trees

### Source:

```javascript
// greet user
function hello(  name  ) {
    return "Hi " + name; // concatenate
}
```

### AST View:

```plaintext
FunctionDeclaration
├── id: Identifier { name: "hello" }
├── params: [ Identifier { name: "name" } ]
└── body: BlockStatement
              └── ReturnStatement
                      └── BinaryExpression
                              ├── operator: "+"
                              ├── left: StringLiteral { value: "Hi " }
                              └── right: Identifier { name: "name" }
```

- Comment `// greet user` → **GONE**
- Extra spaces `name` → **GONE**
- Comment `// concatenate` → **GONE**
- `function`, `return`, `{`, `}`, `(`, `)` keywords/punctuation → **GONE**

### LST View (simplified):

```plaintext
FunctionDeclaration
├── [LeadingTrivia: "// greet user\n"]
├── FunctionKeyword: "function"
├── [Trivia: " "]
├── Identifier: "hello"
├── OpenParenToken: "("
├── [Trivia: "  "]
├── Parameter → Identifier: "name"
├── [Trivia: "  "]
├── CloseParenToken: ")"
├── [Trivia: " "]
└── Block
        ├── OpenBraceToken: "{"
        ├── [Trivia: "\n    "]
        ├── ReturnStatement
        │       ├── ReturnKeyword: "return"
        │       ├── [Trivia: " "]
        │       ├── BinaryExpression
        │       │       ├── StringLiteral: '"Hi "'
        │       │       ├── [Trivia: " "]
        │       │       ├── PlusToken: "+"
        │       │       ├── [Trivia: " "]
        │       │       └── Identifier: "name"
        │       └── SemicolonToken: ";"
        │           [TrailingTrivia: " // concatenate\n"]
        ├── [Trivia: ""]
        └── CloseBraceToken: "}"
```

Concatenate all text → `"// greet user\nfunction hello( name ) {\n return \"Hi \" + name; // concatenate\n}"` ✅

## 6.2 Feature Comparison Table

|Feature|AST|LST/CST|
|---|---|---|
|**Semantic meaning preserved**|✅|✅|
|**Comments preserved**|❌|✅|
|**Whitespace preserved**|❌|✅|
|**Can reconstruct original source**|❌|✅|
|**Handles invalid syntax**|❌ Often fails|✅ Gracefully|
|**Memory footprint**|Small|Large|
|**Tree complexity**|Simple|Complex|
|**Good for compilation**|✅|Overkill|
|**Good for IDE features**|Poor|✅|
|**Good for formatters**|❌|✅|
|**Good for refactoring**|Partial|✅|
|**Incremental updates**|Hard|✅ Efficient|

---

# PART 7: REAL-WORLD LST IMPLEMENTATIONS

## 7.1 Roslyn (C# / VB.NET)

```csharp
// Using Roslyn's LST API
var tree = CSharpSyntaxTree.ParseText(@"
    // My method
    int Add(int a, int b) => a + b;
");

var root = tree.GetRoot();

// Walking the tree
foreach (var token in root.DescendantTokens())
{
    Console.WriteLine($"Token: '{token.Text}'");
    
    // Access trivia
    foreach (var trivia in token.LeadingTrivia)
    {
        Console.WriteLine($"  Leading Trivia: {trivia.Kind()} = '{trivia.ToString()}'");
    }
}

// The key property: full text round-trips perfectly
Debug.Assert(root.ToFullString() == originalSource);

// Get exact position
var methodDecl = root.DescendantNodes()
                     .OfType<MethodDeclarationSyntax>()
                     .First();
                     
Console.WriteLine(methodDecl.Span);      // Without trivia
Console.WriteLine(methodDecl.FullSpan);  // With trivia
```

## 7.2 Tree-sitter

Tree-sitter is a LST library used by many code editors (Neovim, GitHub, Helix):

```javascript
// Tree-sitter JavaScript example
const Parser = require('tree-sitter');
const JavaScript = require('tree-sitter-javascript');

const parser = new Parser();
parser.setLanguage(JavaScript);

const sourceCode = `
// compute
let result = a + b;
`;

const tree = parser.parse(sourceCode);

// Tree-sitter gives you named + anonymous (punctuation) nodes
function printTree(node, indent = 0) {
  const prefix = ' '.repeat(indent);
  if (node.isNamed) {
    console.log(`${prefix}[${node.type}] "${node.text}"`);
  } else {
    // Anonymous nodes = punctuation, keywords
    console.log(`${prefix}"${node.text}"`);
  }
  for (const child of node.children) {
    printTree(child, indent + 2);
  }
}

printTree(tree.rootNode);

// Incremental parsing — just pass the old tree!
const newSource = `
// compute
let result = a + b + c;  // added c
`;

const newTree = parser.parse(newSource, tree); // Reuses unchanged nodes!
```

## 7.3 rust-analyzer's rowan library

Rust's language server uses a green/red tree implementation:

```rust
// Conceptual rowan usage (simplified)
use rowan::{GreenNode, SyntaxNode, SyntaxToken};

// Green nodes are cheap to clone — they're reference counted
let green: GreenNode = parse("let x = 1 + 2;");

// Red nodes are created on-demand
let red: SyntaxNode = SyntaxNode::new_root(green.clone());

// Walking
for token in red.descendants_with_tokens() {
    match token {
        NodeOrToken::Token(t) => {
            println!("Token: {:?} = {:?}", t.kind(), t.text());
        }
        NodeOrToken::Node(n) => {
            println!("Node: {:?}", n.kind());
        }
    }
}

// The invariant holds
assert_eq!(red.text().to_string(), "let x = 1 + 2;");

// After an edit, most green nodes are shared
let new_green = modify(green, edit);
// Only O(depth) new nodes created, rest are shared
```

---

# PART 8: MENTAL MODEL SUMMARY

```plaintext
SOURCE CODE (string of characters)
         │
         ▼
    ┌─────────┐
    │  LEXER  │  ← Produces tokens
    └─────────┘
         │
         ▼
    ┌──────────────────────────────────────────┐
    │               PARSER                     │
    │                                          │
    │  Takes token stream                      │
    │  Applies grammar rules                   │
    │  Builds tree                             │
    └──────────────────────────────────────────┘
         │                    │
         ▼                    ▼
    ┌─────────┐          ┌─────────┐
    │   AST   │          │   LST   │
    │         │          │         │
    │ Throws  │          │ Keeps   │
    │ away:   │          │ ALL:    │
    │ • spaces│          │ • spaces│
    │ • commas│          │ • commas│
    │ • ()    │          │ • ()    │
    │ •  ;    │          │ • ;     │
    │ • //    │          │ • //    │
    │ • /**/  │          │ • /**/  │
    └─────────┘          └─────────┘
         │                    │
         ▼                    ▼
    Used by:             Used by:
    • Compilers          • IDEs (VS Code)
    • Type checkers      • Formatters
    • Linters            • Refactoring tools
    • Transpilers        • Syntax highlighting
                         • Code search
                         • Language servers
```

## The Single Most Important Concept:

> **An AST answers "What does this code MEAN?"** **An LST answers "What does this code LOOK LIKE, exactly, character by character?"**

Both representations are trees of the same source code — but LST is the **complete**, **lossless**, **invertible** representation, while AST is the **semantic**, **compressed**, **irreversible** representation.

The key internal workings of LST:

1. **Every token is stored** (no structural discarding)
2. **Trivia system** attaches whitespace/comments to tokens
3. **Green/Red split** enables efficient immutable updates
4. **Structural sharing** means edits only create O(depth) new nodes
5. **Error recovery** creates Missing/Skipped tokens so the tree is always complete
6. **Position tracking** gives every node an exact file location
7. **Round-trip guarantee**: `concatenate(all leaves) === originalSource` always