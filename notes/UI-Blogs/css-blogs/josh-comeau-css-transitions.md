[source-blog](https://www.joshwcomeau.com/animation/css-transitions/)
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=, initial-scale=1" />
    <link rel="stylesheet" href="../css/josh-transitions.css" />
    <title>css Transitions</title>
  </head>
  <body>
    <button class="btn">Hello World</button>
  </body>
</html>
```
```css
body {
  color: blueviolet;
}
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
  transform: translateX(-10px);
}
```
This snippet uses the `:hover` pseudoclass to specify an additional CSS declaration when the user's mouse rests atop our button, similar to an `onMouseEnter` event in JavaScript.

To shift the element up, we use `transform: translateY(-10px)`. While we could have used `margin-top` for this, `transform: translate` is a better tool for the job. We'll see why later.

By default, changes in CSS happen instantaneously. In the blink of an eye, our button has teleported to a new position! This is incongruous with the natural world, where things happen gradually.

We can instruct the browser to _interpolate_ from one state to another with the aptly-named `transition` property:

`transition` can take a number of values, but only two are required:

1. The name of the property we wish to animate
2. The duration of the animation
If you plan on animating multiple properties, you can pass it a comma-separated list:
```css
.btn {
  transition: transform 250ms, opacity 400ms;
}
.btn:hover {
  transform: scale(1.2);
  opacity: 0;
}
```
>**Selecting all properties**
transition-property takes a special value: all. When all is specified, any CSS property that changes will be transitioned.
It can be tempting to use this value, as it saves us a good chunk of typing if we're animating multiple properties, but I recommend not using it.
As your product evolves, you (or someone on your team) will likely wind up updating this code at some point in the future. An unexpected animation could slip through.
Animation is like salt: too much of it spoils the dish. It pays to be really precise with the properties we animate.

When we tell an element to transition from one position to another, the browser needs to work out what each "intermediary" frame should look like.

For example: let's say that we're moving an element from left to right, over a 1-second duration. A smooth animation should run at 60fps*, which means we'll need to come up with 60 individual positions between the start and end.

Let's start by having them be evenly-spaced:
![[Pasted image 20231115174237.png]]

To clarify what's going on here: each faded circle represents a moment in time. As the circle moves from left to right, these are the frames that were shown to the user. It's like a flipbook.

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
### ease-out
`ease-out` comes charging in like a wild bull, but it runs out of energy. By the end, it's pootering along like a sleepy turtle.
![[Pasted image 20231115174541.png]]
Try scrubbing with the timeline; notice how drastic the movement is in the first few frames, and how subtle it becomes towards the end.

If we were to graph the displacement of the element over time, it'd look something like this:
![[Pasted image 20231115174620.png]]
**When would you use `ease-out`?** It's most commonly used when something is entering from off-screen (eg. a modal appearing). It produces the effect that something came hustling in from far away, and settles in front of the user.
### ease-in
`ease-in`, unsurprisingly, is the opposite of `ease-out`. It starts slow and speeds up:
As we saw, `ease-out` is useful for things that enter into view from offscreen. `ease-in`, naturally, is useful for the opposite: moving something beyond the bounds of the viewport.
This combo is useful when something is entering and exiting the viewport, like a modal. We'll look at how to mix and match timing functions shortly.

Note that `ease-in` is pretty much exclusively useful for animations that end with the element offscreen or invisible; otherwise, the sudden stop can be jarring.
### ease-in-out
Next up, `ease-in-out`. It's the combination of the previous two timing functions:
This timing function is _symmetrical_. It has an equal amount of acceleration and deceleration.
I find this curve most useful for anything that happens in a loop (eg. an element fading in and out, over and over).

It's a big step-up over `linear`, but before you go slapping it on everything, let's look at one more option.

### ease

If I had a bone to pick with the CSS language authors when it comes to transitions, it's that `ease` is poorly named. It isn't descriptive at all; literally all timing functions are eases of one sort or another!

That nitpick aside, `ease` is awesome. Unlike `ease-in-out`, it isn't symmetrical; it features a brief ramp-up, and a _lot_ of deceleration.
![[Pasted image 20231115174925.png]]
**`ease` is the default value** — if you don't specify a timing function, `ease` gets used. Honestly, this feels right to me. `ease` is a great option in most cases. If an element moves, and isn't entering or exiting the viewport, `ease` is usually a good choice.

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
All of the values we've seen so far are really just presets for this `cubic-bezier` function. It takes 4 numbers, representing 2 control points.

Bézier curves are really nifty, but they're beyond the scope of this tutorial. I'll be writing more about them soon though!

In the meantime, you can start creating your own Bézier timing functions using this [wonderful helper from Lea Verou](https://cubic-bezier.com/):

Once you come up with an animation curve you're satisfied with, click “Copy” at the top and paste it into your CSS!

You can also pick from this [extended set of timing functions](https://easings.net/). Though beware: a few of the more outlandish options won't work in CSS.

When starting out with custom Bézier curves, it can be hard to come up with a curve that feels natural. With some practice, however, this is an incredibly _expressive_ tool.

**Time for me to come clean**
I have a confession to make: the demonstrations above, showing the different timing functions, were exaggerated.

In truth, timing functions like `ease-in` are more subtle than depicted, but I wanted to emphasize the effect to make it easier to understand. The `cubic-bezier` timing function makes that possible!
As an example, here's what `ease-out` really looks like:
If you'd like to use this custom juiced-up alternatives, you can do so with the following declarations:
```css
.btn {
  /* ease-out */
  transition-timing-function:
    cubic-bezier(0.215, 0.61, 0.355, 1);
  /* ease-in */
  transition-timing-function:
    cubic-bezier(0.75, 0, 1, 1);
  /* ease-in-out */
  transition-timing-function:
    cubic-bezier(0.645, 0.045, 0.355, 1);
  /* ease */
  transition-timing-function:
    cubic-bezier(0.44, 0.21, 0, 1);
}
```
## Animation performance

Earlier, we mentioned that animations ought to run at 60fps. When we do the math, though, we realize that this means the browser only has 16.6 milliseconds to paint each frame. That's really not much time at all; for reference, it takes us about 100ms-300ms to blink!

If our animation is too computationally expensive, it'll appear janky and stuttery. Frames will get dropped, as the device can't keep up.

In practice, poor performance will often take the form of _variable_ framerates, so this isn't a perfect simulation.

Animation performance is a surprisingly deep and interesting area, well beyond the scope of this introductory tutorial. But let's cover the absolutely-critical, need-to-know bits:

1. Some CSS properties are wayyy more expensive to animate than others. For example, `height` is a very expensive property because it affects layout. When an element's height shrinks, it causes a chain reaction; all of its siblings will also need to move up, to fill the space!
2. Other properties, like `background-color`, are somewhat expensive to animate. They don't affect layout, but they do require a fresh coat of paint on every frame, which isn't cheap.
3. Two properties — `transform` and `opacity` — are very cheap to animate. If an animation currently tweaks a property like `width` or `left`, it can be _greatly improved_ by moving it to `transform` (though it isn't always possible to achieve the exact same effect).
4. Be sure to test your animations on the lowest-end device that your site/app targets. Your development machine is likely many times faster than it.
When we animate an element using `transform` and `opacity`, the browser will sometimes try to optimize this animation. Instead of rasterizing the pixels on every frame, it transfers everything to the GPU as a texture. GPUs are very good at doing these kinds of texture-based transformations, and as a result, we get a very slick, very performant animation. This is known as “hardware acceleration”.

Here's the problem: GPUs and CPUs render things _slightly_ differently. When the CPU hands it to the GPU, and vice versa, you get a snap of things shifting slightly.

We can fix this problem by adding the following CSS property:
```css
.btn {
  will-change: transform;
}
```
`will-change` is a property that allows us to hint to the browser that we're going to animate the selected element, and that it should optimize for this case.

In practice, what this means is that the browser will let the GPU handle this element _all the time_. No more handing-off between CPU and GPU, no more telltale “snapping into place”.

`will-change` lets us be intentional about which elements should be hardware-accelerated. Browsers have their own inscrutable logic around this stuff, and I'd rather not leave it up to chance.

There's another benefit to hardware acceleration: we can take advantage of _sub-pixel rendering_.

Check out these two boxes. They shift down when you hover/focus them. One of them is hardware-accelerated, and the other one isn't.
```html
<style>
  .accelerated.box {
    transition: transform 750ms;
    will-change: transform;
    background: slateblue;
  }
  .accelerated.box:hover,
  .accelerated.box:focus {
    transform: translateY(10px);
  }
  
  .janky.box {
    transition: margin-top 750ms;
    will-change: margin-top;
    background: deeppink;
  }
  .janky.box:hover,
  .janky.box:focus {
    margin-top: 10px;
  }
