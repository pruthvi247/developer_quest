[Source](https://blog.nonstopio.com/advanced-theming-techniques-in-flutter-effortless-color-schemes-part-2-d7ae0db8b156)

# **What is a ColorScheme? 🎨**

Flutter, a `ColorScheme` is a comprehensive set of colors used to define the color palette of your application's user interface (UI). It is part of the `material` library, which provides a consistent and cohesive way to manage the colors used across your app. The `ColorScheme` class is designed to cover all the major elements in a typical UI, ensuring that your app maintains a uniform look and feel.

## Key Properties of `ColorScheme`

A `ColorScheme` includes a total of **45** colors here are the few important colors and their usage:

- **primary**: The primary color of your application, used for major UI elements like the app bar and the floating action button.
- **primaryVariant**: A darker variant of the primary color.
- **secondary**: The secondary color, used for accenting parts of the UI like action buttons and selection controls.
- **secondaryVariant**: A darker variant of the secondary color.
- **surface**: The background color for widgets like cards and sheets.
- **background**: The overall background color for screens and larger UI elements.
- **error**: The color used to indicate errors.
- **onPrimary**: A color used for text and icons displayed on top of the primary color.
- **onSecondary**: A color used for text and icons displayed on top of the secondary color.
- **onSurface**: A color used for text and icons displayed on top of surfaces.
- **onBackground**: A color used for text and icons displayed on top of the background color.
- **onError**: A color used for text and icons displayed on top of error colors.

**Example of Defining a** `**ColorScheme**`
```dart
import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme(
  primary: Colors.blue,
  primaryVariant: Colors.blueAccent,
  secondary: Colors.green,
  secondaryVariant: Colors.greenAccent,
  surface: Colors.white,
  background: Colors.grey.shade200,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
  // More colors
);
```
## Applying a ColorScheme to Your App

To apply the `ColorScheme` to your app, you can use it within the `ThemeData` of your `MaterialApp`:
```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: colorScheme,
    // other theme properties
  ),
  home: MyHomePage(),
);
```
# How to make ColorShceme

The main challenge developers face is to create appropriate `ColorScheme` for the app. To generate `ColorScheme` giving colors manually to the ColorScheme class is a very tedious process and developers need to know the purpose of every color in the `ColorScheme`

There are various ways to generate `ColorScheme` by defining seed colors.

## **ColorScheme.fromSeed**

Generates a complete color scheme based on a single seed color, adhering to Material Design 3 principles.

**Benefits:**

- Efficiency: Creates a cohesive scheme from one input.
- Accessibility: Ensures color contrast meets accessibility standards.
- Harmony: Colors work well together aesthetically.
```dart
final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 57, 185, 127),
      brightness: Brightness.light,
  );
```
## **ColorScheme.fromSwatch**

Create a color scheme from a `MaterialColor` swatch (a set of related colors).

**Caution:** This method might be deprecated in future versions of flutter
```dart
final colorScheme = ColorScheme.fromSwatch(
      brightness: Brightness.light,
      accentColor: Colors.purpleAccent,
      primarySwatch: Colors.blue,
      backgroundColor: Colors.grey,
      cardColor: Colors.yellow,
      errorColor: Colors.red,
    );
```
## ColorScheme.fromImageProvider

This feature lets you create color themes that match the colors in an image. It uses special tools to analyze the image and pick out colors that work well together. We’ll explain more about how it works in future posts.

# How is ColorScheme generated?

Here’s a deeper dive into how `ColorScheme` get generated behind the scenes.  
**1. Tonal Palette Construction:**

- **HSL Color Space:** The seed color is converted to the HSL (Hue, Saturation, Lightness) color space. HSL is well-suited for manipulating color relationships while maintaining harmony.
- **Hue Preservation:** The Hue value (representing the color itself) from the seed color is largely preserved.
- **Lightness and Saturation Adjustments:** Multiple tonal palettes are created by systematically varying the Lightness and Saturation values of the seed color. This creates a range of lighter, darker, and more or less vibrant colors related to the seed color.
![[Pasted image 20240805171552.png]]
**2. Color Selection for ColorScheme Properties:**

- **Material Design Principles:** Predefined algorithms based on Material Design guidelines are used to select specific colors from the tonal palettes. These algorithms consider factors like:
- **Harmony:** Colors should complement each other and create a visually pleasing aesthetic.
- **Contrast:** Sufficient contrast between foreground and background elements is crucial for accessibility.
- **Balance:** The color scheme should be balanced, avoiding overwhelming dominance of any single color.

ColorScheme is generated based on color palettes for the given brightness.
![[Pasted image 20240805171712.png]]
**Additional Notes:**

- **Non-exact Primary Color:** As mentioned earlier, the `primary` color in the resulting `ColorScheme` might not be an exact match for the provided seed color. This is because the selection process prioritizes Material Design principles and accessibility over a strict one-to-one mapping.
- **Customization:** You have the option to override specific colors in the generated `ColorScheme` using additional parameters to the `fromSeed` constructor. This allows you to fine-tune certain parts of the color theme.
# But..

Creating ColorScheme through code without visualizing all the generated colors is inefficient. So instead of creating ColorScheme manually, there are multiple ways we can do it through [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/).
# Material Theme Builder

Material Theme Builder is a tool that helps you design and customize themes based on Material Design 3 (M3) [https://m3.material.io/](https://m3.material.io/). It allows you to:

- **Visualize dynamic color:** Play around with different color combinations and see how they affect your theme in real-time.
- **Create a custom Material Design 3 theme:** Design your theme using the M3 color system and incorporate your brand colors.
- **Generate code:** Easily export your theme code in various formats, including **Flutter(Dart)**, Android Views (XML), Jetpack Compose (Kotlin), and Design System Package (DSP). This makes it simple to integrate your theme into your development workflow.
Overall, Material Theme Builder bridges the gap between design and development by providing a visual interface for creating M3 themes and offering code generation for seamless implementation. This can be also shared with a designer to create their colors and share the flutter code.

In addition to generating colors material theme also has support for fonts now so we can choose Google font as per requirement and it will be included in the generated code. The generated code contains the following files.

- **ThemeData.dart**

ThemeData file contains light, dark, lightMediumContrast, darkMediumContrast, lightHighContrast, and darkHighContrast ColorScheme.

- **Util.dart**

This file contains a function that creates a TextTheme based on the Google font we have given.

- **Main.dart**

This file has a sample code that shows how to use Generated ColorScheme and TextThems.
