import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommonRatingBarWidget extends StatelessWidget {
  final double rating;
  final Color? starColor;
  final Color? unselectedStarColor;
  final double maxStarCount;
  final double starSize;

  const CommonRatingBarWidget({
    Key? key,
    required this.rating,
    this.starColor,
    this.unselectedStarColor,
    this.maxStarCount = 5,
    this.starSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: starColor ?? Colors.black,
      ),
      itemCount: maxStarCount.toInt(),
      unratedColor: unselectedStarColor ?? const Color(0xffCBCBD4),
      itemSize: starSize,
      direction: Axis.horizontal,
    );
  }
}
