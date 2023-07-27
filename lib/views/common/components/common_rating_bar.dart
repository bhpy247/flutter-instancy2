import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommonRatingBar extends StatelessWidget {
  final double rating;
  final int maxStar;
  final Color? color, unratedColor;
  final double starSize;

  const CommonRatingBar({
    Key? key,
    required this.rating,
    this.maxStar = 5,
    this.color,
    this.unratedColor,
    this.starSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: color ?? Colors.black,
      ),
      itemCount: maxStar,
      unratedColor: unratedColor ?? const Color(0xffCBCBD4),
      itemSize: starSize,
      direction: Axis.horizontal,
    );
  }
}
