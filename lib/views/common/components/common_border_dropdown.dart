import 'package:flutter/material.dart';

import '../../../backend/app_theme/style.dart';

class CommonBorderDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final IconData trailingIcon;
  final String? hintText;
  final bool isExpanded;
  final Color? borderColor;

  const CommonBorderDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.borderColor,
    this.isExpanded = false,
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
        child: DropdownButton<T>(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
          value: widget.value,
          isExpanded: widget.isExpanded,
          isDense: true,
          icon: Icon(widget.trailingIcon),
          onChanged: widget.onChanged,
          style: TextStyle(
            fontSize: 14,
          ),
          hint: widget.hintText == null
              ? null
              : Text(
                  widget.hintText ?? "",
                ),
          items: widget.items.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$value',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
