import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

Color mainColor = kPrimaryColor;

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorLightTheme),
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kPrimaryColor
    )
  );
}

ThemeData darkThemeData(BuildContext context) {
  // Bydefault flutter provie us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);


// ThemeData darkTheme() => ThemeData(
//   primarySwatch: Constants.mainColor,
//     fontFamily: "Lato",
//     textTheme: TextTheme(
//         bodyText1: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.0)),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Constants.mainColor,
//         backgroundColor: Color.fromRGBO(19, 46, 70, 1),
//         unselectedItemColor: Colors.grey),
//     scaffoldBackgroundColor: Color.fromRGBO(19, 46, 70, 1),
//     appBarTheme: const AppBarTheme(
//         actionsIconTheme: IconThemeData(color: Colors.white),
//         color: Color.fromRGBO(19, 46, 70, 1),
//         titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0),
//         elevation: 0.0,
//         centerTitle: true));
//
// ThemeData lightTheme() => ThemeData(
//   primarySwatch: Constants.mainColor,
//     fontFamily: "Lato",
//     textTheme: TextTheme(
//         bodyText1: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0)),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Constants.mainColor,
//         backgroundColor: Colors.white,
//         unselectedItemColor: Colors.grey),
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: const AppBarTheme(
//         actionsIconTheme: IconThemeData(color: Colors.black),
//         color: Colors.white,
//         titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0),
//         elevation: 0.0,
//         centerTitle: true));

navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => widget),
);

navigateToAndKeep(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => widget),
  (Route<dynamic> route) => false
);

Widget defaultFormField({
  required TextEditingController controller,
  required IconData prefix,
  required String label,
  required TextInputType keyboardType,
  required FormFieldValidator<String> validator,
  VoidCallback? onTap,
  bool isPassword = false,
  VoidCallback? onSuffixTap,
  IconData? suffixIcon
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          onPressed: onSuffixTap,
          icon: Icon(suffixIcon),
        ),
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      obscureText: isPassword,
    );

Widget defaultButton({
  double width = double.infinity,
  required Color background,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

showToast({
  required String message,
  required Color color
}) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0
);