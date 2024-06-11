import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../backend/app_theme/style.dart';

class CommonBorderDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final IconData trailingIcon;
  final String? hintText;
  final bool isExpanded, isDense;
  final Color? borderColor;

  const CommonBorderDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.borderColor,
    this.isExpanded = false,
    this.isDense = true,
    this.trailingIcon = Icons.keyboard_arrow_down_outlined,
  });

  @override
  _CommonBorderDropdownState<T> createState() => _CommonBorderDropdownState<T>();
}

class _CommonBorderDropdownState<T> extends State<CommonBorderDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor ?? Styles.textFieldBorderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          value: widget.value,
          isExpanded: widget.isExpanded,
          isDense: widget.isDense,
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 14,
          ),
          hint: widget.hintText == null
              ? null
              : Text(
                  widget.hintText ?? "",
                ),
          items: widget.items.map<DropdownMenuItem<T>>(
            (T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
