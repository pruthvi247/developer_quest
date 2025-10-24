[free-code-camp-blog](https://www.freecodecamp.org/news/learn-css-media-queries-by-building-projects/)

# Scss
SCSS is a pre-processor of CSS which is more powerful than regular CSS. Using SCSS we can
1. Nest our selectors like a branch of a tree and better manage our code.
2. Store various values into variables
3. Use Mixins to stop code repetition and save time

**CSS** is the styling language that any browser understands to style webpages.

**SCSS** is a special type of file for `SASS`, a program written in Ruby that assembles `CSS` style sheets for a browser, and for information, `SASS` adds lots of additional functionality to `CSS` like variables, nesting and more which can make writing `CSS` easier and faster.  

**SCSS files** are processed by the server running a web app to output a traditional `CSS` that your browser can understand.
## CSS

In CSS we write code as depicted bellow, in full length.

```css
body{
 width: 800px;
 color: #ffffff;
}
body content{
 width:750px;
 background:#ffffff;
}
```
## SCSS

In SCSS we can shorten this code using a `@mixin` so we don’t have to write `color` and `width` properties again and again. We can define this through a function, similarly to PHP or other languages.

```scss
$color: #ffffff;
$width: 800px;

@mixin body{
 width: $width;
 color: $color;

 content{
  width: $width;
  background:$color;
 }
}
```


!!!! Note : NOT-COMPLETED //TODO
