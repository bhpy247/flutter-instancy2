import 'package:flutter/material.dart';

class HeaderWithSeeAllWidget extends StatelessWidget {
  final String title, seeAllText;
  final Widget child;
  final bool isSeeAll;
  final Function()? onSeeAllTap;

  const HeaderWithSeeAllWidget({
    Key? key,
    required this.title,
    this.seeAllText = "See All",
    required this.child,
    this.isSeeAll = true,
    this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: themeData.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if(onSeeAllTap != null) {
                    onSeeAllTap!();
                  }
                },
                child: Text(
                  seeAllText,
                  style: themeData.textTheme.labelMedium?.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(child: child)
        ],
      ),
    );
  }
}
