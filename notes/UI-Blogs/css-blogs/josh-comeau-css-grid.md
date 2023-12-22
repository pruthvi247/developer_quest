## Mental model

CSS is comprised of several different [layout algorithms](https://www.joshwcomeau.com/css/understanding-layout-algorithms/), each designed for different types of user interfaces. The default layout algorithm, Flow layout, is designed for digital documents. Table layout is designed for tabular data. Flexbox is designed for distributing items along a single axis.

CSS Grid is the latest and greatest layout algorithm. It's _incredibly_ powerful: we can use it to build complex layouts that fluidly adapt based on a number of constraints.

The most unusual part of CSS Grid, in my opinion, is that the grid _structure_, the rows and columns, are defined **purely in CSS:**
![[Pasted image 20231222112259.png]]
With CSS Grid, a single DOM node is sub-divided into rows and columns. In this tutorial, we're highlighting the rows/columns with dashed lines, but in reality, they're invisible.

_This is super weird!_ In every other layout mode, the only way to create compartments like this is by adding more DOM nodes. In Table layout, for example, each row is created with a `<tr>`, and each cell within that row using `<td>` or `<th>`:
Unlike Table layout, CSS Grid lets us manage the layout entirely from within CSS. We can slice up the container however we wish, creating compartments that our grid children can use as anchors.
## Grid flow

We opt in to the Grid layout mode with the `display` property:
```css
.wrapper {
  display: grid;
}
```
By default, CSS Grid uses a single column, and will create rows as needed, based on the number of children. This is known as an _implicit grid_, since we aren't explicitly defining any structure.
By default, the height of the grid parent is determined by its children. It grows and shrinks dynamically. Interestingly, this isn't even a “CSS Grid” thing; the grid _parent_ is still using Flow layout, and block elements in Flow layout grow vertically to contain their content. Only the _children_ are arranged using Grid layout.
But what if we give the grid a fixed height? In that case, the total surface area is divided into equally-sized rows:
```css
.parent {
  display: grid;
  height: 300px;
}
```
## Grid Construction

By default, CSS Grid will create a single-column layout. We can specify columns using the `grid-template-columns` property:
```css
<style>
  .parent {
    display: grid;
    grid-template-columns: 25% 75%;
  }
  /*
  This tab has a bunch of cosmetic
  styles, to make the demo clearer.
*/

body {
  background: hsl(210deg 30% 12%);
}
.parent {
  --padding: 4px;
  position: relative;
  padding: var(--padding);
  border: 1px solid hsl(210deg 10% 40%);
  border-radius: 8px;
}
/*
  Add a dashed line between the
  two children, to indicate
  approximately where the grid
  column line is.
*/
.parent::after {
  content: '';
  position: absolute;
  top: 2px;
  bottom: 2px;
  left: calc(
    25% +
    var(--padding) / 2 -
    1px
  );
  border-left:
    2px dashed
    hsl(210deg 8% 50%);
}
.child {
  display: grid;
  place-content: center;
  height: 100px;
  border:
    2px solid hsl(210deg 8% 50%);
  border-radius: 3px;
  background: hsl(210deg 15% 20%);
  color: white;
  font-size: 1.325rem;
  font-weight: bold;
}
/*
  Add 1px space around the grid
  line, to make it less subtle.
  
  Normally, I'd use the `gap`
  property to do this, but as
  we'll see, this property doesn't
  work well with percentages
*/
.child:first-child {
  margin-right: 2px;
}
.child:last-child {
  margin-left: 2px;
}
</style>

<div class="parent">
  <div class="child">1</div>
  <div class="child">2</div>
</div>
```
![[Pasted image 20231222132557.png]]
By passing two values to `grid-template-columns` — `25%` and `75%` — I'm telling the CSS Grid algorithm to slice the element up into two columns.

Columns can be defined using any valid [CSS < length-percentage > value](https://developer.mozilla.org/en-US/docs/Web/CSS/length-percentage), including pixels, rems, viewport units, and so on. Additionally, we also gain access to a new unit, the `fr` unit:0

**Dashed lines added for clarity**

In the playground above, and throughout this tutorial, I'm using dashed lines to show the divisions between columns and rows. In CSS grid, these lines are invisible, and can't be made visible.

I'm using some ✨ _blog magic_ ✨ here, faking it with pseudo-elements. You can pop over to the “CSS” tab if you'd like to see how.
```css
<style>
  .parent {
    display: grid;
    grid-template-columns: 1fr 3fr;
  }
</style>
```
`fr` stands for “fraction”. In this example, we're saying that the first column should consume 1 unit of space, while the second column consumes 3 units of space. That means there are 4 total units of space, and this becomes the denominator. The first column eats up ¼ of the available space, while the second column consumes ¾.

The `fr` unit brings Flexbox-style flexibility to CSS Grid. Percentages and `<length>` values create hard constraints, while `fr` columns are free to grow and shrink as required, to contain their contents.

To be more precise: the `fr` unit distributes _extra_ space. First, column widths will be calculated based on their contents. If there's any leftover space, it'll be distributed based on the `fr` values. This is very similar to `flex-grow`, as discussed in my [Interactive Guide to Flexbox](https://www.joshwcomeau.com/css/interactive-guide-to-flexbox/)
In general, this flexibility is a good thing. Percentages are too strict.

We can see a perfect example of this with `gap`. `gap` is a magical CSS property that adds a fixed amount of space between all of the columns and rows within our grid.
Check out what happens when we toggle between percentages and fractions:
![[Pasted image 20231222133209.png]]
![[Pasted image 20231222133223.png]]
Notice how the contents spill outside the grid parent when using percentage-based columns? This happens because percentages are calculated using the _total_ grid area. The two columns consume 100% of the parent's content area, and they aren't allowed to shrink. When we add 16px of `gap`, the columns have no choice but to spill beyond the container.

The `fr` unit, by contrast, is calculated based on the _extra_ space. In this case, the extra space has been reduced by 16px, for the `gap`. The CSS Grid algorithm distributes the remaining space between the two grid columns.

**`gap` vs. `grid-gap`**

When CSS Grid was first introduced, the `grid-gap` property was used to add space between columns and rows. Pretty quickly, however, the community realized that this feature would be _awesome_ to have in Flexbox as well. And so, the property was given a more-generic name, `gap`.

These days, `grid-gap` has been marked as deprecated, and browsers have aliased it to `gap`. Both properties do the exact same thing. And they both have nearly-identical browser support*, [around 96%](https://caniuse.com/?search=grid-gap).

And so, I recommend using `gap` rather than `grid-gap`, whether you're working with Flexbox or CSS Grid. But there's also no urgency when it comes to converting existing `grid-gap` declarations.

### [Implicit and explicit rows](https://www.joshwcomeau.com/css/interactive-guide-to-grid/#implicit-and-explicit-rows-4)
What happens if we add more than two children to a two-column grid?
Well, let's give it a shot:
```css
<style>
  .parent {
    display: grid;
    grid-template-columns: 1fr 3fr;
  }
</style>

<div class="parent">
  <div class="child">1</div>
  <div class="child">2</div>
  <div class="child">3</div>
</div>
```
Interesting! Our grid gains a second row. The grid algorithm wants to ensure that every child has its own grid cell. It’ll spawn new rows as-needed to fulfill this goal. This is handy in situations where we have a variable number of items (eg. a photo grid), and we want the grid to expand automatically.

In other situations, though, we want to define the rows explicitly, to create a specific layout. We can do that with the `grid-template-rows` property:
```css
<style>
  .parent {
    display: grid;
    grid-template-columns: 1fr 3fr;
    grid-template-rows: 5rem 1fr;
  }
  /*
  This tab has a bunch of cosmetic
  styles, to make the demo clearer.
*/

body {
  background: hsl(210deg 30% 12%);
  padding: 0;
  margin: 0;
}
.parent {
  --padding: 4px;
  position: relative;
  padding: var(--padding);
  border: 1px solid hsl(210deg 10% 40%);
  border-radius: 8px;
  gap: 8px;
  height: 100vh;
  height: 100svh;
}
.parent::before {
  content: '';
  position: absolute;
  top: calc(5rem + 7px);
  left: 2px;
  right: 2px;
  border-bottom:
    2px dashed hsl(210deg 8% 50%);
}
.parent::after {
  content: '';
  position: absolute;
  top: 2px;
  bottom: 2px;
  left: calc(
    25% +
    var(--padding) / 2 +
    1px
  );
  border-left:
    2px dashed hsl(210deg 8% 50%);
}
.child {
  display: grid;
  place-content: center;
  border:
    2px solid hsl(210deg 8% 50%);
  border-radius: 3px;
  background: hsl(210deg 15% 20%);
  color: white;
  font-size: 1.325rem;
  font-weight: bold;
}
</style>

<div class="parent">
  <div class="child"></div>
  <div class="child"></div>
  <div class="child"></div>
  <div class="child"></div>
</div>
```
By defining both `grid-template-rows` and `grid-template-columns`, we've created an explicit grid. This is perfect for building page layouts, like the “Holy Grail”? layout at the top of this tutorial.
### The repeat helper

Let's suppose we're building a calendar:
CSS Grid is a wonderful tool for this sort of thing. We can structure it as a 7-column grid, with each column consuming 1 unit of space:
```css
.calendar {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr 1fr 1fr 1fr;
}
```
This _works_, but it's a bit annoying to have to count each of those `1fr`’s. Imagine if we had 50 columns!

Fortunately, there's a nicer way to solve for this:
```css
.calendar {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
}
```
The `repeat` function will do the copy/pasting for us. We're saying we want 7 columns that are each `1fr` wide.

## Assigning children

By default, the CSS Grid algorithm will assign each child to the first unoccupied grid cell, much like how a tradesperson might lay tiles in a bathroom floor.

**Here's the cool thing though:** we can assign our items to whichever cells we want! Children can even span across multiple rows/columns.

Here's an interactive demo that shows how this works
```css
.parent {
  display: grid;
  grid-template-columns:
    repeat(4, 1fr);
  grid-template-rows:
    repeat(4, 1fr);
}
.child {
  grid-row: 1 / 5;
  grid-column: 2;
}
```
The `grid-row` and `grid-column` properties allow us to specify which track(s) our grid child should occupy.

If we want the child to occupy a single row or column, we can specify it by its number. `grid-column: 3` will set the child to sit in the third column.Grid children can also stretch across multiple rows/columns. 
```css
.child {
  grid-column: 1 / 4;
}
```
At first glance, this looks like a fraction, ¼. In CSS, though, the slash character is not used for division, it's used to separate groups of values. In this case, it allows us to set the start and end columns in a single declaration.

It's essentially a shorthand for this:
```css
.child {
  grid-column-start: 1;
  grid-column-end: 4;
}
```
**There's a sneaky gotcha here:** The numbers we're providing are based on the column _lines_, not the column indexes.

It'll be easiest to understand this gotcha with a diagram:
![[Pasted image 20231222134356.png]]
Confusingly, a 4-column grid actually has _5_ column lines. When we assign a child to our grid, we anchor them using these lines. If we want our child to span the first 3 columns, it needs to start on the 1st line and end on the 4th line.

**Negative line numbers**
In a left-to-right language like English, we count the columns from left to right. With negative line numbers, however, we can also count in the _opposite_ direction, from right to left.
```css
.child {
  /* Sit in the 2nd column from the right: */
  grid-column: -2;
}
```
The really cool thing is that we can mix positive and negative numbers. Check this out:
```css
.parent {
  display: grid;
  grid-template-columns:
    repeat(3, 1fr);
}
.child {
  grid-column: 1 / -1;
  grid-row: 2;
}
```
Notice that the child spans the full width of the grid, even though we aren't changing the `grid-column` assignment at all!

We're saying here that our child should span from the first column line to the last column line. No matter how many columns there are,this handy declaration will work as intended.

You can see a practical use case for this trick in my blog post, [“Full-Bleed Layout Using CSS Grid”](https://www.joshwcomeau.com/css/full-bleed/).
### Grid areas

Alright, time to talk about one of the coolest parts of CSS Grid. 😄

Let's suppose we're building this layout:
![[Pasted image 20231222134735.png]]
This works, but there's a more ergonomic way to do this: _grid areas._
Here's what it looks like:
![[Pasted image 20231222134910.png]]
```css
.parent {
  display: grid;
  grid-template-columns: 2fr 5fr;
  grid-template-rows: 50px 1fr;
  grid-template-areas:
    'sidebar header'
    'sidebar main';
}
.child {
  grid-area: sidebar;
}
```
![[Pasted image 20231222134945.png]]
```css
.parent {
  display: grid;
  grid-template-columns: 2fr 5fr;
  grid-template-rows: 50px 1fr;
  grid-template-areas:
    'sidebar header'
    'sidebar main';
}
.child {
  grid-area: header;
}
```
![[Pasted image 20231222135015.png]]
```css
.parent {
  display: grid;
  grid-template-columns: 2fr 5fr;
  grid-template-rows: 50px 1fr;
  grid-template-areas:
    'sidebar header'
    'sidebar main';
}
.child {
  grid-area: main;
}
```
Like before, we're defining the grid structure with `grid-template-columns` and `grid-template-rows`. But then, we have this curious declaration:
```css
.parent {
  grid-template-areas:
    'sidebar header'
    'sidebar main';
}
```
**Here's how this works:** We're drawing out the grid we want to create, almost as if we were making ASCII art?. Each line represents a row, and each word is a name we're giving to a particular slice of the grid. See how it sorta looks like the grid, visually?

Then, instead of assigning a child with `grid-column` and `grid-row`, we assign it with `grid-area`!

When we want a particular area to span multiple rows or columns, we can repeat the name of that area in our template. In this example, the “sidebar” area spans both rows, and so we write `sidebar` for both cells in the first column.

**Should we use areas, or rows/columns?** When building explicit layouts like this, I really like using areas. It allows me to give semantic meaning to my grid assignments, instead of using inscrutable row/column numbers. That said, areas work best when the grid has a fixed number of rows and columns. `grid-column` and `grid-row` can be useful for implicit grids.
### [Being mindful of keyboard users](https://www.joshwcomeau.com/css/interactive-guide-to-grid/#being-mindful-of-keyboard-users-8)

There's a big gotcha when it comes to grid assignments: **tab order will still be based on _DOM position,_ not grid position.**

It'll be easier to explain with an example. In this playground, I've set up a group of buttons, and arranged them with CSS Grid:
```css
<div class="wrapper">
  <button class="btn one">
    One
  </button>
  <button class="btn four">
    Four
  </button>
  <button class="btn six">
    Six
  </button>
  <button class="btn two">
    Two
  </button>
  <button class="btn five">
    Five
  </button>
  <button class="btn three">
    Three
  </button>
</div>
```
In the “RESULT” pane, the buttons appear to be in order. By reading from left to right, and from top to bottom, we go from one to six.

**If you're using a device with a keyboard, try to tab through these buttons.** You can do this by clicking the first button in the top left (“One”), and then pressing Tab to move through the buttons one at a time.
The focus outline jumps around the page without rhyme or reason, from the user's perspective. This happens because the buttons are being focused based on the order they appear in the DOM.

To fix this, we should re-order the grid children in the DOM so that they match the visual order, so that I can tab through from left to right, and from top to bottom.*
## [Alignment](https://www.joshwcomeau.com/css/interactive-guide-to-grid/#alignment-9)

In all the examples we've seen so far, our columns and rows stretch to fill the entire grid container. This doesn't need to be the case, however!

For example, let's suppose we define two columns that are each 90px wide. As long as the grid parent is larger than 180px, there will be some dead space at the end:
![[Pasted image 20231222135633.png]]
We can control the distribution of the columns using the `justify-content` property:
```css
.parent {
  display: grid;
  grid-template-columns: 90px 90px;
  justify-content: space-around;
}
```
![[Pasted image 20231222135725.png]]
![[Pasted image 20231222135748.png]]
If you're familiar with the Flexbox layout algorithm, this probably feels pretty familiar. CSS Grid builds on the alignment properties first introduced with Flexbox, taking them even further.

**The big difference is that we're aligning the _columns_, not the items themselves.** Essentially, `justify-content` lets us arrange the compartments of our grid, distributing them across the grid however we wish.

If we want to align the items themselves _within_ their columns, we can use the `justify-items` property:
```css
.parent {
  display: grid;
  grid-template-columns: 90px 90px;
  justify-content: space-between;
  justify-items: center;
}
```
![[Pasted image 20231222140447.png]]
![[Pasted image 20231222140510.png]]
When we plop a DOM node into a grid parent, the default behaviour is for it to stretch across that entire column, just like how a `<div>` in Flow layout will stretch horizontally to fill its container. With `justify-items`, however, we can tweak that behaviour.

This is useful because it allows us to break free from the rigid symmetry of columns. When we set `justify-items` to something other than `stretch`, the children will shrink down to their default width, as determined by their contents. As a result, items in the same column can be different widths.

We can even control the alignment of a _specific_ grid child using the `justify-self` property:
When we plop a DOM node into a grid parent, the default behaviour is for it to stretch across that entire column, just like how a `<div>` in Flow layout will stretch horizontally to fill its container. With `justify-items`, however, we can tweak that behaviour.

This is useful because it allows us to break free from the rigid symmetry of columns. When we set `justify-items` to something other than `stretch`, the children will shrink down to their default width, as determined by their contents. As a result, items in the same column can be different widths.

We can even control the alignment of a _specific_ grid child using the `justify-self` property:
```css
.parent {
  display: grid;
  grid-template-columns: 90px 90px;
  justify-content: start;
}
.one {
  justify-self: start;
}
```
![[Pasted image 20231222141303.png]]
Unlike `justify-items`, which is set on the grid parent and controls the alignment of _all_ grid children, `justify-self` is set on the child. We can think of `justify-items` as a way to set a default value for `justify-self` on all grid children.

### Aligning rows

So far, we've been talking about how to align stuff in the _horizontal_ direction. CSS Grid provides an additional set of properties to align stuff in the _vertical_ direction:
![[Pasted image 20231222141448.png]]
`align-content` is like `justify-content`, but it affects rows instead of columns. Similarly, `align-items` is like `justify-items`, but it handles the _vertical_ alignment of items inside their grid area, rather than horizontal.

To break things down even further:
- `justify` — deals with _columns_.
- `align` — deals with _rows_.
- `content` — deals with the _grid structure_.   
- `items` — deals with the _DOM nodes_ within the grid structure.

Finally, in addition to `justify-self`, we also have `align-self`. This property controls the vertical position of a single grid item within its cell.
### Two-line centering trick

There's one last thing I want to show you. It's one of my favourite little tricks with CSS Grid.

Using only two CSS properties, we can center a child within a container, both horizontally and vertically:
```css
.parent {
  display: grid;
  place-content: end;
}
```
![[Pasted image 20231222141729.png]]
The `place-content` property is a shorthand. It's syntactic sugar for this:
```css
.parent {
  justify-content: end;
  align-content: end;
}
```
As we've learned, `justify-content` controls the position of columns. `align-content` controls the position of rows. In this situation, we have an implicit grid with a single child, and so we wind up with a 1×1 grid. `place-content: center` pushes both the row and column to the center.

There are lots of ways to center a div in modern CSS, but this is the only way I know of that only requires two CSS declarations!
## Tip of the iceberg

In this tutorial, we've covered some of the most fundamental parts of the CSS Grid layout algorithm, but honestly, there's _so much more stuff_ we haven't talked about!

Also read : https://www.joshwcomeau.com/css/full-bleed/












