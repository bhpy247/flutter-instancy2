import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenerateTextDialog extends StatefulWidget {
  const GenerateTextDialog({super.key});

  @override
  State<GenerateTextDialog> createState() => _GenerateTextDialogState();
}

class _GenerateTextDialogState extends State<GenerateTextDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 20),
              const Expanded(
                child: Text(
                  "Generate Text",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    FontAwesomeIcons.xmark,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
            child: Row(
              children: [
                Expanded(
                  child: getCommonTextContainer(
                    text: "Internet \nSearch",
                    fontSize: 12,
                    backgroundColor: Colors.grey[100],
                    onTap: () {
                      Navigator.pop(context, 1);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: getCommonTextContainer(
                    text: "Generate \with AI",
                    fontSize: 12,
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    onTap: () {
                      Navigator.pop(context, 2);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getCommonTextContainer({
    required String text,
    Function()? onTap,
    double fontSize = 16,
    Color? backgroundColor,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 50),
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(1, 3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
