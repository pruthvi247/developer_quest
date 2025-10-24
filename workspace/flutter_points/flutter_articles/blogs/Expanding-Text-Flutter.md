I’m pretty sure that your app contains a lot of text: titles, descriptions, hints, etc. And not all of those texts are necessary for the user to see. So, sometimes, you want to hide part of them. A short description of a movie provides enough information for a user to decide if he wants to read more. And the common pattern is to truncate this text, maybe ellipsize it, to allow the user to expand it in some way (e.g. tapping on the whole text or on the ellipsis).


If you want to crop the text and allow the user to expand it with a tap — there is a very simple solution. We just need to create`StatefulWidget` with a boolean property indicating that the text is expanded (e.g. `isExpanded`). Then we need to wrap the `Text` widget with `GestureDetector` and invert `isExpanded` property in its `onTap` callback. The `overflow` property of `Text` defines the way the text is cropped. Also, we define `maxLines` property depending on the current state.


```dart
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({Key key, this.maxLines, this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Text(
          widget.text,
          overflow: TextOverflow.ellipsis,
          maxLines: _isExpanded ? null : widget.maxLines,
        ),
      );
}
```
Ok, it was easy. Default implementation of `Text` offers only 4 options on overflow:

1. `TextOverflow.clip` crops overflowing text;
2. `TextOverflow.fade` fades the end of the last line to transparent;
3. `TextOverflow.ellipsis` uses ellipsis to indicate that the text has overflowed;
4. `TextOverflow.visible` renders overflowing text outside of its container.

But what if we need to customize the ellipsis?

# Here comes `TextPainter`

`TextPainter` allows you to draw your text right on `Canvas` , and it provides you with this `Canvas` and `Size` in `paint()` method. Also, `TextPainter` has `ellipsis` property, that allows you to override the string which will be substituted at the end of the cropped text. `TextPainter` allows us to set ellipsis and define the maximum number of lines. But it needs `CustomPaint` to render. And `CustomPaint` works in pair with `CustomPainter` , so we need to wrap use the `TextPainter` inside of `CustomPainter` . Note that you also must set `textDirection` to let `TextPainter` know where the line’s end is.

```dart
class MyTextPainter extends CustomPainter {
  final TextSpan text;
  final int maxLines;
  final String ellipsis;

  MyTextPainter({this.text, this.ellipsis, this.maxLines}) : super();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    TextPainter painter = TextPainter(
      text: text,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..ellipsis = this.ellipsis;
    painter.layout(maxWidth: size.width);
    painter.paint(canvas, Offset(0, 0));
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  var someVeryLongText = // Some realy long text

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            child: CustomPaint(
              size: Size(double.infinity, 300),
              painter: MyTextPainter(
                text: TextSpan(text: someVeryLongText, style: TextStyle(color: Colors.black54)),
                ellipsis: "... more",
                maxLines: 4,
              ),
            ),
          ),
        ),
      );
}
```
And voilà, there’s the custom ellipsis!

But this solution is not very flexible: “more” is just the part of the text. Also, you could notice that `CustomPaint` requires the size of the area for painting. How to calculate it? We’ll find it out a bit later.

# Some maths with lines

But my goal was to implement an expandable text widget that ellipsizes the text based on the “maximum lines” attribute. It also must be expanded by a tap on the word “more” appended after the ellipsis. Also, I want this “more” word to be styled differently from the main text.

Different styles, tappable parts… Sounds like we need `RichText` . But it can ellipsize text just like the regular `Text` do (actually, `Text` renders `RichText` under the hood). So, if it had many spans in it, all of them would be cropped.

Ok, let’s get to it.

First of all, we need to know how the text is gonna be rendered. Unfortunately, I couldn’t figure out how text would render line by line, but we can get rectangles describing bounds of these lines. `RenderObject`serves this purpose. It defines the base layout model. Hence we can get bounds of the text after layout. But we need `Constraints` to perform layout, so let’s wrap it in `LayoutBuilder` . Since text can either be expanded or stay the same, the widget must hold the state.

