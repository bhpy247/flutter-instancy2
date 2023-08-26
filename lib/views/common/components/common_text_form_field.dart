import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    Key? key,
    this.controller,
    this.hintText = "",
    this.borderColor = Colors.grey,
    this.borderRadius = 5,
    this.borderWidth = 0.5,
    this.contentPadding,
    this.isOutlineInputBorder = false,
    this.isSuffix = false,
    this.obscureText = false,
    this.validator,
    this.prefixWidget,
    this.suffixWidget,
    this.boxConstraints,
    this.focusedBorderColor,
    this.enabled = true,
    this.autoFocus = false,
    this.onChanged,
    this.onSubmitted,
    this.minLines,
    this.maxLines = 1,
    this.textStyle,
    this.textInputAction,
    this.inputFormatters,
    this.isFilled = false,
    this.fillColor,
    this.hintStyle
  }) : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final bool isOutlineInputBorder,isSuffix, obscureText, isFilled, autoFocus;
  final double borderRadius, borderWidth;
  final Color borderColor;
  final Color? focusedBorderColor, fillColor;
  final Widget? suffixWidget, prefixWidget;
  final String? Function(String?)? validator;
  final EdgeInsets? contentPadding;
  final BoxConstraints ?boxConstraints;
  final bool enabled;
  final void Function(String)? onChanged, onSubmitted;
  final int? minLines, maxLines;
  final TextStyle? textStyle, hintStyle;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      obscureText: obscureText,
      style: textStyle ?? themeData.textTheme.titleSmall,
      validator: validator,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: fillColor,
        prefixIcon: prefixWidget,
        prefixIconConstraints: boxConstraints,
        border: inputBorder(borderColor: borderColor),
        enabledBorder: inputBorder(borderColor: borderColor),
        focusedBorder: inputBorder(borderColor: focusedBorderColor ?? themeData.primaryColor),
        hintText: hintText,
        hintStyle:hintStyle ?? themeData.inputDecorationTheme.hintStyle?.copyWith(fontSize: 14),
        // labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        suffixIcon: suffixWidget,
        enabled: enabled,
        contentPadding: contentPadding,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  InputBorder inputBorder({required Color borderColor}) {
    if(isOutlineInputBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      );
    }
    else {
      return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      );
    }
  }
}

class CommonTextFormFieldWithLabel extends StatelessWidget {
  const CommonTextFormFieldWithLabel({
    Key? key,
    this.controller,
    this.enabled = true,
    this.labelText,
    this.label,
    this.borderColor = Colors.grey,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.focusColor,
    this.borderRadius = 5,
    this.borderWidth = 0.5,
    this.contentPadding,
    this.isOutlineInputBorder = false,
    this.isSuffix = false,
    this.obscureText = false,
    this.validator,
    this.maxLength = 50,
    this.suffixWidget,
    this.prefixWidget,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.minLines,
    this.maxLines = 1,
    this.errorMaxLines = 2,
    this.onTap,
    this.floatingLabelColor,
    this.isFilled = false,
    this.fillColor
  }) : super(key: key);

  final TextEditingController? controller;
  final String? labelText;
  final Widget? label;
  final bool isOutlineInputBorder,isSuffix, obscureText, enabled, isFilled;
  final double borderRadius, borderWidth;
  final int maxLength;
  final Color? borderColor, enabledBorderColor, disabledBorderColor, focusColor, floatingLabelColor, fillColor;
  final Widget? suffixWidget, prefixWidget;
  final String? Function(String?)? validator;
  final EdgeInsets? contentPadding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged, onSubmitted;
  final FocusNode? focusNode;
  final int? minLines, maxLines, errorMaxLines;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return TextFormField(
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      // cursorHeight: 0,
      // cursorWidth: 0,

      enabled: enabled,
      focusNode: focusNode,
      controller: controller,
      style: themeData.textTheme.titleSmall,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      // textAlignVertical: TextAlignVertical.top,

      decoration: InputDecoration(

        filled: isFilled,
        fillColor: fillColor,
        labelStyle: TextStyle(color: floatingLabelColor, fontSize: 13,letterSpacing: 0.4),
        // floatingLabelBehavior: FloatingLabelBehavior.auto,
        // floatingLabelStyle: TextStyle(color: floatingLabelColor, fontSize: 15),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        border: inputBorder(borderColor ?? Colors.grey),
        errorMaxLines: errorMaxLines,
        enabledBorder: inputBorder(enabledBorderColor ?? themeData.inputDecorationTheme.border?.borderSide.color ?? Colors.black),
        disabledBorder: inputBorder(disabledBorderColor ?? Colors.grey),
        focusedBorder: inputBorder(focusColor ?? Theme.of(context).primaryColor),
        labelText: labelText,
        label: label,
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        prefixIcon: prefixWidget,
        // labelStyle: const TextStyle(color: Colors.grey),
        // labelStyle: themeData.inputDecorationTheme.labelStyle?.copyWith(fontSize: 14),
        suffixIcon: suffixWidget,
        contentPadding: contentPadding,
      ),
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  InputBorder inputBorder(Color borderColor) {
    if(isOutlineInputBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      );
    }
    else {
      return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      );
    }
  }
}
