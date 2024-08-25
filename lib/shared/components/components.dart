import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget myDivider() => Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.grey[300],
        height: 0.5,
        width: double.infinity,
      ),
    );

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

void navigateFrom(context) => Navigator.pop(context);

Widget myButton({
  required String label,
  required Function onSubmitted,
  required Color buttonColor,
  required Color textColor,
  bool? isUpperCase,
  double? shadow,
  double? hoverShadow,
  double? disabledShadow,
  double? focusShadow,
  double? highlightShadow,
  double radius = 5,
  double width = double.infinity,
  double height = 50,
  double labelSize = 12,
}) =>
    MaterialButton(
      onPressed: () {
        onSubmitted();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      height: height,
      minWidth: width,
      color: buttonColor,
      elevation: shadow,
      hoverElevation: hoverShadow,
      disabledElevation: disabledShadow,
      focusElevation: focusShadow,
      highlightElevation: highlightShadow,
      child: Text(
        isUpperCase == true ? label.toUpperCase() : label,
        style: TextStyle(
          color: textColor,
          fontSize: labelSize,
        ),
      ),
    );

myTextButton({
  required Function onPressed,
  required String label,
}) =>
    TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(label),
    );

Widget myNormalTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required InputBorder borderType,
  String? counterText,
  TextStyle? errorStyle,
  Color? cursorColor,
  Color? errorColor,
  Color? focusColor,
  int? maxLength,
  int? maxLines,
  String? label,
  IconData? prefix,
  Function? validate, // Make it nullable
  void Function()? onSubmitted,
  bool isPassword = false,
  double width = double.infinity,
  double? height,
  IconData? suffix,
  VoidCallback? suffixOnPressed,
}) =>
    SizedBox(
        width: double.infinity,
        child: TextFormField(
          cursorColor: cursorColor,
          maxLines: maxLines,
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          controller: controller,
          keyboardType: type,
          obscureText: isPassword,
          validator: validate != null
              ? (value) => validate(value)
              : null, // Conditionally set the validator
          onFieldSubmitted: (String value) {
            onSubmitted?.call();
          },
          decoration: InputDecoration(
            counterText: counterText,
            focusColor: focusColor,
            errorStyle: errorStyle,
            labelText: label,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            floatingLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            border: borderType,
            prefixIcon: prefix != null ? Icon(prefix) : null,
            suffixIcon: suffix != null
                ? IconButton(
                    icon: Icon(suffix),
                    onPressed: suffixOnPressed,
                  )
                : null,
          ),
        ));

void myPickTextFormField() {}

Widget mySearchFormField({
  required TextEditingController controller,
  required TextInputType type,
  required InputBorder borderType,
  required Function onChanged,
  Color? labelColor,
  TextStyle? errorStyle,
  Color? cursorColor,
  String? label,
  IconData? prefix,
  double width = double.infinity,
  double? height,
}) =>
    SizedBox(
        width: double.infinity,
        child: TextFormField(
          cursorColor: cursorColor,
          controller: controller,
          keyboardType: type,
          onChanged: onChanged(),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            floatingLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            border: borderType,
            prefixIcon: prefix != null ? Icon(prefix) : null,
          ),
        ));

/*void showToast({
  required String message,
  required ToastStates state,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) => Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastColor(state),
  textColor: textColor,
  fontSize: fontSize,
);

enum ToastStates {success, error, warning}

Color chooseToastColor(ToastStates state) {

  Color color;

  switch(state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }

  return color;
}*/

Widget noElevationFloatingActionButton({
  required Color color,
  required Function onPressed,
  required IconData icon,
}) =>
    FloatingActionButton(
      backgroundColor: color,
      elevation: 0.0,
      highlightElevation: 0.0,
      focusElevation: 0.0,
      disabledElevation: 0.0,
      hoverElevation: 0.0,
      onPressed: onPressed(),
      child: Icon(icon),
    );

Widget myCircularProgressIndicator({
  required bool isCenter,
  required Color color,
  double stroke = 1.5,
  double height = 30,
  double width = 30,
}) =>
    ConditionalBuilder(
      condition: isCenter == true,
      builder: (context) => Center(
        child: SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator(
            strokeWidth: stroke,
            color: color,
          ),
        ),
      ),
      fallback: (context) => SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          strokeWidth: stroke,
          color: color,
        ),
      ),
    );
