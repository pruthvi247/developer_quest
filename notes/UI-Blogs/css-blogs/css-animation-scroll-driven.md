#### `Animation` shorthand property

The `animation` shorthand property is a shorthand for the eight `animation` sub-properties. It prevents you from wasting time typing the sub-property names and animates elements that require all eight sub-properties:
```css
/* Here’s the syntax of the animation shorthand property */
.element {
  animation: name duration timing-function delay iteration-count direction fill-mode play-state;
}
```
`example`
```css
.square {
  background-color: yellow;
  height: 200px;
  width: 200px;
  animation-name: move;
  animation-duration: 1.5s;
  animation-timing-function: ease;
  animation-delay: 0s;
  animation-iteration-count: infinite;
  animation-direction: alternate;
  animation-fill-mode: none;
  animation-play-state: running; */
}
```
Note that you can’t use the `animation` shorthand property and the `animation` sub-properties together because they produce the same thing. They should be used individually based on what you are trying to achieve.
You can learn more about [each sub-property and its value in the MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations/Using_CSS_animations).

# Scroll-linked-animations
[source-bramus](https://www.youtube.com/watch?v=NS4lmu6AJuI&t=67s)
### A css Animation
![[Pasted image 20231228111630.png]]
### A scroll timeline
A _Scroll-timeline_ is a type of a timeline whose actual time value is determined not by a  ticking clock but by the progress of scrolling in a scroll container
![[Pasted image 20231228111834.png]]
### A link between both
![[Pasted image 20231228111932.png]]
## Scroll timeline Descriptiors
- Time-range
- Scroll-offsets
- orientation
- source

![[Pasted image 20231228121449.png]]
![[Pasted image 20231228121522.png]]

## [@scroll-timeline-part-1](https://www.bram.us/2021/02/23/the-future-of-css-scroll-linked-animations-part-1/)
**Scroll linked animations**
 **Scroll-Linked Animations are animations are linked to the scroll offset of a scroll container.** As you scroll back and forth the scroll container, you will see the animation timeline advance or rewind as you do so. If you stop scrolling, the animation will also stop.
 
**Scroll triggered animations**
**Scroll-Triggered Animations are animations that are triggered when scrolling past a certain position.** Once triggered, these animations start and finish on their own, independent of whether you keep scrolling or not.

The [Scroll-driven Animations Specification](https://drafts.csswg.org/scroll-animations-1/) defines two new types of timelines that you can use: [chrome-blog](https://developer.chrome.com/docs/css-ui/scroll-driven-animations#getting-practical-with-view-progress-timeline)

- **Scroll Progress Timeline**: a timeline that is linked to the scroll position of a scroll container along a particular axis.
- **View Progress Timeline**: a timeline that is linked to the relative position of a particular element within its scroll container.
### Scroll Progress Timeline
A Scroll Progress Timeline is an animation timeline that is linked to progress in the scroll position of a scroll container–also called _scrollport_ or _scroller_–along a particular axis. It converts a position in a scroll range into a percentage of progress.

The starting scroll position represents 0% progress and the ending scroll position represents 100% progress. In the following visualization, you can see that the progress counts up from 0% to 100% as you scroll the scroller from top to bottom.

### View Progress Timeline

This type of timeline is linked to the relative progress of a particular element within a scroll container. Just like a Scroll Progress Timeline, a scroller’s scroll offset is tracked. Unlike a Scroll Progress Timeline, it’s the relative position of a subject within that scroller that determines the progress.

This is somewhat comparable to how [`IntersectionObserver`](https://developer.mozilla.org/docs/Web/API/Intersection_Observer_API) works, which can track how much an element is visible in the scroller. If the element is not visible in the scroller, it is not intersecting. If it is visible inside the scroller–even for the smallest part–it is intersecting.

A View Progress Timeline begins from the moment a subject starts intersecting with the scroller and ends when the subject stops intersecting the scroller. In the following visualization, you can see that the progress starts counting up from 0% when the subject enters the scroll container and reaches 100% at the very moment the subject has left the scroll container.

