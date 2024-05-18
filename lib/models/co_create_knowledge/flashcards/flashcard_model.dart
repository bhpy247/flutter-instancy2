import 'dart:typed_data';

import 'package:flutter_instancy_2/packages/flipcard/flip_card_controller.dart';

class FlashcardModel {
  String question = "";
  String answer = "";
  String imageUrl = '';
  String assetImagePath = '';
  Uint8List? imageBytes;
  FlipCardController controller = FlipCardController();

  FlashcardModel({
    this.question = "",
    this.answer = "",
    this.imageUrl = "",
    this.assetImagePath = "",
    this.imageBytes,
    FlipCardController? controller,
  }) {
    this.controller = controller ?? FlipCardController();
  }
}