</style>

<div class="wrapper">
  <button class="accelerated box"></button>
  <button class="janky box"></button>
</div>
```
```css
.box {
  width: 50px;
  height: 50px;
  border: none;
  border-radius: 4px;
  outline-offset: 4px;
}
.box:first-of-type {
  margin-right: 16px;
}

.wrapper {
  display: flex;
}
```

It's maybe a bit subtle, depending on your device and your display, but one box moves much more smoothly than the other.

Properties like `margin-top` can't sub-pixel-render, which means they need to round to the nearest pixel, creating a stepped, janky effect. `transform`, meanwhile, can smoothly shift between pixels, thanks to the GPU's anti-aliasing trickery.

**Tradeoffs**

Nothing in life comes free, and hardware acceleration is no exception.
By delegating an element's rendering to the GPU, it'll consume more video memory, a resource that can be limited, especially on lower-end mobile devices.
This isn't as big a deal as it used to be — I've done some testing on a Xiaomi Redmi 7A, a popular budget smartphone in India, and it seems to hold up just fine. Just don't broadly apply `will-change` to elements that won't move. Be intentional about where you use it.

### Delays

Well, we've come pretty far in our quest to become proficient with CSS transitions, but there are a couple final details to go over. Let's talk about transition delays.

I believe that just about everyone has had this frustrating experience before:
![[Pasted image 20231115214353.png]]
As a developer, you can probably work out why this happens: the dropdown only stays open while being hovered! As we move the mouse diagonally to select a child, our cursor dips out-of-bounds, and the menu closes.

This problem can be solved in a rather elegant way without needing to reach for JS. We can use `transition-delay`!

```css
.dropdown {
  opacity: 0;
  transition: opacity 400ms;
  transition-delay: 300ms;
}

