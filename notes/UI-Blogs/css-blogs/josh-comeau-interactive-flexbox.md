[source](https://www.joshwcomeau.com/css/interactive-guide-to-flexbox/)
## Flex direction

As mentioned, Flexbox is all about controlling the distribution of elements in a row or column. By default, items will stack side-by-side in a row, but we can flip to a column with the `flex-direction` property:
With `flex-direction: row`, the _primary axis_ runs horizontally, from left to right. When we flip to `flex-direction: column`, the primary axis runs vertically, from top to bottom.

**In Flexbox, everything is based on the primary axis.** The algorithm doesn't care about vertical/horizontal, or even rows/columns. All of the rules are structured around this primary axis, and the _cross axis_ that runs perpendicularly.

The children will be positioned by default according to the following 2 rules:

1. **Primary axis:** Children will be bunched up at the _start_ of the container.
2. **Cross axis:** Children will stretch out to fill the entire container.
![[Pasted image 20231113193336.png]]
In Flexbox, we decide whether the primary axis runs horizontally or vertically. This is the root that all Flexbox calculations are pegged to.

## Alignment

We can change how children are distributed along the primary axis using the `justify-content` property:
![[Pasted image 20231113193543.png]]
When it comes to the primary axis, we don't generally think in terms of aligning a single child. Instead, it's all about the _distribution of the group._

We can bunch all the items up in a particular spot (with `flex-start`, `center`, and `flex-end`), or we can spread them apart (with `space-between`, `space-around`, and `space-evenly`).

**For the cross axis, things are a bit different.** We use the `align-items` property:
![[Pasted image 20231113193731.png]]
It's interesting… With `align-items`, we have _some_ of the same options as `justify-content`, but there isn't a perfect overlap.
![[Pasted image 20231113193909.png]]

Unlike `justify-content` and `align-items`, `align-self` is applied to the _child element_, not the container. It allows us to change the alignment of a specific child along the cross axis:
![[Pasted image 20231113194015.png]]
`align-self` has all the same values as `align-items`. In fact, **they change the exact same thing.** `align-items` is _syntactic sugar_, a convenient shorthand that automatically sets the alignment on all the children at once.
There is no `justify-self`*. To understand why not, we need to dig deeper into the Flexbox algorithm.

### Content vs. items
So, based on what we've learned so far, Flexbox might seem pretty arbitrary. Why is it `justify-content` and `align-items`, and not `justify-_items_`, or `align-_content_`?
For that matter, why is there an `align-self`, but not a `_justify_-self`??

In Flexbox, items are distributed along the primary axis. By default, they're nicely lined up, side-by-side. I can draw a straight horizontal line that skewers _all_ of the children, like a kebab?

The cross axis is different, though. A straight vertical line will only ever intersect _one_ of the children.
It's less like a kebab, and more like a group of cocktail wieners?:

There's a significant difference here. With the cocktail wieners, each item can move along its stick _without interfering_ with any of the other items:
![[Pasted image 20231113194403.png]]
By contrast, with our primary axis skewering each sibling, a single item _can’t_ move along its stick without bumping into its siblings! 
![[Pasted image 20231113194613.png]]
**This is the fundamental difference between the primary/cross axis.** When we're talking about alignment in the _cross_ axis, each item can do whatever it wants. In the _primary_ axis, though, we can only think about how to distribute the _group_.
**That's why there's no** `justify-self`**.** What would it mean for that middle piece to set `justify-self: flex-start`? There's already another piece there!

With all of this context in mind, let's give a proper definition to all 4 terms we've been talking about:

- `justify` — to position something along the _primary axis_.
- `align` — to position something along the _cross axis_.
- `content` — a group of “stuff” that can be distributed.
- `items` — single items that can be positioned individually.

**And so:** we have `justify-content` to control the distribution of the group along the primary axis, and we have `align-items` to position each item individually along the cross axis. These are the two main properties we use to manage layout with Flexbox.

There's no `justify-items` for the same reason that there's no `justify-self`; when it comes to the primary axis, _we have to think of the items as a group,_ as content that can be distributed.

What about `align-content`? Actually, this _does_ exist within Flexbox! We'll cover it a little later on, when we talk about the `flex-wrap` property.

## Hypothetical size
Let's talk about one of the most eye-opening realizations I've had about Flexbox.
Suppose I have the following CSS:
```css
.item {
  width: 2000px;
}
```
A reasonable person might look at this and say: “alright, so we'll get an item that is 2000 pixels wide”. _But will that always be true?_

```html
style>
  .flex-wrapper {
    display: flex;
  }
  .item {
    width: 2000px;
  }
</style>

<div class="item"></div>

<div class="flex-wrapper">
  <div class="item"></div>
</div>
```
```css
.row {
  list-style-type: none;
  padding: 16px;
}
.item {
  height: 50px;
  border: 2px solid;
  border-radius: 4px;
  background: hotpink;
  margin: 16px;
}
```
RESULT:
![[Pasted image 20231113195443.png]]
This is interesting, isn't it?

**Both items have the exact same CSS applied.** They each have `width: 2000px`. And yet, the first item is much wider than the second!

The difference is the _layout mode_. The first item is being rendered using Flow layout, and in Flow layout, `width` is a _hard constraint_. When we set `width: 2000px`, we'll get a 2000-pixel wide element, even if it has to burst through the side of the viewport like the Kool-Aid guy?.

In _Flexbox_, however, the `width` property is implemented differently. It's more of a suggestion than a hard constraint.

The specification has a name for this: the _hypothetical size_. It's the size an element _would_ be, in a perfect utopian world, with nothing getting in the way.

Alas, things are rarely so simple. In this case, the limiting factor is that the parent _doesn't have room_ for a 2000px-wide child. And so, the child's size is reduced so that it fits.

This is a core part of the Flexbox philosophy. Things are fluid and flexible and can adjust to the constraints of the world.
>**Inputs for the algorithms**

We tend to think of the CSS language as a collection of properties, but **I think that's the wrong mental model.** As we've seen, the `width` property behaves differently depending on the layout mode used!

Instead, I like to think of CSS as a collection of layout modes. Each layout mode is an algorithm that can implement or redefine each CSS property. We provide an algorithm with our CSS declarations (key/value pairs), and the algorithm decides how to use them.

In other words, **the CSS we write is an input for these algorithms**, like arguments passed to a function. If we want to _truly_ feel comfortable with CSS, it's not enough to learn the properties; we have to learn how the algorithms _use_ these properties.

This is the central philosophy taken by my course, [**CSS for JavaScript Developers**](https://css-for-js.dev/). Rather than have you memorize a bunch of inscrutable CSS snippets, we pop the hood on the language and learn how all of the layout modes work.

## Growing and shrinking

So, we've seen that the Flexbox algorithm has some built-in flexibility, with _hypothetical sizes_. But to _really_ see how fluid Flexbox can be, we need to talk about 3 properties: `flex-grow`, `flex-shrink`, and `flex-basis`.

Let's look at each property.

### flex-basis

I admit it: for a long time, I didn't really understand what the _deal_ was with `flex-basis`. 😅

**To put it simply:** In a Flex row, `flex-basis` does the same thing as `width`. In a Flex column, `flex-basis` does the same thing as `height`.

As we've learned, everything in Flexbox is _pegged to the primary/cross axis_. For example, `justify-content` will distribute the children along the primary axis, and it works exactly the same way whether the primary axis runs horizontally or vertically.

`width` and `height` don't follow this rule, though! `width` will always affect the horizontal size. It doesn't suddenly become `height` when we flip `flex-direction` from `row` to `column`.

**And so, the Flexbox authors created a generic “size” property called `flex-basis`.** It's like `width` or `height`, but pegged to the _primary axis_, like everything else. It allows us to set the _hypothetical size_ of an element in the primary-axis direction, regardless of whether that's horizontal or vertical.
![[Pasted image 20231113202359.png]]
Like we saw with `width`, `flex-basis` is more of a suggestion than a hard constraint. At a certain point, there just isn't enough space for all of the elements to sit at their assigned size, and so they have to compromise, in order to avoid an overflow.

>**Not _exactly_ the same**
In general, we can use `width` and `flex-basis` interchangeably in a Flex row, but there are some exceptions. For example, the `width` property affects replaced elements like images differently than `flex-basis`. Also, `width` can reduce an item below its _minimum_ size, while `flex-basis` can't
It's well outside the scope of this blog post, but I wanted to mention it, because you may occasionally run into edge-cases where the two properties have different effects.

### flex-grow

By default, elements in a Flex context will shrink down to their minimum comfortable size along the primary axis. This often creates extra space.

We can specify how that space should be consumed with the `flex-grow` property:
![[Pasted image 20231113202627.png]]
![[Pasted image 20231113202648.png]]

I think it'll be easier to explain visually. Try incrementing/decrementing each child:
![[Pasted image 20231113202759.png]]
The first child wants 5 units of extra space, while the second child wants 2 units. That means the total # of units is **7** (5 + 2). Each child gets a proportional share of that extra space.

### flex-shrink

In most of the examples we've seen so far, we've had extra space to work with. But what if our children are _too big_ for their container?
**Let's test it.** Try shrinking the container to see what happens:

![[Pasted image 20231113203001.png]]
![[Pasted image 20231113203042.png]]
Interesting, right? Both items shrink, **but they shrink proportionally.** The first child is always 2x the width of the second child.*

As a friendly reminder, `flex-basis` serves the same purpose as `width`. We'll use `flex-basis` because it's conventional, but we'd get the **exact same result** if we used `width`!

`flex-basis` and `width` set the elements' _hypothetical size_. The Flexbox algorithm might shrink elements below this desired size, but by default, they'll always scale together, preserving the ratio between both elements.

Now, what if we _don't_ want our elements to scale down proportionally? **That's where the `flex-shrink` property comes in.**

Take a couple of minutes and poke at this demo. **See if you can figure out what's going on here.** We'll explore below.

![[Pasted image 20231113203224.png]]

Alright, so: we have two children, each with a hypothetical size of 250px. The container needs to be at least 500px wide to contain these children at their hypothetical size.

Let's suppose we shrink the container to **400px**. Well, we can't stuff 500px worth of content into a 400px bag! _We have a deficit of 100px._ Our elements will need to give up 100px total, in order for them to fit.

**The `flex-shrink` property lets us decide how that balance is paid.**

Like `flex-grow`, it's a ratio. By default, both children have `flex-shrink: 1`, and so each child pays ½ of the balance. They each forfeit 50px, their actual size shrinking from 250px to 200px.

Note that the absolute values don't matter, **it's all about the ratio.** If both children have `flex-shrink: 1`, each child will pay ½ of the total deficit. If both children are cranked up to `flex-shrink: 1000`, each child will pay 1000/2000 of the total deficit. Either way, it works out to the same thing.

>**Shrinking and proportions**
In the example we've been looking at, both Flex children have the same hypothetical size (250px). When figuring out how to shrink them, we can calculate it exclusively using `flex-shrink`.
\
As we saw earlier, though, the shrinking algorithm will also try and _preserve the proportions_ between siblings. If the first child is 2x the size of the second, it will shrink more aggressively.
\
So, the _full_ calculation involves looking at each child's relative `flex-shrink` _and_ its relative size.

I had an epiphany a while back about `flex-shrink`: we can think of it as the “inverse” of `flex-grow`. They're two sides of the same coin:

- `flex-grow` controls how the _extra space is distributed_ when the items are smaller than their container.
    
- `flex-shrink` controls how _space is removed_ when the items are bigger than their container.
    

This means that **only _one_ of these properties can be active at once.** If there's extra space, `flex-shrink` has no effect, since the items don't need to shrink. And if the children are too big for their container, `flex-grow` has no effect, because there's no extra space to divvy up.

I like to think of it as two separate realms. You're either on Earth, or in the Upside Down?. Each world has its own rules.

### Preventing shrinking

Sometimes, we don't _want_ some of our Flex children to shrink.
When we set `flex-shrink` to 0, **we essentially “opt out” of the shrinking process altogether.** The Flexbox algorithm will treat `flex-basis` (or `width`) as a hard minimum limit.
```html
<style>
  /* This is the key property: */
  .item.ball {
    flex-shrink: 0;
  }
</style>

<div class="wrapper">
  <div class="item ball"></div>
  <div class="item stretch"></div>
  <div class="item ball"></div>
</div>
```

**A simpler approach?**

So, I teach this concept in [my course](https://css-for-js.dev/), and every now and then, someone will wonder why we're going through all the trouble of using `flex-shrink` when there's a simpler approach available:

```css
.item.ball {
  min-width: 32px;
}
```
A few years ago, I would have agreed. If we set a minimum width, the item won't be able to shrink below that point! We're adding a hard constraint, instead of the soft constraint of `width` / `flex-basis`.

I think this is one of those situations where it's easy to confuse “familiar” with “simple”. You're probably much more comfortable with `min-width` than `flex-shrink`, but that doesn't mean `flex-shrink` is more complicated!

After a few years of practice, I actually feel like setting `flex-shrink: 0` is the more straightforward / direct solution to this particular problem. Though, `min-width` still has an important role to play in the Flexbox algorithm! We'll talk about that next.

## The minimum size gotcha

There's _one more thing_ we need to talk about here, and it's super important. It may be the single most helpful thing in this entire article!

Let's suppose we're building a fluid search form for an e-commerce store:

When the container shrinks below a certain point, **the content overflows!**

![[Pasted image 20231113204147.png]]
_But why??_ `flex-shrink` has a default value of `1`, and we haven't removed it, so the search input _should_ be able to shrink as much as it needs to! Why is it refusing to shrink?

**Here's the deal:** In addition to the _hypothetical_ size, there's another important size that the Flexbox algorithm cares about: _the minimum size_.

The Flexbox algorithm refuses to shrink a child below its minimum size. The content will overflow rather than shrink further, _no matter how high we crank `flex-shrink`!_

Text inputs have a default minimum size of 170px-200px (it varies between browsers). That's the limitation we're running into above.
In other cases, the limiting factor might be the element's content.

In other cases, the limiting factor might be the element's content. For example, try resizing this container:
For an element containing text, the minimum width is the length of the _longest unbreakable string of characters._![[Screenshot 2023-11-13 at 8.49.43 PM.png]]
**Here's the good news:** We can redefine the minimum size with the `min-width` property.
![[Pasted image 20231113205205.png]]
By setting `min-width: 0px` directly on the Flex child, we tell the Flexbox algorithm to overwrite the “built-in” minimum width. Because we've set it to 0px, the element can shrink as much as necessary.

This same trick can work in Flex columns with the `min-height` property (although the problem doesn't seem to come up as often).

**Proceed with caution**

It's worth noting that the built-in minimum size _does_ serve a purpose. It's meant to act as a guardrail, to prevent something even worse from happening.

For example: when we apply `min-width: 0px` to our text-containing Flex children, things break in an even worse way:
![[Pasted image 20231113205407.png]]

With great power comes great responsibility, and `min-width` is a particularly powerful property when it comes to Flexbox. It's gotten me out of a jam more than once, but I'm always careful to make sure I'm not making things worse!
## Gaps

One of the biggest Flexbox quality-of-life improvements in recent years has been the `gap` property:
`gap` allows us to create space _in-between_ each Flex child. This is great for things like navigation headers:
![[Pasted image 20231113205540.png]]
`gap` is a relatively new addition to the Flexbox language, but it's been [implemented across all modern browsers](https://caniuse.com/?search=gap) since early 2021.

### Auto margins

There's one other spacing-related trick I want to share. It's been around since the early days of Flexbox, but it's relatively obscure, and it _blew my mind_ when I first discovered it.

The `margin` property is used to add space around a specific element. In some layout modes, like Flow and Positioned, it can even be used to center an element, with `margin: auto`.

Auto margins are much more interesting in Flexbox:
![[Pasted image 20231113205757.png]]
Earlier, we saw how the `flex-grow` property can gobble up any extra space, applying it to a child.

Auto margins will **gobble up the extra space, and apply it to the element's margin.** It gives us precise control over where to distribute the extra space.

A common header layout features the logo on one side, and some navigation links on the other side. Here's how we can build this layout using auto margins:

```html
<style>
  ul {
    display: flex;
    gap: 12px;
  }
  li.logo {
    margin-right: auto;
  }
</style>

<nav>
  <ul>
    <li class="logo">
      <a href="/">
        Corpatech
      </a>
    </li>
    <li>
      <a href="">
        Mission
      </a>
    </li>
    <li>
      <a href="">
        Contact
      </a>
    </li>
  </ul>
</nav>
```
```css
body {
  padding: 0;
}
nav {
  padding: 12px;
  border-bottom: 1px dotted
    hsl(0deg 0% 0% / 0.2);
}
ul {
  list-style-type: none;
  align-items: baseline;
  padding: 0px;
  margin: 0;
}
ul a {
  color: inherit;
  text-decoration: none;
  font-size: 0.875rem;
}
.logo a {
  font-size: 1.125rem;
  font-weight: 500;
}
```
![[Pasted image 20231113210021.png]]
The **Corpatech** logo is the first list item in the list. By giving it `margin-right: auto`, we gather up all of the extra space, and force it between the 1st and 2nd item.

There are lots of other ways we could have solved this problem: we could have grouped the navigation links in their own Flex container, or we could have grown the first list item with `flex-grow`. But personally, I love the auto-margins solution. We're treating the extra space _as a resource_, and deciding exactly where it should go.

## Flex wrap
So far, all of our items have sat side-by-side, in a single row/column. The `flex-wrap` property allows us to change that.
![[Pasted image 20231113210451.png]]
Most of the time when we work in two dimensions, we'll want to use CSS Grid, but Flexbox + `flex-wrap` definitely has its uses! This particular example showcases the [“deconstructed pancake”](https://web.dev/patterns/layout/deconstructed-pancake/) layout, where 3 items stack into an inverted pyramid on mid-sized screens.

When we set `flex-wrap: wrap`, **items won't shrink below their hypothetical size**. At least, not when wrapping onto the next row/column is an option!
**But wait!** What about our kebab / cocktail weenie metaphor??

With `flex-wrap: wrap`, we no longer have a single primary axis line that can skewer each item. Effectively, **each row acts as its own mini flex container.** Instead of 1 big skewer, each row gets its own skewer:
![[Pasted image 20231113210924.png]]
But hmm... How does `align-items` work, now that we have multiple rows? The cross axis _could_ intersect multiple items now!

**Take a moment to consider.** What do you _think_ will happen when we change this property? Once you have your answer (or at least an idea), see if it's right:
![[Pasted image 20231113211255.png]]
Each row is its own mini Flexbox environment. `align-items` will move each item up or down within the invisible box that wraps around each row.

But what if we want to _align the rows themselves_? We can do that with the `align-content` property:
![[Pasted image 20231113211322.png]]
To summarize what's happening here:

- `flex-wrap: wrap` gives us two rows of stuff.
- Within each row, `align-items` lets us slide each individual child up or down
- Zooming out, however, we have these two rows within a single Flex context! The cross axis will now intersect _two_ rows, not one. And so, we can't move the rows individually, we need to distribute them _as a group_.
- Using our definitions from above, we're dealing with _content_, not _items_. But we're also still talking about the cross axis! And so the property we want is `align-content`.
