import 'package:flutter/material.dart';

class ProfileConfigDataUIControlModel {
  String displayText, value;

  TextInputType? keyboardType;
  bool isEmail, isPassword, isPassVisible, isConfPassVisible;
  TextEditingController? textEditingController, confirmPasswordTextEditingController;
  String? Function(String?)? validator, confirmPasswordValidator;

  bool isRequired;

  ProfileConfigDataUIControlModel({
    this.displayText = "",
    this.value = "",
    this.keyboardType,
    this.isEmail = false,
    this.isPassword = false,
    this.isPassVisible = false,
    this.isConfPassVisible = false,
    this.textEditingController,
    this.confirmPasswordTextEditingController,
    this.isRequired = false,
    this.validator,
    this.confirmPasswordValidator,
  });
}