```dart
class ExpandableText extends StatefulWidget {
  final TextSpan textSpan;
  final TextSpan moreSpan;
  final int maxLines;

  const ExpandableText({
    Key key,
    this.textSpan,
    this.maxLines,
    this.moreSpan,
  })
      : assert(textSpan != null),
        assert(maxLines != null),
        assert(moreSpan != null),
        super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  static const String _ellipsis = "\u2026\u0020"; // Unicode symbols for "… "

  bool _isExpanded = false;

  GestureRecognizer get _tapRecognizer => TapGestureRecognizer()
    ..onTap = () {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    };

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          // TODO: we'll do some maths here
        },
      );
}
```
Now we can get the `RenderParapgraph` ( `RenderObject` that displays paragraph of text), layout it and get bounds of each line with `getBoxesForSelection` method.

```dart
extension _TextMeasurer on RichText {
  List<TextBox> measure(BuildContext context, Constraints constraints) {
    final renderObject = createRenderObject(context)..layout(constraints);
    return renderObject.getBoxesForSelection(
      TextSelection(
        baseOffset: 0,
        extentOffset: text.toPlainText().length,
      ),
    );
  }
}
class _ExpandableTextState extends State<ExpandableText> {
  // ...

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final maxLines = widget.maxLines;

          final richText = Text.rich(widget.textSpan).build(context) as RichText;
          final boxes = richText.measure(context, constraints);

          if (boxes.length <= maxLines || _isExpanded) {
            return RichText(text: widget.textSpan);
          } else {
            // TODO: deal with ellipsized text
          }
        },
      );
}
```

If the number of lines is less than the maximum number or if the widget is in the expanded state we can just render our text as-is.

Otherwise, let’s do some simple maths. We cannot get the content of each line. But we know the length of each line in pixels. So we can:

1. Calculate the total length of the maximum number of lines;
2. Calculate the total length of all the lines;
3. Count the ratio of these values;
4. Take the approximate length of cropped string, by multiplying the length of the full string on this ratio;
5. Take substring of the length that we’ve got.

Here’s the relevant code:

```dart
class _ExpandableTextState extends State<ExpandableText> {
  static const String _ellipsis = "\u2026\u0020";

  String get _lineEnding => "$_ellipsis${widget.moreSpan.text}";
// ...

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final maxLines = widget.maxLines;

          final richText = Text.rich(widget.textSpan).build(context) as RichText;
          final boxes = richText.measure(context, constraints);

          if (boxes.length <= maxLines || _isExpanded) {
            return RichText(text: widget.textSpan);
          } else {
            final croppedText = _ellipsizeText(boxes);
            final ellipsizedText = _buildEllipsizedText(croppedText, _tapRecognizer);

            if (ellipsizedText.measure(context, constraints).length <= maxLines) {
              return ellipsizedText;
            } else {
              final fixedEllipsizedText = croppedText.substring(0, croppedText.length - _lineEnding.length);
              return _buildEllipsizedText(fixedEllipsizedText, _tapRecognizer);
            }
          }
        },
      );

  String _ellipsizeText(List<TextBox> boxes) {
    final text = widget.textSpan.text;
    final maxLines = widget.maxLines;

    double _calculateLinesLength(List<TextBox> boxes) => boxes.map((box) => box.right - box.left).reduce((acc, value) => acc += value);

    final requiredLength = _calculateLinesLength(boxes.sublist(0, maxLines));
    final totalLength = _calculateLinesLength(boxes);

    final requiredTextFraction = requiredLength / totalLength;
    return text.substring(0, (text.length * requiredTextFraction).floor());
  }

  RichText _buildEllipsizedText(String text, GestureRecognizer tapRecognizer) => RichText(
        text: TextSpan(
          text: "$text$_ellipsis",
          style: widget.textSpan.style,
          children: [widget.moreSpan],
        ),
      );
}
```

All we need to do now is to create `TextSpan` with this new string and desired style and append ellipsis and “more” word with the other style. But the resulting string may be longer than needed, and in that case just layout it again and check the number of lines. If it’s greater than the desired maximum number of lines… Ok, let’s just crop the substring of length `ellipsis + "more"` from the end of the truncated string. That’s all. No more layouts. Now we can prepare the final `RichText` .

Not too accurate (I mean, the “More” word is not always at the very end of the last line), but you can be sure that a user will see the exact number of lines.