[source](https://www.joshwcomeau.com/animation/keyframe-animations/)

The main idea with a CSS keyframe animation is that it'll interpolate between different chunks of CSS.

For example, here we define a keyframe animation that will smoothly ramp an element's horizontal position from `-100%` to `0%`:
```css
@keyframes slide-in {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0%);
  }
}
```
Each `@keyframes` statement needs a name! In this case, we've chosen to name it `slide-in`. You can think of this like a global variable.*

Keyframe animations are meant to be general and reusable. We can apply them to specific selectors with the `animation` property:
```css
<style>
  /* Create the animation... */
  @keyframes slide-in {
    from {
      transform: translateX(-100%);
    }
    to {
      transform: translateX(0%);
    }
  }

  /* ...and then apply it: */
  .box {
    animation: slide-in 1000ms;
  }
</style>

<div class="box">
  Hello World
</div>
```
```css
body {
  padding: 32px 0;
}
.box {
  width: 100px;
  height: 100px;
  background: slateblue;
  padding: 8px;
  display: grid;
  place-content: center;
  color: white;
  text-align: center;
}
```
As with the `transition` property, `animation` requires a duration. Here we've said that the animation should last 1 second (1000ms).

The browser will _interpolate_ the declarations within our `from` and `to` blocks, over the duration specified. This happens immediately, as soon as the property is set.

We can animate multiple properties in the same animation declaration. Here's a fancier example that changes multiple properties:
```html
<style>
  @keyframes drop-in {
    from {
      transform:
        rotate(-30deg) translateY(-100%);
      opacity: 0;
    }
    to {
      transform:
        rotate(0deg) translateY(0%);
      opacity: 1;
    }
  }

  .box {
    animation: drop-in 1000ms;
  }
</style>

<div class="box">
  Hello World
</div>
```
## Timing functions

In “[An Interactive Guide to CSS Transitions](https://www.joshwcomeau.com/animation/css-transitions/#timing-functions)”, we learned all about the different timing functions built into CSS.

We have access to the same library of timing functions for our keyframe animations. And, like with `transition`, the default value is `ease`.

We can override it with the `animation-timing-function` property:
```css
 .box {
    animation: slide-in 1000ms;
    animation-timing-function: linear;
  }
```
## Looped animations

By default, keyframe animations will only run once, but we can control this with the `animation-iteration-count` property:
```css
.box {
    animation: slide-in 1000ms;
    animation-iteration-count: 3;
  }
```
It's somewhat rare to specify an integer like this, but there is one special value that comes in handy: `infinite`.

## Multi-step animations

In addition to the `from` and `to` keywords, we can also use percentages. This allows us to add more than 2 steps:

```html
<style>
  @keyframes fancy-spin {
    0% {
      transform: rotate(0turn) scale(1);
    }
    25% {
      transform: rotate(1turn) scale(1);
    }
    50% {
      transform: rotate(1turn) scale(1.5);
    }
    75% {
      transform: rotate(0turn) scale(1.5);
    }
    100% {
      transform: rotate(0turn) scale(1);
    }
  }
  
  .spinner {
    animation: fancy-spin 2000ms;
    animation-iteration-count: infinite;
  }
</style>

<img
  class="spinner"
  alt="Loading…"
  src="/images/keyframe-animations/loader.svg"
/>
```
The percentages refer to the progress through the animation. `from` is really just syntactic sugar? for `0%`. And `to` is sugar for `100%`.

Importantly, _the timing function applies to each step_. We don't get a single ease for the entire animation.

In this playground, both spinners complete 1 full rotation in 2 seconds. But `multi-step-spin` breaks it into 4 distinct steps, and each step has the timing function applied:

## Alternating animations

Let's suppose that we want an element to "breathe", inflating and deflating.

We could set it up as a 3-step animation:
```html
<style>
  @keyframes grow-and-shrink {
    0% {
      transform: scale(1);
    }
    50% {
      transform: scale(1.5);
    }
    100% {
      transform: scale(1);
    }
  }

  .box {
    animation: grow-and-shrink 4000ms;
    animation-iteration-count: infinite;
    animation-timing-function: ease-in-out;
  }
</style>

<div class="box"></div>
```
It spends the first half of the duration growing to be 1.5x its default size. Once it reaches that peak, it spends the second half shrinking back down to 1x.

This works, but there's a more-elegant way to accomplish the same effect. We can use the `animation-direction` property:
```css
.box {
    animation: grow-and-shrink 2000ms;
    animation-timing-function: ease-in-out;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }
```
`animation-direction` controls the order of the sequence. The default value is `normal`, going from 0% to 100% over the course of the specified duration.

We can also set it to `reverse`. This will play the animation backwards, going from 100% to 0%.

The interesting part, though, is that we can set it to `alternate`, which ping-pongs between `normal` and `reverse` on subsequent iterations.

Instead of having 1 big animation that grows and shrinks, we set our animation to grow, and then reverse it on the next iteration, causing it to shrink.

**Half the duration**
Originally, our "breathe" animation lasted 4 seconds. When we switched to the alternate strategy, however, we cut the duration in half, down to 2 seconds.

This is because _each iteration only performs half the work_. It always took 2 seconds to grow, and 2 seconds to shrink. Before, we had a single 4-second-long animation. Now, we have a 2-second-long animation that requires 2 iterations to complete a full cycle.

We've picked up a lot of animation properties in this lesson, and it's been a lot of typing!

Fortunately, as with `transition`, we can use the `animation` shorthand to combine all of these properties.

The above animation can be rewritten:
```css
.box {
  /*
  From this:
    animation: grow-and-shrink 2000ms;
    animation-timing-function: ease-in-out;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  ...to this:
  */
  animation: grow-and-shrink 2000ms ease-in-out infinite alternate;
}
```
Here's a piece of good news, as well: **the order doesn't matter.** For the most part, you can toss these properties in any order you want. You don't need to memorize a specific sequence.

There is an exception: `animation-delay`, a property we'll talk more about shortly, needs to come after the duration, since both properties take the same value type (milliseconds/seconds).

For this reason, I prefer to exclude delay from the shorthand:
```css
.box {
  animation: grow-and-shrink 2000ms ease-in-out infinite alternate;
  animation-delay: 500ms;
}
```
## Fill Modes

Probably the most confusing aspect of keyframe animations is _fill modes_. They're the biggest obstacle on our path towards keyframe confidence.

Let's start with a problem.

We want our element to fade out. The animation itself works fine, but when it's over, the element pops back into existence:
```html
<style>
  @keyframes fade-out {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }
  
  .box {
    animation: fade-out 1000ms;
  }
</style>

<div class="box">
  Hello World
</div>
```
If we were to graph the element's opacity over time, it would look something like this:
![[Pasted image 20231116003221.png]]

Why does the element jump back to full visibility? Well, the declarations in the `from` and `to` blocks only apply _while the animation is running_.

After 1000ms has elapsed, the animation packs itself up and hits the road. The declarations in the `to` block dissipate, leaving our element with whatever CSS declarations have been defined elsewhere. Since we haven't set `opacity` for this element anywhere else, it snaps back to its default value (`1`).

One way to solve this is to add an `opacity` declaration to the `.box` selector:
```html
<style>
  @keyframes fade-out {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }
  
  .box {
    animation: fade-out 1000ms;
    /*
      Change the "default" value for opacity,
      so that it reverts to 0 when the
      animation completes.
    */
    opacity: 0;
  }
</style>

<div class="box">
  Hello World
</div>
```

While the animation is running, the declarations in the `@keyframes` statement overrule the opacity declaration in the `.box` selector. Once the animation wraps up, though, that declaration kicks in and keeps the box hidden.

**Specificity?**

In CSS, conflicts are resolved based on the “specificity” of a selector. An ID selector (`#login-form`) will win the battle against a class one (`.thing`).

But what about keyframe animations? What is their specificity?

It turns out that specificity isn't really the right way to think about this; instead, we need to think about **cascade origins.**

A “cascade origin” is a source of selectors. For example, browsers come with a bunch of built-in styles—that's why anchor tags are blue and underlined by default. These styles are part of the _User-Agent Origin_.

_The specificity rules only apply when comparing selectors in the same origin._ The styles we write normally are part of the “Author Origin”, and Author Origin styles win out over ones written in the User-Agent Origin.

Here's why this is relevant: keyframe animations are their own special origin, and its styles are applied later.

Think of it in terms of a fighting video game. In Round One, all of the default browser styles are applied, following standard specificity rules. In Round Two, the selectors we've provided battle it out. In Round Three, `@keyframes` declarations are applied. It doesn't matter how specific a selector is if it's applied in Round Two; our `@keyframes` declaration will overwrite it.

[According to the specification](https://www.w3.org/TR/css-cascade-3/#cascade-sort), there are actually 8 rounds, not 3. Interestingly, declarations with `!important` are considered part of a different origin! At least, in theory.*

This is why our keyframe animations will apply, regardless of specificity.
So, we can update our CSS so that the element's properties match the `to` block, but is that really the best way?

### Filling forwards

Instead of relying on fallback declarations, let's consider another approach, using `animation-fill-mode`:
```html
<style>
  @keyframes fade-out {
    from {
      opacity: 1;
    }
    to {
      opacity: 0;
    }
  }
  
  .box {
    animation: fade-out 1000ms;
    animation-fill-mode: forwards;
  }
</style>

<div class="box">
  Hello World
</div>
```
`animation-fill-mode` lets us persist the final value from the animation, _forwards in time_.

"forwards" is a very confusing name, but hopefully seeing it on this graph makes it a bit clearer!

When the animation ends, `animation-fill-mode: forwards` will copy/paste the declarations in the final block, persisting them forwards in time.

### Filling backwards

We don't always want our animations to start immediately! As with `transition`, we can specify a delay, with the `animation-delay` property.

Unfortunately, we run into a similar issue:
```html
<style>
  @keyframes slide-in {
    from {
      transform: translateX(-100%);
      opacity: 0.25;
    }
    to {
      transform: translateX(0%);
      opacity: 1;
    }
  }

  .box {
    animation: slide-in 1000ms;
    animation-delay: 500ms;
  }
</style>

<div class="box">
  Hello World
</div>
```
For that first half-second, the element is fully visible!
![[Pasted image 20231116003950.png]]

The CSS in the `from` and `to` blocks is only applied while the animation is running. Frustratingly, the `animation-delay` period doesn't count. So for that first half-second, it's as if the CSS in the `from` block doesn't exist.

`animation-fill-mode` has another value that can help us here: `backwards`. This will apply the CSS from the first block _backwards in time_.
![[Pasted image 20231116004019.png]]

“Forwards” and “backwards” are confusing values, but here's an analogy that might help: imagine if we had recorded the user's session from the moment the page loaded. We could scrub forwards and backwards in the video. We can scrub backwards, before the animation has started, or forwards, after the animation has ended.

```html
<style>
  @keyframes slide-in {
    from {
      transform: translateX(-100%);
      opacity: 0.25;
    }
    to {
      transform: translateX(0%);
      opacity: 1;
    }
  }

  .box {
    animation: slide-in 1000ms;
    animation-delay: 500ms;
    animation-fill-mode: backwards;
  }
</style>

<div class="box">
  Hello World
</div>
```
What if we want to persist the animation forwards _and_ backwards? We can use a third value, `both`, which persists in both directions:
![[Pasted image 20231116004144.png]]
Personally, I wish that `both` was the default value. It's so much more intuitive! Though it _can_ make it a bit harder to understand where a particular CSS value has been set.

Like all of the animation properties we're discussing, it can be tossed into the `animation` shorthand salad:

```css
.box {
  animation: slide-in 1000ms ease-out both;
  animation-delay: 500ms;
}
```

## Dynamic animations with CSS variables

Keyframe animations are cool enough on their own, but when we mix them with CSS variables (AKA CSS custom properties), things get ⚡️ next-level ⚡️.

Let's suppose that we want to create a bouncing-ball animation, using everything we've learned in this lesson:

**Cubic bezier?**

To make the bounce animation a bit more realistic, I'm using a custom timing function, using `cubic-bezier`.

CSS animations are meant to be generic and reusable, but this animation will always cause an element to bounce by 20px. Wouldn't it be neat if different elements could supply different "bounce heights"?

With CSS variables, we can do exactly that:

```html
<style>
  @keyframes bounce {
    from {
      transform: translateY(0px);
    }
    to {
      transform: translateY(
        var(--bounce-offset)
      );
    }
  }

  .box {
    animation:
      bounce alternate infinite
      cubic-bezier(.2, .65, .6, 1);
  }
  .box.one {
    --bounce-offset: -20px;
    animation-duration: 200ms;
  }
  .box.two {
    --bounce-offset: -30px;
    animation-duration: 300ms;
  }
  .box.three {
    --bounce-offset: -40px;
    animation-duration: 400ms;
  }
</style>

<section>
  <div class="box one"></div>
  <div class="box two"></div>
  <div class="box three"></div>
</section>
```
```css
html {
  height: 100%;
}
body {
  padding: 32px 0;
  height: 100%;
  /* Center box */
  display: grid;
  place-content: center;
}
section {
  display: flex;
  gap: 16px;
}
.box {
  width: 75px;
  height: 75px;
  background: slateblue;
  padding: 8px;
  display: grid;
  place-content: center;
  color: white;
  text-align: center;
  border-radius: 50%;
}
```
Our `@keyframes` animation has been updated so that instead of bouncing to `-20px`, it accesses the value of the `--bounce-offset` property. And since that property has a different value in each box, they each bounce to different amounts.

This strategy allows us to create reusable, customizable keyframe animations. Think of it like props to a React component!

**Derived values with calc**

So, something bothers me about the example above.

With the `translateY` function, positive values move the element down, negative values move the element up. We want to move the element up, so we have to use a negative value.

But this is an _implementation detail_. When I want to apply this animation, it's weird that I need to use a negative value.

CSS variables work best when they're semantic. Instead of setting `--bounce-offset` to a negative value, I'd much rather do this:
```css
.box.one {
  --bounce-height: 20px;
}
```
Using `calc`, we can _derive the true value_ from the provided value, within our `@keyframes` at-rule:
```css
@keyframes bounce {
  from {
    transform: translateY(0px);
  }
  to {
    transform: translateY(
      calc(var(--bounce-height) * -1)
    );
  }
}
```
We only define this keyframe animation once, but we'll likely use it many times. It's worth optimizing for the "consumer" side of things, to make it as pleasant to use as possible, even if it complicates the definition a bit.

`calc` lets us craft the perfect APIs for our keyframe animations. 💯














































































































