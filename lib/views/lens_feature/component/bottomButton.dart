import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onTap;

  const BottomButton({
    super.key,
    this.text = "",
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
        decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white38,
                      Colors.black38,
                    ],
                  )
                : null,
            border: Border.all(color: isSelected ? Colors.white12 : Colors.transparent, width: 3),
            borderRadius: BorderRadius.circular(40)),
        child: Center(
          child: Text(
            text,
            style: themeData.textTheme.labelMedium?.copyWith(
              color: themeData.colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
