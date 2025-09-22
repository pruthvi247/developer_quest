# Extensions
[medium-source](https://medium.com/@oanthony590/flutters-superpowers-unleashing-the-magic-of-extensions-and-typedefs-for-form-validation-cd6094a6db7e)
With extensions, you can write methods, getters, and setters that appear to be part of the original class, even though they are not. For example, let’s say you want to add a method to the `String` class that capitalizes the first letter of each word in a string. You can do this with an extension. Here’s a sample code:
```dart
extension StringExtensions on String {
  String capitalize() {
    return this
        .split(' ')
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .join(' ');
  }
}
```
With this extension, you can now call the `capitalize` method on any string:
```dart
String greeting = "hello world";  
String capitalizedGreeting = greeting.capitalize();  
print(capitalizedGreeting); // "Hello World"
```
## Creating a Custom Color Palette With Extensions

In Flutter, you can define a custom color palette using `MaterialColor` class. However, it can be cumbersome to create a `Map` of shades for each color. To simplify this process, you can create an extension on the`Color` class to generate a `MaterialColor`. Here’s an example code to do this:
```dart
extension CustomColorPalette on Color {
  MaterialColor createMaterialColor() {
    final List<double> strengths = <double>[
      .05,.1,.2,.3,.4,.5,.6,.7,.8,.9
    ];
    Map<int, Color> swatch = {};
    final int primaryValue = this.value;
    for (int i = 0; i < 10; i++) {
      final double strength = strengths[i];
      final int alpha = (0xFF * strength).round();
      final int value = (primaryValue & 0xFFFFFF) | (alpha << 24);
      swatch[100 + i * 100] = Color(value);
    }
    return MaterialColor(primaryValue, swatch);
  }
}

```
```dart
//// invoking
Color myColor = Colors.blue;  
MaterialColor myCustomColorPalette = myColor.createMaterialColor();
```
## Validating Email Address Using Extensions

You may need to validate email addresses in your app. You can write an extension on `String` class to perform this validation:
```dart
extension EmailValidator on String {
  bool isValidEmail() {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
}
///// invoking
String email = "test@example.com";  
bool isValid = email.isValidEmail(); // true
```
# Typedefs

Typedefs are another language feature of Dart that allow you to define function signatures. With typedefs, you can define a type alias for a function signature, which makes it easier to declare variables and parameters of that type. For example, let’s say you have a function that takes a `String` argument and returns an `int`:
```dart
int stringToInt(String str) {  
return int.parse(str);  
}
```
You can define a typedef for this function signature like this:
```dart
typedef StringToInt = int Function(String);
```
Now, you can declare a variable or parameter of the `StringToInt` type, which is equivalent to the function signature:
```dart
StringToInt myFunction = stringToInt;  
int result = myFunction("123");
```
## OnPressed Callback Using TypeDefs

In Flutter, you can pass a callback function to a `RaisedButton`'s `onPressed` parameter. You can define a `typedef` for this callback to make your code more readable:
```dart
typedef OnPressedCallback = void Function();

class MyButton extends StatelessWidget {
  final OnPressedCallback onPressed;
  MyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text("Press me!"),
    );
  }
}
```
Now you can use `OnPressedCallback` type instead of repeating the function signature throughout your code:
```dart
void _onButtonPressed() {
  // do something
}
MyButton(
  onPressed: _onButtonPressed,
)
```
## Custom Validator Function using TypeDefs
In Flutter, you can use form validation to ensure that user input is valid. You can define a `typedef` for the validation function to make it easier to declare validator functions:
The `validator` has been defined like
```dart
typedef FormFieldValidator<T> = String? Function(T? value);
```
It should return nullable data and provide value on callback. You can use
```dart
required FormFieldValidator validator,
```
It will be same as `required String Function(String?) validator,`
and use like `validator: validator,`
```dart
Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardtype,
  required Function(String?) submitFunction,
  required FormFieldValidator validator,
  required Widget prefix,
  ValueChanged<String>? onchange,
  String labelText = 'Enter Text ...',
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardtype,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefix,
        border: OutlineInputBorder(),
      ),
      onFieldSubmitted: submitFunction(),
      onChanged: onchange,
      validator: validator,
    );
```
Typedefs are particularly useful when you have complex function signatures that are used in multiple places in your code. By defining a typedef, you can give the function signature a name, which makes your code more readable and easier to understand.