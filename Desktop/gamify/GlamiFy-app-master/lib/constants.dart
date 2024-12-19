import 'package:flutter/material.dart';

// Bootstrap Colors
const kPrimaryColor = Color(0xFF0e1d42); // Bootstrap Primary Blue
const kSecondaryColor = Color(0xFFED1B53);
const kThirdColor = Color(0xFFFCDDE3);
const kSuccessColor = Color(0xFF198754); // Bootstrap Success Green
const kDangerColor = Color(0xFFDC3545); // Bootstrap Danger Red
const kWarningColor = Color(0xFFFFC107); // Bootstrap Warning Yellow
const kInfoColor = Color(0xFF0DCAF0); // Bootstrap Info Cyan
const kLightColor = Color(0xFFF8F9FA); // Bootstrap Light
const kDarkColor = Color(0xFF212529); // Bootstrap Dark

// Background Colors
const kBackgroundColor = Color(0xFFFFFFFF); // White
const kSurfaceColor = Color(0xFFFFFFFF); // White
const kSurfaceVariantColor = Color(0xFFF8F9FA); // Bootstrap Light Gray

// Text Colors
const kTextColor = Color(0xFF212529); // Bootstrap Dark
const kTextSecondaryColor = Color(0xFF6C757D); // Bootstrap Secondary
const kTextLightColor = Color(0xFFFFFFFF); // White
const kTextMutedColor = Color(0xFF6C757D); // Bootstrap Muted Text

// Bootstrap Spacing (in pixels)
const kSpacing0 = 0.0;
const kSpacing1 = 4.0;
const kSpacing2 = 8.0;
const kSpacing3 = 16.0;
const kSpacing4 = 24.0;
const kSpacing5 = 48.0;

// Bootstrap Border Radius
const kBorderRadiusSm = 4.0;
const kBorderRadius = 6.0;
const kBorderRadiusLg = 8.0;
const kBorderRadiusXl = 12.0;
const kBorderRadiusPill = 50.0;

// Bootstrap Typography Scale
const kFontSizeBase = 16.0;
const kFontSizeSm = 14.0;
const kFontSizeLg = 18.0;
const kH1Size = 40.0;
const kH2Size = 32.0;
const kH3Size = 28.0;
const kH4Size = 24.0;
const kH5Size = 20.0;
const kH6Size = 16.0;

// Bootstrap-like Shadows
final kShadowSm = BoxShadow(
  color: Colors.black.withOpacity(0.075),
  blurRadius: 4,
  offset: const Offset(0, 1),
);

final kShadow = BoxShadow(
  color: Colors.black.withOpacity(0.15),
  blurRadius: 8,
  offset: const Offset(0, 3),
);

final kShadowLg = BoxShadow(
  color: Colors.black.withOpacity(0.175),
  blurRadius: 12,
  offset: const Offset(0, 5),
);

// Bootstrap-like Button Styles
final kButtonPrimaryStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.disabled)) {
      return kPrimaryColor.withOpacity(0.65);
    }
    if (states.contains(WidgetState.pressed)) return const Color(0xFF0a58ca);
    return kPrimaryColor;
  }),
  foregroundColor: WidgetStateProperty.all(kTextLightColor),
  padding: WidgetStateProperty.all(
    const EdgeInsets.symmetric(horizontal: kSpacing3, vertical: kSpacing2),
  ),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
  ),
);

// Updated Colors
const kPrimaryLightColor =
Color(0xFFBBDEFB); // Light blue for background or light elements
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF64B5F6),
    Color(0xFF2196F3)
  ], // Gradient from lighter blue to primary blue
);

const kAnimationDuration = Duration(milliseconds: 200);

// Updated Text Style
const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black, // Headings will remain black for readability
  height: 1.5,
);

const bodyTextStyle = TextStyle(
  fontSize: 16,
  color: kTextColor,
);

const buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white, // Assuming buttons will have a white text color
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error messages (unchanged)
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

// Updated OTP Input Decoration for Blue Theme
final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder().copyWith(
    borderSide:
    const BorderSide(color: kPrimaryColor), // Blue border when focused
  ),
  enabledBorder: outlineInputBorder(),
);

// Updated OutlineInputBorder with softer corners and blue colors
OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor), // Default black border
  );
}