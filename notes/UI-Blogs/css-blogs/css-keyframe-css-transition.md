[josh-comeau-blog](https://www.joshwcomeau.com/animation/keyframe-animations/)
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
```html
<style>
body {
  padding: 32px 0;
}
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
  width: 100px;
  height: 100px;
  background: slateblue;
  padding: 8px;
  display: grid;
  place-content: center;
  color: white;
  text-align: center;
  animation: slide-in 1000ms;
}
</style>
<div class="box">
  Hello World
</div>
```
As with the `transition` property, `animation` requires a duration. Here we've said that the animation should last 1 second (1000ms).

The browser will _interpolate_ the declarations within our `from` and `to` blocks, over the duration specified. This happens immediately, as soon as the property is set.

We can animate multiple properties in the same animation declaration. Here's a fancier example that changes multiple properties:As with the `transition` property, `animation` requires a duration. Here we've said that the animation should last 1 second (1000ms).

The browser will _interpolate_ the declarations within our `from` and `to` blocks, over the duration specified. This happens immediately, as soon as the property is set.

We can animate multiple properties in the same animation declaration. Here's a fancier example that changes multiple properties:
```css
<style>
body {
  padding: 32px;
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
timing functions for our keyframe animations, like with `transition`, the default value is `ease`.

We can override it with the `animation-timing-function` property
```html
<style>
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
  @keyframes slide-in {
    from {
      transform: translateX(-100%);
    }
    to {
      transform: translateX(0%);
    }
  }

  .box {
    animation: slide-in 1000ms;
    animation-timing-function: linear;
  }
</style>

<div class="box">
  Hello World
</div>
```

## Looped animations

By default, keyframe animations will only run once, but we can control this with the `animation-iteration-count` property:
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
    animation-iteration-count: 3;
  }
</style>

<div class="box">
  Hello World
</div>
```
## Multi-step animations

In addition to the `from` and `to` keywords, we can also use percentages. This allows us to add more than 2 steps:
```html
<style>
.spinner {
  display: block;
  width: 32px;
  height: 32px;
}
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
```html
<style>
.spinner, .multi-step-spinner {
  display: block;
  width: 32px;
  height: 32px;
}
body {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 16px;
  height: calc(100vh - 16px);
}
  @keyframes spin {
    0% {
      transform: rotate(0turn);
    }
    100% {
      transform: rotate(1turn)
    }
  }
  
  @keyframes multi-step-spin {
    0% {
      transform: rotate(0turn);
    }
    25% {
      transform: rotate(0.25turn);
    }
    50% {
      transform: rotate(0.5turn);
    }
    75% {
      transform: rotate(0.75turn);
    }
    100% {
      transform: rotate(1turn);
    }
  }
  
  .spinner {
    animation: spin 2000ms;
    animation-iteration-count: infinite;
  }
  .multi-step-spinner {
    animation: multi-step-spin 2000ms;
    animation-iteration-count: infinite;
  }
</style>

<img
  class="spinner"
  alt="Loading…"
  src="/images/keyframe-animations/loader.svg"
/>
<img
  class="multi-step-spinner"
  alt="Loading…"
  src="/images/keyframe-animations/loader.svg"
/>
```
Unfortunately, we can't control this behaviour using CSS keyframe animations, though it _is_ configurable using the Web Animations API. If you find yourself in a situation where the step-by-step easing is problematic, I'd suggest [checking it out](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API/Using_the_Web_Animations_API)!
## Alternating animations

Let's suppose that we want an element to "breathe", inflating and deflating.
We could set it up as a 3-step animation:
```html
<style>
.box {
  width: 100px;
  height: 100px;
  background: slateblue;
}
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
```html
<style>
.box {
  width: 100px;
  height: 100px;
  background: slateblue;
}
  @keyframes grow-and-shrink {
    0% {
      transform: scale(1);
    }
    100% {
      transform: scale(1.5);
    }
  }

  .box {
    animation: grow-and-shrink 2000ms;
    animation-timing-function: ease-in-out;
    animation-iteration-count: infinite;
    animation-direction: alternate;
  }
</style>

<div class="box"></div>
```
`animation-direction` controls the order of the sequence. The default value is `normal`, going from 0% to 100% over the course of the specified duration.

We can also set it to `reverse`. This will play the animation backwards, going from 100% to 0%.

The interesting part, though, is that we can set it to `alternate`, which ping-pongs between `normal` and `reverse` on subsequent iterations.

Instead of having 1 big animation that grows and shrinks, we set our animation to grow, and then reverse it on the next iteration, causing it to shrink.
>**Half the duration**
>Originally, our "breathe" animation lasted 4 seconds. When we switched to the alternate strategy, however, we cut the duration in half, down to 2 seconds.
>This is because _each iteration only performs half the work_. It always took 2 seconds to grow, and 2 seconds to shrink. Before, we had a single 4-second-long animation. Now, we have a 2-second-long animation that requires 2 iterations to complete a full cycle.

## Shorthand values

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
![[Pasted image 20231026135028.png]]
Why does the element jump back to full visibility? Well, the declarations in the `from` and `to` blocks only apply _while the animation is running_.

After 1000ms has elapsed, the animation packs itself up and hits the road. The declarations in the `to` block dissipate, leaving our element with whatever CSS declarations have been defined elsewhere. Since we haven't set `opacity` for this element anywhere else, it snaps back to its default value (`1`).

One way to solve this is to add an `opacity` declaration to the `.box` selector:
```html
<style>
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

## Filling forwards

Instead of relying on fallback declarations, let's consider another approach, using `animation-fill-mode`:
```html
<style>
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
![[Pasted image 20231026135434.png]]
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
The CSS in the `from` and `to` blocks is only applied while the animation is running. Frustratingly, the `animation-delay` period doesn't count. So for that first half-second, it's as if the CSS in the `from` block doesn't exist.

`animation-fill-mode` has another value that can help us here: `backwards`. This will apply the CSS from the first block _backwards in time_.
> “Forwards” and “backwards” are confusing values, but here's an analogy that might help: imagine if we had recorded the user's session from the moment the page loaded. We could scrub forwards and backwards in the video. We can scrub backwards, before the animation has started, or forwards, after the animation has ended.

What if we want to persist the animation forwards _and_ backwards? We can use a third value, `both`, which persists in both directions:

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
```html
<style>
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
  @keyframes bounce {
    from {
      transform: translateY(0px);
    }
    to {
      transform: translateY(-20px);
    }
  }
  .box {
    animation:
      bounce 300ms
      alternate infinite
      cubic-bezier(.2, .65, .6, 1);
  }
</style>
<div class="box"></div>
```
**Cubic bezier?**
To make the bounce animation a bit more realistic, I'm using a custom timing function, using `cubic-bezier`.

CSS animations are meant to be generic and reusable, but this animation will always cause an element to bounce by 20px. Wouldn't it be neat if different elements could supply different "bounce heights"?

With CSS variables, we can do exactly that:
```html
<style>
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

# [ An Interactive Guide to CSS Transitions](https://www.joshwcomeau.com/animation/css-transitions/)

## The fundamentals

The main ingredient we need to create an animation is some CSS that changes.

Here's an example of a button that moves on hover, _without animating_:
```html
<style>
  .btn {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    border: none;
    background: slateblue;
    color: white;
    font-size: 20px;
    font-weight: 500;
    line-height: 1;
  }
  .btn:hover {
    transform: translateY(-10px);
  }
</style>
<button class="btn">
  Hello World
</button>
```
This snippet uses the `:hover` pseudoclass to specify an additional CSS declaration when the user's mouse rests atop our button, similar to an `onMouseEnter` event in JavaScript.

To shift the element up, we use `transform: translateY(-10px)`. While we could have used `margin-top` for this, `transform: translate` is a better tool for the job. We'll see why later.

By default, changes in CSS happen instantaneously. In the blink of an eye, our button has teleported to a new position! This is incongruous with the natural world, where things happen gradually.

We can instruct the browser to _interpolate_ from one state to another with the aptly-named `transition` property:
```html
<style>
  .btn {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    border: none;
    background: slateblue;
    color: white;
    font-size: 20px;
    font-weight: 500;
    line-height: 1;
    transition: transform 250ms;
  }
  .btn:hover {
    transform: translateY(-10px);
  }
</style>
<button class="btn">
  Hello World
</button>
```
`transition` can take a number of values, but only two are required:

1. The name of the property we wish to animate
2. The duration of the animation
If you plan on animating multiple properties, you can pass it a comma-separated list:
```html
.btn {
  transition: transform 250ms, opacity 400ms;
}
.btn:hover {
  transform: scale(1.2);
  opacity: 0;
}
```
>**Selecting all properties**
>`transition-property` takes a special value: `all`. When `all` is specified, any CSS property that changes will be transitioned.
>
>It can be tempting to use this value, as it saves us a good chunk of typing if we're animating multiple properties, but **I recommend not using it.**
>
>As your product evolves, you (or someone on your team) will likely wind up updating this code at some point in the future. An unexpected animation could slip through.
>
>Animation is like salt: too much of it spoils the dish. It pays to be really precise with the properties we animate.

## Timing functions

When we tell an element to transition from one position to another, the browser needs to work out what each "intermediary" frame should look like.

For example: let's say that we're moving an element from left to right, over a 1-second duration. A smooth animation should run at 60fps*, which means we'll need to come up with 60 individual positions between the start and end.

Let's start by having them be evenly-spaced:
In this animation, we're using a **linear timing function**. This means that the element moves at a constant pace; our circle moves by the same amount each frame.
There are several timing functions available to us in CSS. We can specify which one we want to use with the `transition-timing-function` property:
```css
.btn {
  transition: transform 250ms;
  transition-timing-function: linear;
}
```
Or, we can pass it directly to the `transition` shorthand property:
```css
.btn {
  transition: transform 250ms linear;
}
```
`linear` is rarely the best choice — after all, pretty much nothing in the real world moves this way*. Good animations mimic the natural world, so we should pick something more organic!

Let's run through our options.
![[Pasted image 20231026142029.png]]

**Time is constant**
An important note about all of these demos: _time is constant_. Timing functions describe how a value should get from 0 to 1 over a fixed time interval, **not** how quickly the animation should complete. Some timing functions may feel faster or slower, but in these examples, they all take exactly 1 second to complete.
### Custom curves
If the provided built-in options don't suit your needs, you can define your own custom easing curve, using the cubic bézier timing function!
```css
.btn {
  transition:
    transform 250ms cubic-bezier(0.1, 0.2, 0.3, 0.4);
}
```
## Animation performance

Earlier, we mentioned that animations ought to run at 60fps. When we do the math, though, we realize that this means the browser only has 16.6 milliseconds to paint each frame. That's really not much time at all; for reference, it takes us about 100ms-300ms to blink!

If our animation is too computationally expensive, it'll appear janky and stuttery. Frames will get dropped, as the device can't keep up.

Experience this for yourself by tweaking the new "Frames per second" control:
For demo : https://www.joshwcomeau.com/animation/css-transitions/#animation-performance-8

In practice, poor performance will often take the form of _variable_ framerates, so this isn't a perfect simulation.

Animation performance is a surprisingly deep and interesting area, well beyond the scope of this introductory tutorial. But let's cover the absolutely-critical, need-to-know bits:

1. Some CSS properties are wayyy more expensive to animate than others. For example, `height` is a very expensive property because it affects layout. When an element's height shrinks, it causes a chain reaction; all of its siblings will also need to move up, to fill the space!
    
2. Other properties, like `background-color`, are somewhat expensive to animate. They don't affect layout, but they do require a fresh coat of paint on every frame, which isn't cheap.
    
3. Two properties — `transform` and `opacity` — are very cheap to animate. If an animation currently tweaks a property like `width` or `left`, it can be _greatly improved_ by moving it to `transform` (though it isn't always possible to achieve the exact same effect).
    
4. Be sure to test your animations on the lowest-end device that your site/app targets. Your development machine is likely many times faster than it.
If you're interested in learning more about animation performance, There is a talk on this subject at [React Rally](https://www.youtube.com/watch?v=DNGGzwmfouU&t=4s).