.dropdown-wrapper:hover .dropdown {
  opacity: 1;
  transition: opacity 100ms;
  transition-delay: 0ms;
}
```
`transition-delay` allows us to keep things status-quo for a brief interval. In this case, when the user moves their mouse outside `.dropdown-wrapper`, nothing happens for 300ms. If their mouse re-enters the element within that 300ms window, the transition never takes place.

After 300ms elapses, the `transition` kicks in normally, and the dropdown fades out over 400ms.

### Doom flicker
When an element is moved up or down on hover, we need to be very careful we don't accidentally introduce a "doom flicker":

The trouble occurs when the mouse is near the element's boundary. The hover effect takes the element out from under the mouse, which causes it to fall back down under the mouse, which causes the hover effect to trigger again… many times a second.

How do we solve for this? The trick is to separate the _trigger_ from the _effect_. Here's a quick example

```html
<button class="btn">
  <span class="background">
    Hello World
  </span>
</button>

<style>
  .background {
    will-change: transform;
    transition: transform 450ms;
  }
  
  .btn:hover .background {
    transition: transform 150ms;
    transform: translateY(-10px);
  }
  
  /* Toggle me on for a clue! */
  .btn {
    /* outline: auto; */
  }
</style>
```
```css
.btn {
  width: 100px;
  height: 100px;
  border: none;
  background: transparent;
  padding: 0px;
}

.background {
  display: flex;
  align-items: center;
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: slateblue;
  color: white;
  font-size: 20px;
  font-weight: 500;
  line-height: 1;
}
```
Our `<button>` now has a new child, `.background`. This span houses all of the cosmetic styles (background color, font stuff, etc).

When we mouse over the plain-jane button, it causes the child to peek out above. The button, however, is stationary.

**Try uncommenting the `outline` to see exactly what's going on!**
## Respecting motion preferences

When I see a well-crafted animation on the web, I react with delight and glee. People are different, though, and some folks have a _very_ different reaction: nausea and malaise.

I've written before about [respecting “prefers-reduced-motion”](https://www.joshwcomeau.com/react/prefers-reduced-motion/), an OS-level setting users can toggle to express a preference for less motion. Let's apply those lessons here, by disabling animations for folks who request it:
```css
@media (prefers-reduced-motion: reduce) {
  .btn {
    transition: none;
  }
}
```
This small tweak means that animations will resolve immediately for users who have gone into their system preferences and toggled a checkbox.

As front-end developers, we have a certain responsibility to ensure that our products aren't causing harm. This is a quick step we can perform to make our sites/apps friendlier and safer.

