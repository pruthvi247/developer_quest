
[source-medium](https://medium.com/flutter-community/design-system-from-scratch-in-flutter-bc2aebb8bb02)

Initially, many solutions are available to create a Design System for your app in Flutter. I want to share my experience with Design System, which we have implemented in our projects before.

## Why do we need a Design System?

In our example, we have applied it to share our design code between mobile, web, and desktop apps. As a result, it is an independent package working on its own. We can inject into any project in a few steps.

## Let’s start with the atomic parts.

As a first step, we divided all minor parts — colors, radiuses, shadows, etc into independent classes. Definitely, Implemented design system codes depend on the designer’s implementation.
![[Pasted image 20241209131507.png]]
As you can see, the designer divided atomic parts for us (thanks to our [designer](https://www.linkedin.com/in/gadirli/))

I will not mention all the code; it will be snippets. They are like the following examples:
```dart
/// {@template app_colors}  
/// Colors class for themes which provides direct access with static fields.  
/// {@endtemplate}  
class AppColors {  
AppColors._();  
  
/// The color white  
static const white = Colors.white;  
  
/// The color black  
static const black = Colors.black;  
  
/// The color transparent  
static const transparent = Colors.transparent;  
  
/// Brand color palette.  
static const brand = MaterialColor(  
0xFF347AF6,  
{  
50: Color(0xFFF0F5FF),  
100: Color(0xFFE0ECFF),  
150: Color(0xFFD3E1FB),  
200: Color(0xFFBDD3F9),  
250: Color(0xFF9FBFF9),  
300: Color(0xFF81ACF9),  
400: Color(0xFF5A93F9),  
500: Color(0xFF347AF6),  
600: Color(0xFF1559D1),  
700: Color(0xFF174EAF),  
800: Color(0xFF1D4387),  
900: Color(0xFF163367),  
},  
);  
  
/// Light gray color palette.  
static const grayLight = MaterialColor(  
0xFF667085,  
{  
50: Color(0xFFFCFCFD),  
100: Color(0xFFF9FAFB),  
150: Color(0xFFF2F4F7),  
200: Color(0xFFEAECF0),  
250: Color(0xFFD0D5DD),  
300: Color(0xFF98A2B3),  
400: Color(0xFF667085),  
500: Color(0xFF475467),  
600: Color(0xFF344054),  
700: Color(0xFF182230),  
800: Color(0xFF101828),  
900: Color(0xFF0C111D),  
},  
);  
  
/// Dark gray color palette.  
static const grayDark = MaterialColor(  
0xFF85888E,  
{  
50: Color(0xFFFAFAFA),  
100: Color(0xFFF5F5F6),  
150: Color(0xFFF0F1F1),  
200: Color(0xFFECECED),  
250: Color(0xFFCECFD2),  
300: Color(0xFF94969C),  
400: Color(0xFF85888E),  
500: Color(0xFF61646C),  
600: Color(0xFF333741),  
700: Color(0xFF1F242F),  
800: Color(0xFF161B26),  
900: Color(0xFF0C111D),  
},  
);
```

```dart
/// {@template app_radius}  
/// Radius class contains all radius used in app  
/// {@endtemplate}  
class AppRadius {  
AppRadius._();  
  
/// Radius of 0.  
static const none = Radius.zero;  
  
/// Extra extra small radius of 2.  
static const xxs = Radius.circular(2);  
  
/// Extra small radius of 4.  
static const xs = Radius.circular(4);  
  
/// Small radius of 6.  
static const sm = Radius.circular(6);  
}
```

```dart
/// {@template app_shadow}  
/// Shadow class contains all shadows used in app  
/// {@endtemplate}  
class AppShadow {  
AppShadow._();  
  
  
/// Extra small shadow.  
static const xs = [  
BoxShadow(  
blurRadius: 2,  
offset: Offset(0, 1),  
color: Color.fromRGBO(16, 24, 40, 0.05),  
),  
];  
  
/// Small shadow.  
static const sm = [  
BoxShadow(  
color: Color(0x0F101828),  
blurRadius: 2,  
offset: Offset(0, 1),  
),  
BoxShadow(  
color: Color(0x19101828),  
blurRadius: 3,  
offset: Offset(0, 1),  
),  
];  
}
```

```dart
/// {@template app_spacing}
///  Class contains all space (does not matter is it vertical
///  or horizontal used in app
/// {@endtemplate}
class AppSpacing {
  AppSpacing._();

  /// No spacing.
  static const none = 0.0;

  /// Extra extra small spacing of 2.0.
  static const xxs = 2.0;

  /// Extra small spacing of 4.0.
  static const xs = 4.0;

  /// Small spacing of 6.0.
  static const sm = 6.0;
```
> **You can have more atomic parts in your projects.**

## Next stage — components

I will show you some of our components — like buttons, textfield. Other components developed in the same way.

## Theme development for component

I have written a new theme class for each of our components to keep them more clean. **_Sure, it is provided by our designer, too :)_**
![[Pasted image 20241209131712.png]]
> Keep in mind that Theme classes are extended from **ThemeExtension**, in this way, we can register them as theme extensions and use them with Theme class.

For instance, we can check Theme classes for buttons and text fields:

```dart
/// {@template app_button_theme}
/// Theme class which provides configuration of buttons
/// {@endtemplate}
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  /// {@macro app_button_theme}
  const AppButtonTheme({
    required this.primaryText,
    required this.primaryDefault,
    required this.primaryHover,
    required this.primaryFocused,
  });

  /// {@macro app_button_theme}
  factory AppButtonTheme.light() {
    return AppButtonTheme(
      primaryText: AppColors.white,
      primaryDefault: AppColors.brand.shade500,
      primaryHover: AppColors.brand.shade600,
      primaryFocused: AppColors.brand.shade700,
    );
  }

  /// The color of the primary text.
  final Color primaryText;

  /// The color of the primary button default.
  final Color primaryDefault;

  /// The color of the primary button hover.
  final Color primaryHover;

  /// The color of the primary button focused.
  final Color primaryFocused;

  @override
  ThemeExtension<AppButtonTheme> copyWith({
    Color? primaryText,
    Color? primaryDefault,
    Color? primaryHover,
    Color? primaryFocused,
  }) {
 return AppButtonTheme(
      primaryText: primaryText ?? this.primaryText,
      primaryDefault: primaryDefault ?? this.primaryDefault,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryFocused: primaryFocused ?? this.primaryFocused,
    );
  }

 @override
  ThemeExtension<AppButtonTheme> lerp(
    covariant ThemeExtension<AppButtonTheme>? other,
    double t,
  ) {
    if (other is! AppButtonTheme) {
      return this;
    }

 return AppButtonTheme(
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      primaryDefault: Color.lerp(primaryDefault, other.primaryDefault, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryFocused: Color.lerp(primaryFocused, other.primaryFocused, t)!,
    );
  }
}
```
```dart
/// {@template app_input_theme}
/// Theme class which provides configuration of [AppTextField]
/// {@endtemplate}
class AppInputTheme extends ThemeExtension<AppInputTheme> {
  /// {@macro app_input_theme}
  const AppInputTheme({
    required this.defaultText,
    required this.focusedOnBrand,
    required this.focusedTextDefault,
    required this.errorTextDefault,
    required this.successTextDefault,
    required this.disabledText,
    required this.borderDefault,
    required this.borderHover,
    required this.borderFocused,
    required this.borderError,
    required this.borderSuccess,
    required this.borderDisabled,
    required this.defaultColor,
    required this.disabledColor,
  });

  /// {@macro app_input_theme}
  factory AppInputTheme.light() {
    return AppInputTheme(
      defaultText: AppColors.grayLight.shade400,
      focusedOnBrand: AppColors.brand.shade500,
      focusedTextDefault: AppColors.grayLight.shade600,
      errorTextDefault: AppColors.error.shade400,
      successTextDefault: AppColors.success.shade400,
      disabledText: AppColors.grayLight[250]!,
      borderDefault: AppColors.grayLight[250]!,
      borderHover: AppColors.grayLight.shade300,
      borderFocused: AppColors.brand.shade500,
      borderError: AppColors.error.shade400,
      borderSuccess: AppColors.success.shade400,
      borderDisabled: AppColors.grayLight.shade200,
      defaultColor: AppColors.white,
      disabledColor: AppColors.grayLight.shade100,
    );
  }

  /// The default text color.
  final Color defaultText;

  /// The text color when focused on brand.
  final Color focusedOnBrand;

  /// The text color when focused.
  final Color focusedTextDefault;

  /// The text color when error.
  final Color errorTextDefault;

  /// The text color when success.
  final Color successTextDefault;

  /// The text color when disabled.
  final Color disabledText;

  /// The default border color.
  final Color borderDefault;

  /// The border color when hovered.
  final Color borderHover;

  /// The border color when focused.
  final Color borderFocused;

  /// The border color when error.
  final Color borderError;

  /// The border color when success.
  final Color borderSuccess;

  /// The border color when disabled.
  final Color borderDisabled;

  /// The default color.
  final Color defaultColor;

  /// The disabled color.
  final Color disabledColor;

  @override
  ThemeExtension<AppInputTheme> copyWith({
    Color? defaultText,
    Color? focusedOnBrand,
    Color? focusedTextDefault,
    Color? errorTextDefault,
    Color? successTextDefault,
    Color? disabledText,
    Color? borderDefault,
    Color? borderHover,
    Color? borderFocused,
    Color? borderError,
    Color? borderSuccess,
    Color? borderDisabled,
    Color? defaultColor,
    Color? disabledColor,
  }) {
    return AppInputTheme(
      defaultText: defaultText ?? this.defaultText,
      focusedOnBrand: focusedOnBrand ?? this.focusedOnBrand,
      focusedTextDefault: focusedTextDefault ?? this.focusedTextDefault,
      errorTextDefault: errorTextDefault ?? this.errorTextDefault,
      successTextDefault: successTextDefault ?? this.successTextDefault,
      disabledText: disabledText ?? this.disabledText,
      borderDefault: borderDefault ?? this.borderDefault,
      borderHover: borderHover ?? this.borderHover,
      borderFocused: borderFocused ?? this.borderFocused,
      borderError: borderError ?? this.borderError,
      borderSuccess: borderSuccess ?? this.borderSuccess,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      defaultColor: defaultColor ?? this.defaultColor,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  @override
  ThemeExtension<AppInputTheme> lerp(
    covariant ThemeExtension<AppInputTheme>? other,
    double t,
  ) {
    if (other is! AppInputTheme) {
      return this;
    }

    return AppInputTheme(
      defaultText: Color.lerp(defaultText, other.defaultText, t)!,
      focusedOnBrand: Color.lerp(focusedOnBrand, other.focusedOnBrand, t)!,
      focusedTextDefault: Color.lerp(
        focusedTextDefault,
        other.focusedTextDefault,
        t,
      )!,
      errorTextDefault: Color.lerp(
        errorTextDefault,
        other.errorTextDefault,
        t,
      )!,
      successTextDefault: Color.lerp(
        successTextDefault,
        other.successTextDefault,
        t,
      )!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      borderFocused: Color.lerp(borderFocused, other.borderFocused, t)!,
      borderError: Color.lerp(borderError, other.borderError, t)!,
      borderSuccess: Color.lerp(borderSuccess, other.borderSuccess, t)!,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
    );
  }
}
```

Moreover, we have an **AppTypography** class, which collects font sizes as an independent theme.

```dart
/// {@template app_typography}
/// Theme class which provides configuration of [TextStyle]
/// {@endtemplate}
interface class AppTypography extends ThemeExtension<AppTypography> {
  /// {@macro app_typography}
  AppTypography({
    required this.buttonLarge,
    required this.buttonMedium,
    required this.buttonSmall,
  });

  /// Button Large
  final TextStyle buttonLarge;

  /// Button Medium
  final TextStyle buttonMedium;

  /// Button Small
  final TextStyle buttonSmall;

  @override
  ThemeExtension<AppTypography> copyWith({
    TextStyle? buttonLarge,
    TextStyle? buttonMedium,
    TextStyle? buttonSmall,
  }) {
    return AppTypography(
      buttonLarge: buttonLarge ?? this.buttonLarge,
      buttonMedium: buttonMedium ?? this.buttonMedium,
      buttonSmall: buttonSmall ?? this.buttonSmall,
    );
  }

  @override
  ThemeExtension<AppTypography> lerp(
    covariant ThemeExtension<AppTypography>? other,
    double t,
  ) {
    if (other is! AppTypography) {
      return this;
    }

    return AppTypography(
      buttonLarge: TextStyle.lerp(buttonLarge, other.buttonLarge, t)!,
      buttonMedium: TextStyle.lerp(buttonMedium, other.buttonMedium, t)!,
      buttonSmall: TextStyle.lerp(buttonSmall, other.buttonSmall, t)!,
    );
  }
}

/// {@macro app_typography}
class AppRegularTypography extends AppTypography {
  /// {@macro app_typography}
  AppRegularTypography({
    super.buttonLarge = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
    ),
    super.buttonMedium = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
    ),
    super.buttonSmall = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
    ),
    ),
  });
}
```

## After all… Components

Component development depends on the design given by the designer. In reality, all the things we have developed above depend on. In our case, for instance, text buttons have many versions, such as size, decoration, etc.
![[Pasted image 20241209131904.png]]
Therefore, we have created a base class for our text buttons. Here is the code snippet:

```dart
/// {@template app_text_button}
/// A custom text button widget that adapts to the platform.
/// {@endtemplate}
abstract class AppTextButton extends StatelessWidget {
  /// {@macro app_text_button}
  const AppTextButton({
    super.key,
    required this.label,
    this.onTap,
    this.leading,
    this.trailing,
    this.appButtonSize = AppButtonSize.medium,
  });

  /// The label for the text button.
  final String label;

  /// The callback function for the text button.
  final VoidCallback? onTap;

  /// The leading icon for the text button.
  final IconBuilder? leading;

  /// The trailing icon for the text button.
  final IconBuilder? trailing;

  /// The size of the text button.
  final AppButtonSize appButtonSize;

  /// The background color for the text button.
  Color backgroundColor(BuildContext context);

  /// The focus color for the text button.
  Color focusColor(BuildContext context);

  /// The hover color for the text button.
  Color hoverColor(BuildContext context);

  /// The disabled color for the text button.
  Color disabledColor(BuildContext context);

  /// The text color for the text button.
  Color textColor(BuildContext context);

  /// The disabled text color for the text button.
  Color disabledTextColor(BuildContext context) {
    return context.buttonTheme.primaryTextDisabled;
  }

  /// The default border for the text button.
  BorderSide defaultBorder(BuildContext context) => BorderSide.none;

  /// The focused border for the text button.
  BorderSide focusedBorder(BuildContext context) => BorderSide.none;

  /// The hover border for the text button.
  BorderSide hoverBorder(BuildContext context) => BorderSide.none;

  /// The disabled border for the text button.
  BorderSide disabledBorder(BuildContext context) => BorderSide.none;

  @override
  Widget build(BuildContext context) {
    final betweenSpace = switch (appButtonSize) {
      AppButtonSize.small ||
      AppButtonSize.xSmall ||
      AppButtonSize.medium =>
        AppSpacing.xs,
      AppButtonSize.large || AppButtonSize.xlarge => AppSpacing.sm,
      AppButtonSize.xxLarge => AppSpacing.lg,
    };

    final inputTextColor = WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledTextColor(context);
        }

        return textColor(context);
      },
    );

    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor(context);
            }

            if (states.contains(WidgetState.hovered)) {
              return hoverColor(context);
            }

            if (states.contains(WidgetState.focused)) {
              return focusColor(context);
            }

            if (states.contains(WidgetState.pressed)) {
              return focusColor(context);
            }

            return backgroundColor(context);
          },
        ),
        shape: WidgetStateProperty.resolveWith(
          (states) {
            const shape = RoundedRectangleBorder(
              borderRadius: BorderRadius.all(AppRadius.md),
            );

            if (states.contains(WidgetState.disabled)) {
              return shape.copyWith(side: disabledBorder(context));
            }

            if (states.contains(WidgetState.focused)) {
              return shape.copyWith(side: focusedBorder(context));
            }

            if (states.contains(WidgetState.hovered)) {
              return shape.copyWith(side: hoverBorder(context));
            }

            if (states.contains(WidgetState.pressed)) {
              return shape.copyWith(side: focusedBorder(context));
            }

            return shape.copyWith(side: defaultBorder(context));
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor(context);
            }

            if (states.contains(WidgetState.hovered)) {
              return hoverColor(context);
            }

            if (states.contains(WidgetState.focused)) {
              return focusColor(context);
            }

            if (states.contains(WidgetState.pressed)) {
              return focusColor(context);
            }

            return backgroundColor(context);
          },
        ),
        foregroundColor: inputTextColor,
        fixedSize: WidgetStateProperty.all(
          switch (appButtonSize) {
            AppButtonSize.small ||
            AppButtonSize.xSmall =>
              const Size(double.infinity, 36),
            AppButtonSize.medium => const Size(double.infinity, 40),
            AppButtonSize.large => const Size(double.infinity, 44),
            AppButtonSize.xlarge => const Size(double.infinity, 48),
            AppButtonSize.xxLarge => const Size(double.infinity, 56),
          },
        ),
        padding: WidgetStateProperty.all(
          switch (appButtonSize) {
            AppButtonSize.small ||
            AppButtonSize.xSmall =>
              const EdgeInsets.symmetric(horizontal: 12),
            AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16),
            AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 16),
            AppButtonSize.xlarge => const EdgeInsets.symmetric(horizontal: 20),
            AppButtonSize.xxLarge => const EdgeInsets.symmetric(horizontal: 24),
          },
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!(
              onTap != null ? textColor(context) : disabledTextColor(context),
            ),
            SizedBox(width: betweenSpace),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: Text(
              label,
              style: switch (appButtonSize) {
                AppButtonSize.small ||
                AppButtonSize.xSmall =>
                  context.typography.buttonSmall,
                AppButtonSize.medium => context.typography.buttonMedium,
                AppButtonSize.large => context.typography.buttonLarge,
                AppButtonSize.xlarge => context.typography.buttonXLarge,
                AppButtonSize.xxLarge => context.typography.button2XLarge,
              },
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: betweenSpace),
            trailing!(
              onTap != null ? textColor(context) : disabledTextColor(context),
            ),
          ],
        ],
      ),
    );
  }
}
```
**AppButtonSize** is a simple enum provided by us:
```dart
/// Enum for button sizes
enum AppButtonSize {
  /// Extra small button size
  xSmall,

  /// Small button size
  small,

  /// Medium button size
  medium,

  /// Large button size
  large,

  /// Extra large button size
  xlarge,

  /// Extra extra large button size
  
```
**IconBuilder** is a simple typedef provided by us. In some cases, we can need to change the color of an icon within the inner state of the button (focus, hover, and other state colors can be applied to the color of the icon)
```dart
/// A function that builds an icon widget.  
typedef IconBuilder = Widget Function(Color iconColor);
```
Eventually, with the help of the base **AppTextButton** class, we can create our child classes. So, our Primary, Secondary, and Outlined text buttons’ codes will be like the following:

```dart
/// {@template primary_text_button}
/// A custom primary text button widget that adapts to the platform.
/// {@endtemplate}
class PrimaryTextButton extends AppTextButton {
  /// {@macro primary_text_button}
  const PrimaryTextButton({
    super.key,
    required super.label,
    super.onTap,
    super.leading,
    super.trailing,
    super.appButtonSize,
  });

  @override
  Color backgroundColor(BuildContext context) {
    return context.buttonTheme.primaryDefault;
  }

  @override
  Color disabledColor(BuildContext context) {
    return context.buttonTheme.primaryDisabled;
  }

  @override
  Color focusColor(BuildContext context) {
    return context.buttonTheme.primaryFocused;
  }

  @override
  Color hoverColor(BuildContext context) {
    return context.buttonTheme.primaryHover;
  }

  @override
  Color textColor(BuildContext context) {
    return context.buttonTheme.primaryText;
  }
}
```
```dart
/// {@template secondary_text_button}
/// A custom secondary text button widget that adapts to the platform.
/// {@endtemplate}
///
class SecondaryTextButton extends AppTextButton {
  /// {@macro secondary_text_button}
  const SecondaryTextButton({
    super.key,
    required super.label,
    super.onTap,
    super.leading,
    super.trailing,
    super.appButtonSize,
  });

  @override
  Color backgroundColor(BuildContext context) {
    return context.buttonTheme.secondaryDefault;
  }

  @override
  Color disabledColor(BuildContext context) {
    return context.buttonTheme.secondaryDisabled;
  }

  @override
  Color focusColor(BuildContext context) {
    return context.buttonTheme.secondaryFocused;
  }

  @override
  Color hoverColor(BuildContext context) {
    return context.buttonTheme.secondaryHover;
  }

  @override
  Color textColor(BuildContext context) {
    return context.buttonTheme.primaryTextOnBrand;
  }
}
```
```dart
/// {@template outline_text_button}
/// A custom outline text button widget that adapts to the platform.
/// {@endtemplate}
class OutlineTextButton extends AppTextButton {
  /// {@macro outline_text_button}
  const OutlineTextButton({
    super.key,
    required super.label,
    super.onTap,
    super.leading,
    super.trailing,
    super.appButtonSize,
  });

  @override
  Color backgroundColor(BuildContext context) {
    return context.buttonTheme.outlinedDefault;
  }

  @override
  Color disabledColor(BuildContext context) {
    return context.buttonTheme.outlinedDisabled;
  }

  @override
  Color focusColor(BuildContext context) {
    return context.buttonTheme.outlinedFocused;
  }

  @override
  Color hoverColor(BuildContext context) {
    return context.buttonTheme.outlinedHover;
  }

  @override
  Color textColor(BuildContext context) {
    return context.buttonTheme.buttonLineDefault;
  }

  @override
  BorderSide defaultBorder(BuildContext context) {
    return BorderSide(
      color: context.buttonTheme.buttonLineDefault,
    );
  }

  @override
  BorderSide focusedBorder(BuildContext context) {
    return BorderSide(
      color: context.buttonTheme.buttonLineDefault,
    );
  }

  @override
  BorderSide hoverBorder(BuildContext context) {
    return BorderSide(
      color: context.buttonTheme.buttonLineDefault,
    );
  }

  @override
  BorderSide disabledBorder(BuildContext context) {
    return BorderSide(
      color: context.buttonTheme.outlinedBorderDisabled,
    );
  }
}
```
For the text field, we have created again an independent AppTextField class.
![[Pasted image 20241209132144.png]]

```dart
/// {@template app_text_field}
/// A customizable text field widget with various customization options.
/// {@endtemplate}
class AppTextField extends StatelessWidget {
  /// {@macro app_text_field}
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.helperText,
    this.errorText,
    this.suffixIcon,
    this.suffixIconConstraints =
        const BoxConstraints(minHeight: 24, minWidth: 40),
    this.prefixIcon,
    this.prefixIconConstraints =
        const BoxConstraints(minHeight: 24, minWidth: 40),
    this.autofillHints,
    this.onEditingComplete,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The label text for the text field.
  final String? labelText;

  /// Whether the text field is enabled.
  final bool enabled;

  /// Whether the text field is obscured.
  final bool obscureText;

  /// Called when the text field value changes.
  final ValueChanged<String>? onChanged;

  /// The autovalidate mode for the text field.
  final AutovalidateMode autovalidateMode;

  /// The validator for the text field.
  final FormFieldValidator<String>? validator;

  /// The helper text for the text field.
  final String? helperText;

  /// The error text for the text field.
  final String? errorText;

  /// The suffix icon for the text field.
  final Widget? suffixIcon;

  /// The constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// The prefix icon for the text field.
  final Widget? prefixIcon;

  /// The constraints for the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// The autofillhints for app text field.
  final Iterable<String>? autofillHints;

  /// Called when the text field value completed.
  final VoidCallback? onEditingComplete;

  /// The input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// The keyboard type for the text field.
  final TextInputType? keyboardType;

  /// the maximum lines available in text field.
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onEditingComplete: onEditingComplete,
      autofillHints: autofillHints,
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      validator: validator,
      maxLines: maxLines,
      style: WidgetStateTextStyle.resolveWith(
        (states) {
          late final Color textColor;

          if (states.contains(WidgetState.error)) {
            textColor = context.inputTheme.focusedTextDefault;
          } else if (states.contains(WidgetState.focused)) {
            textColor = context.inputTheme.focusedTextDefault;
          } else if (states.contains(WidgetState.disabled)) {
            textColor = context.inputTheme.disabledText;
          } else {
            textColor = context.inputTheme.defaultText;
          }

          return context.typography.inputPlaceHolder.copyWith(
            color: textColor,
          );
        },
      ),
      cursorColor: context.inputTheme.focusedTextDefault,
      cursorHeight: 16,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: WidgetStateTextStyle.resolveWith(
          (states) {
            late final Color textColor;

            if (states.contains(WidgetState.error)) {
              textColor = context.inputTheme.errorTextDefault;
            } else if (states.contains(WidgetState.focused)) {
              textColor = context.inputTheme.focusedOnBrand;
            } else if (states.contains(WidgetState.disabled)) {
              textColor = context.inputTheme.disabledText;
            } else {
              textColor = context.inputTheme.defaultText;
            }

            return context.typography.inputPlaceHolder.copyWith(
              color: textColor,
            );
          },
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) {
            late final Color textColor;

            if (states.contains(WidgetState.error)) {
              textColor = context.inputTheme.errorTextDefault;
            } else if (states.contains(WidgetState.focused)) {
              textColor = context.inputTheme.focusedOnBrand;
            } else {
              textColor = context.inputTheme.defaultText;
            }

            return context.typography.inputLabel.copyWith(
              color: textColor,
            );
          },
        ),
        filled: true,
        fillColor: enabled
            ? context.inputTheme.defaultColor
            : context.inputTheme.disabledColor,
        border: MaterialStateOutlineInputBorder.resolveWith(
          (states) {
            late final Color borderColor;

            if (states.contains(WidgetState.error)) {
              borderColor = context.inputTheme.borderError;
            } else if (states.contains(WidgetState.focused)) {
              borderColor = context.inputTheme.borderFocused;
            } else if (states.contains(WidgetState.disabled)) {
              borderColor = context.inputTheme.borderDisabled;
            } else if (states.contains(WidgetState.hovered)) {
              borderColor = context.inputTheme.borderHover;
            } else {
              borderColor = context.inputTheme.borderDefault;
            }

            return OutlineInputBorder(
              borderRadius: const BorderRadius.all(AppRadius.md),
              borderSide: BorderSide(
                color: borderColor,
              ),
            );
          },
        ),
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        helperText: helperText,
        helperStyle: WidgetStateTextStyle.resolveWith(
          (states) {
            late final Color textColor;

            if (states.contains(WidgetState.error)) {
              textColor = context.inputTheme.errorTextDefault;
            } else if (states.contains(WidgetState.focused)) {
              textColor = context.inputTheme.focusedOnBrand;
            } else if (states.contains(WidgetState.disabled)) {
              textColor = context.inputTheme.disabledText;
            } else {
              textColor = context.inputTheme.defaultText;
            }

            return context.typography.inputHint.copyWith(
              color: textColor,
            );
          },
        ),
        errorText: errorText,
        errorStyle: context.typography.inputHint.copyWith(
          color: context.inputTheme.errorTextDefault,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconConstraints: suffixIconConstraints,
        prefixIconConstraints: prefixIconConstraints,
      ),
    );
  }
}
```
## Extension to get themes with context

To get themes with context, we have created a simple extension class:
```dart
/// An extension on [BuildContext] that provides access to the current theme.
extension ThemeExt on BuildContext {
  /// The current theme.
  ThemeData get theme => Theme.of(this);

  ///the current button theme
  AppButtonTheme get buttonTheme =>
      theme.extension<AppTheme>()!.appButtonTheme as AppButtonTheme;

  /// The current app checkboxTheme.
  AppCheckboxTheme get checkboxTheme =>
      theme.extension<AppTheme>()!.appCheckboxTheme as AppCheckboxTheme;

  /// The current app iconTheme.
  AppIconTheme get iconTheme =>
      theme.extension<AppTheme>()!.appIconTheme as AppIconTheme;

  /// The current app inputTheme.
  AppInputTheme get inputTheme =>
      theme.extension<AppTheme>()!.appInputTheme as AppInputTheme;

  /// The current app radioTheme.
  AppRadioTheme get radioTheme =>
      theme.extension<AppTheme>()!.appRadioTheme as AppRadioTheme;

  /// The current app toggleTheme.
  AppToggleTheme get toggleTheme =>
      theme.extension<AppTheme>()!.appToggleTheme as AppToggleTheme;

  /// The current app typographyTheme.
  AppTypographyTheme get typographyTheme =>
      theme.extension<AppTheme>()!.appTypographyTheme as AppTypographyTheme;

  /// The current app avatarTheme.
  AppAvatarTheme get avatarTheme =>
      theme.extension<AppTheme>()!.appAvatarTheme as AppAvatarTheme;

  /// The current app typography.
  AppTypography get typography =>
      theme.extension<AppTheme>()!.appTypography as AppTypography;

  /// The current app navigationTheme.
  AppNavigationTheme get navigationTheme =>
      theme.extension<AppTheme>()!.appNavigationTheme as AppNavigationTheme;

  /// The current app layoutTheme.
  AppLayoutTheme get layoutTheme =>
      theme.extension<AppTheme>()!.appLayoutTheme as AppLayoutTheme;

  /// The current app badgeTheme.
  AppBadgeTheme get badgeTheme =>
      theme.extension<AppTheme>()!.appBadgeTheme as AppBadgeTheme;

  /// The current app breadcrumbTheme.
  AppBreadCrumbTheme get appBreadCrumbTheme =>
      theme.extension<AppTheme>()!.appBreadCrumbTheme as AppBreadCrumbTheme;

  /// The current app appDropdownTheme.
  AppDropdownTheme get appDropdownTheme =>
      theme.extension<AppTheme>()!.appDropdownTheme as AppDropdownTheme;
}
```
## So… What is AppTheme there?

AppTheme is a simple, immutable class (**ThemeExtension**) that provides all themes to our application.

```dart
/// {@template app_theme}
/// Configuration class which collects all Themes of app together and provides
/// them as a single instance
/// {@endtemplate}
class AppTheme extends ThemeExtension<AppTheme> {
  /// {@macro app_theme}
  const AppTheme({
    required this.appButtonTheme,
    required this.appInputTheme,
  });

  /// {@macro app_theme}
  factory AppTheme.light() {
    return AppTheme(
      appButtonTheme: AppButtonTheme.light(),
      appInputTheme: AppInputTheme.light(),
    );
  }

  /// [AppButtonTheme] instance provides configuration of buttons
  final ThemeExtension<AppButtonTheme> appButtonTheme;

  /// [AppInputTheme] instance provides configuration of [AppTextField]
  final ThemeExtension<AppInputTheme> appInputTheme;


  @override
  ThemeExtension<AppTheme> copyWith({
    ThemeExtension<AppButtonTheme>? appButtonTheme,
    ThemeExtension<AppInputTheme>? appInputTheme,
  }) {
    return AppTheme(
      appButtonTheme: appButtonTheme ?? this.appButtonTheme,
      appInputTheme: appInputTheme ?? this.appInputTheme,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(
    covariant ThemeExtension<AppTheme>? other,
    double t,
  ) {
    if (other is! AppTheme) {
      return this;
    }

    return AppTheme(
      appButtonTheme: appButtonTheme.lerp(other.appButtonTheme, t),
      appInputTheme: appInputTheme.lerp(other.appInputTheme, t),
    );
  }
}
```
## How will we provide our theme for a new project?

It is not a difficult process. If you know about **InheritedWidget**, you can understand this step easily.

Therefore, we created a simple **InheritedWidget** called **ThemeScope** to provide our design system for a new project.
```dart
/// {@template theme_scope}
/// InheritedWidget provides [AppTheme] for app
/// {@endtemplate}
class ThemeScope extends InheritedWidget {
  /// {@macro theme_scope}
  const ThemeScope({
    super.key,
    required Widget child,
    required this.themeMode,
    required this.appTheme,
  }) : super(child: child);

  /// The current theme mode.
  final ThemeMode themeMode;

  /// The current app theme.
  final AppTheme appTheme;

  /// The current theme.
  static ThemeScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(result != null, 'No ThemeScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) => true;
}
```
## ThemeMode handler

For handling the dark, light, and system mode switching process, your can write a simple controller and initializer as the following:

```dart
const _kThemeMode = 'themeMode';

/// {@template theme_scope_widget}
/// A class which handles all theme processes
///
/// initialize() method should be used as app starter in order to use
/// [AppTheme] in the app

/// {@endtemplate}
class ThemeScopeWidget extends StatefulWidget {
  /// {@macro theme_scope_widget}
  const ThemeScopeWidget({
    super.key,
    required this.child,
    required this.preferences,
  });

  /// The child widget
  final Widget child;

  /// The shared preferences
  final SharedPreferences preferences;

  /// Initialize the [ThemeScopeWidget] with the given [child] widget
  static Future<ThemeScopeWidget> initialize(Widget child) async {
    final preferences = await SharedPreferences.getInstance();
    return ThemeScopeWidget(
      preferences: preferences,
      child: child,
    );
  }

  /// In order to use methods of [ThemeScopeWidget] this function
  /// should be called first. Theme change process will handled by
  /// [ThemeScopeWidget] automatically.
  static ThemeScopeWidgetState? of(BuildContext context) {
    return context.findRootAncestorStateOfType<ThemeScopeWidgetState>();
  }

  @override
  State<ThemeScopeWidget> createState() => ThemeScopeWidgetState();
}

/// The state for [ThemeScopeWidget].
class ThemeScopeWidgetState extends State<ThemeScopeWidget> {
  ThemeMode? _themeMode;

  /// Change the theme mode
  Future<void> changeTo(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    try {
      final index = ThemeMode.values.indexOf(themeMode);
      await widget.preferences.setInt(_kThemeMode, index);

      setState(() {
        _themeMode = themeMode;
      });
    } on Exception catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      final themeModeIndex = widget.preferences.getInt(_kThemeMode) ?? 0;
      final themeMode = ThemeMode.values[themeModeIndex];

      _themeMode = themeMode;
    } on Exception catch (_) {
      _themeMode = ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);

    final appTheme = switch (_themeMode!) {
      ThemeMode.light => AppTheme.light(),
      ThemeMode.dark => AppTheme.light(),
      ThemeMode.system =>
        brightness == Brightness.dark ? AppTheme.light() : AppTheme.light(),
    };

    return ThemeScope(
      themeMode: _themeMode!,
      appTheme: appTheme,
      child: widget.child,
    );
  }
}
```
You can call **ThemeScopeWidget.of(context).changeTo** function to change your ThemeMode in anywhere!
## The last step is to initialize your project with our Design System

We wrote this design system implementation as an independent package and used it in different apps.

Firstly, we should initialize our wrapper:

```dart
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   final app = await ThemeScopeWidget.initialize(const MyApp());
   runApp(app);
 }
```
We have another option to provide:
```dart
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   final preferences = await SharedPreferences.getInstance();

   runApp(
     ThemeScopeWidget(
       preferences: preferences,
       child: const MyApp(),
     ),
   );
 }
```
And, in the MaterialApp, it should be registered as an extension:
```dart
final theme = ThemeScope.of(context);

return MaterialApp(
  title: 'Flutter App',
  themeMode: theme.themeMode,
  theme: ThemeData(extensions: [theme.appTheme]),
  darkTheme: ThemeData(extensions: [theme.appTheme]),
  home: const MyHomePage(title: 'Flutter Demo Home Page'),
);
```
There are a few extension methods that allow developers to access any theme, typography, and just a few lines of code.
```dart
context.buttonTheme.linkHover;  
context.checkboxTheme.disabled;  
context.typography.titleSmall;
```
To change the theme of app, just following function should be called:
```dart
final themeScope = ThemeScopeWidget.of(context);  
themeScope.changeTo(ThemeMode.light);
```
## What is about Assets?

In general, assets are the part of the design system. Therefore, we created an independent package that stores and emits PNGs, SVGs, etc, for any project as a package.

 the **assets** package stores fonts, raster, and vector images.

- **rasters** mean PNGs, JPEGs, etc
- **vectors** mean SVGs

**_Why did we divide them in the different package?_**

To optimize SVGs, we have used the new way, for all SVGs in the vectors package will be compiled to optimized version at the build time:
![[Pasted image 20241209132721.png]]
And, we need SSOT (Single Source of Truth) to get our assets:
```dart
/// {@template app_icons}
/// The [AppAssets] class contains all the icons used in the app.
/// {@endtemplate}
abstract class AppAssets {
  /// person icon
  static const person = AssetBytesLoader(
    'vectors/person.svg',
    packageName: 'assets',
  );

  /// left arrow  icon
  static const leftArrow = AssetBytesLoader(
    'vectors/left_icon.svg',
    packageName: 'assets',
  );

  static const sittingSad = 'rasters/sitting_sad.png';
  static const magnifyingGlass = 'rasters/magnifying_glass.png';
}
```
> You can divide raster and vector graphics class too

Keep in mind that, when you use raster graphic in any project as package (you defined **asset** package in pubspec and use it), you should define **package** field:
```dart
Image.asset(AppAssets.sittingSad, package: 'assets')
```
And, if you want to export **font** from other package you should define your fonts inside **lib** folder. For more information, you can check the [**Export fonts from a package**](https://docs.flutter.dev/cookbook/design/package-fonts) article from Flutter documentation.

## Testing your design system as an independent app

For this purpose, we are using [**Widgetbook**](https://docs.widgetbook.io/). It is a huge topic to write about. In order not to prolong the article further, I did not write about this topic in more detail. It has a great documentation, you can check it.

That is it. If you like my article, don’t forget to clap!