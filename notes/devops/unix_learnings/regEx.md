[source-blog](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#site-photo-figure)
iteral text matching and RegEx pattern matching have a large overlap. RegEx patterns only get _RegExy_ when you include a small subset of special characters (such as `*`, `.`, and `+`). If, for example, you're only searching for simple alpha-numeric strings, RegEx pattern matching _is_ performing _literal text matching_.

When you search for the RegEx pattern, `dog`, you're searching for the _literal_ string, `dog`. And, when you search for the RegEx pattern, `TODO:`, you're searching for the _literal_ string, `TODO:`.

And, of course, RegEx provides an "escape valve" when you have to include one of the special characters but you want it to match as a literal character. All you have to do is escape it.

The most basic escape is the back-slash (`\`). When you include a `\` in your pattern, it tells the RegEx engine to treat the next character as a _literal_ character. In the following pattern, we're going to escape the (`.`) character which normally means "match any character":

`212\.555\.1234`

In this case, the `\.` matches on the literal (`.`) character.

If your text contains multiple special characters and you don't want to escape them individually, some IDEs (depending on the underlying RegEx engine) allow you to escape an entire segment by wrapping it with the `\Q` prefix and `\E` suffix:

`\Q212.555.1234\E`

In this case, we're matching on the literal (`.`) character. This `\Q`-`\E` notation means "quote". Which makes it easy to remember since `Q` and `E` are the first and last letters in the word, "quote", respectively. And, the `\E` is optional if it's at the end of the pattern:

`\Q212.555.1234`

Notice that I have the leading `\Q`, but _no_ `\E` at the end.

At this point, you have everything you need to start using the RegEx pattern matching mode for _all_ searches in your IDE. And, even if all of your searches are for _escaped_ or _quoted_ literal values, this is your starting-off point. From there, you can begin to play with more powerful pattern matching constructs as you get comfortable.

But, I don't want to turn this into a generic RegEx tutorial. My goal here is only to share the practical pattern matching techniques that I use _every day_ to locate code within my projects. And, I hope that it will inspire you to start experimenting with more RegEx in your own life.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-multiple-words-at-the-same-time "Link directly to this section: Finding Multiple Words at the Same Time")Finding Multiple Words at the Same Time

One of the easiest RegEx constructs to use is the pipe (`|`) which "OR"s together two different patterns. This allows me to search for multiple string literals (or patterns) at the same time. For example, I might be looking for all instances of "timers" in my JavaScript:

`setTimeout|setInterval`

This will match on _either_ `setTimeout` _or_ `setInterval`.

You can use (`|`) as many times as you want within a RegEx pattern. You can even use parenthesis to perform a local grouping of OR'd values. For example, I can rewrite the above pattern to "factor out" the `set` prefix:

`set(Timeout|Interval)`

This will still match on either `setTimeout` or `setInterval`; but, it goes about it in a slightly different way.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-slight-variations-in-spelling "Link directly to this section: Finding Slight Variations in Spelling")Finding Slight Variations in Spelling

I am a terrible speller. And, when it comes to words that might have a dash in them, I am both _terrible_ and _inconsistent_. Which means that I might use both `copilot` and `co-pilot` in the same piece of writing.

If I wanted to locate both of these spelling variations at the same time, I could include the (`?`) character, which marks the preceding character as optional:

`co-?pilot`

The `-?` tells the RegEx engine that the `-` character may not exist; and, that it must match on either `co-pilot` or `copilot`.

Sometimes, I combine two special characters to make this a bit more flexible. Instead of using the `-` in this example, I can use the `.` character. In RegEx, (`.`) means "match any character" (usually except the newline). I can use the pattern `.?` to mean match any character, optionally (ie, zero or one times):

`co.?pilot`

This will match `co-pilot` and `copilot`. But, it will also match `co_pilot` and `co:pilot`. Not that I need to match on those latter two; but, if they were in the target text, the matches would be found.

> **Aside**: The (`.?`) construct is particularly helpful in AngularJS where there are a variety of ways in which to invoke a directive in the HTML. For example, `ng-bind`, `ng:bind`, and `ng_bind` are equivalent references to the `ngBind` directive. I could, therefore, use the RegEx pattern, `ng.?bind`, to locate both the directive definition (`ngBind`) and all of the directive references in the same search.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-a-word-that-is-not-a-substring "Link directly to this section: Finding a Word That is Not a Substring")Finding a Word That is Not a Substring

Sometimes, I need to find a word that is also a common substring in other words. For example, I might want to find the word `timeout` but _not_ match on `setTimeout`. The easiest thing to do here is include a "word boundary" match (`\b`). The (`\b`) character tells the RegEx engine to find the places where a "word character" and "non-word character" are next to each other.

To find `timeout` and _only_ `timeout`, I can search for:

`\btimeout`

This tells the RegEx engine to find `timeout`, but only if the `t` is located at a word boundary. Which will match on `timeout` but _not_ on `setTimeout`.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-a-quoted-value "Link directly to this section: Finding a Quoted Value")Finding a Quoted Value

Sometimes, I need to find a quoted value. But, I don't know if the value will be quoted using single-quotes or double-quotes. As such, I use a "character class" (also known as a "character set") to allow for either possibilities. A character class uses `[xyz]` notation; and, tells the RegEx engine to match one of either `x`, `y`, or `z`.

So, if I needed to find the quoted value, `some-value`, I can create a pattern that includes either type of quotes:

`['"]some-value['"]`

The character class, `['"]`, means match either the single-quote character or the double-quote character. Which means that the previous pattern will match both `"some-value"` and `'some-value'`.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-a-quoted-substring "Link directly to this section: Finding a Quoted Substring")Finding a Quoted Substring

Sometimes, I need to find a substring that is contained within a quoted value but which does not represent the _entire_ quoted value. This most often comes up when I am searching for tokens inside an HTML attribute.

For example, I might have an HTML div with a number of CSS classes; and, I'm trying to find HTML elements that have the `class` of `project`:

`<div class="card project priority">`

This is a particularly hard problem with the `class` attribute because an element can have any number of CSS class names; and, the names can be in any order. So, a _literal_ match isn't feasible.

In this case, I can use a "negated character class". This uses the same `[xyz]` notation as the previous character class; only, we're going to prefix it with (`^`): `[^xyz]`. This tells the RegEx engine to match any character that is _not_ `x`, `y`, or `z`.

With this, I can create a pattern that locates the `project` token inside a quote:

`class="[^"]*project`

Here, the `[^"]*` tells the RegEx engine to match zero-or-more characters before the `project` literal so long as _none_ of those characters are `"`. This prevents the match from going past the boundaries of the attribute value.

> **Aside**: By default, RegEx matching is "greedy"; which means, it will try to find the longest string first and then back-track in an effort to find shorter strings (as needed). This can be computationally expensive. To make the matching more efficient - in this case - we can turn the pattern into a lazy match by adding `?` after the `*`. As in: `[^"]*?`. This will do (roughly) the same thing; but, will try to make the shorter match first before attempting a longer match (if needed).

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-things-that-dont-exist "Link directly to this section: Finding Things That Don't Exist")Finding Things That Don't Exist

Most of my pattern matching deals with constructs that are _in_ the code. But, sometimes, I need to look for things that _aren't_ there. Consider throwing errors in JavaScript. Technically, these two lines of code do the same thing:

`throw( new Error( "Oh no!" ) );`

... and, without the `new` operator:

`throw( Error( "Oh no!" ) );`

Internally, the native `Error` class checks to see if it's being invoked as a constructor; and, normalizes the two calls on the developer's behalf.

But, just because something works, it doesn't mean that it's "right". And, as a discerning engineer, I always want to include the `new` operator. And so, to find incorrect invocations, I need to search for cases of `Error` that are _not preceded by_ the `new` keyword.

To do this, I can use a "negative look behind" assertion:

`(?<!new) Error`

This tells the RegEx engine to match the `Error` literal; but, only if it isn't preceded by `new`.

RegEx allows for look behinds that are either negative `(?<!)` or positive `(?<=)`. And, allows for look aheads that are either negative `(?!)` or positive `(?=)`. These are complicated constructs; so, I won't go into any more detail.

That said, this negative look behind assertion can also be a great way to weed-out false positives in your matches. For example, the pattern:

`(?<!trans)action`

... will find matches for `action` but will _omit_ any matches for `transaction`.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#finding-variability-in-property-references "Link directly to this section: Finding Variability in Property References")Finding Variability in Property References

In ColdFusion, component properties can be accessed in two different ways: either as a direct variable reference or as an accessor invocation. For example, a component that has the property, `redis`, can access this property using either of these two calls:

- `redis` - direct reference.
- `getRedis()` - accessor invocation.

Which means, method calls - like `.hmget()` - on the `redis` property can be written as either:

- `redis.hmget()`
- `getRedis().hmget()`

If I want to find all the places in which the `hmget` method is being invoked, I need to account for both of these access patterns:

`(get)?redis[().\s]+hmget`

Here, we're saying that the `get` prefix is optional. And, that `redis` is followed by some combination of characters including, `[().\s]`, before the `hmget` token is matched. The use of the character class accounts for both the accessor invocation and the direct reverence since it will match on both `redis.` and `redis().`. And, the `\s` allows for white space (line-breaks) between the `redis` reference and the method call.

## [](https://www.bennadel.com/blog/4532-the-regex-of-everyday-things.htm?site-photo=570#dipping-your-toe-into-pattern-matching "Link directly to this section: Dipping Your Toe Into Pattern Matching")Dipping Your Toe Into Pattern Matching

I cannot say it enough, that RegEx pattern matching is an essential tool to have in your tool belt. But, I understand that Regular Expression patterns represent a lot of complexity; and, that a lot of people don't know where to start. I hope that I've demonstrated that using RegEx pattern matching in your code search is a great first step. You can start off super simple (especially with literal matches); and then, practice these techniques daily and slowly build up a better understanding through repetition.