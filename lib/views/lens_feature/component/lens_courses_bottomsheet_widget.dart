import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';

import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';

class LensCoursesBottomsheetWidget extends StatefulWidget {
  final List<CourseDTOModel> contents;
  final bool isLoadingContents;
  final DraggableScrollableController? scrollController;
  final Widget Function(CourseDTOModel model)? contentBuilder;

  const LensCoursesBottomsheetWidget({
    super.key,
    required this.contents,
    this.isLoadingContents = false,
    this.scrollController,
    this.contentBuilder,
  });

  @override
  State<LensCoursesBottomsheetWidget> createState() => _LensCoursesBottomsheetWidgetState();
}

class _LensCoursesBottomsheetWidgetState extends State<LensCoursesBottomsheetWidget> {
  late DraggableScrollableController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = widget.scrollController ?? DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    MyPrint.printOnConsole("contents:${widget.contents.length}");
    MyPrint.printOnConsole("isLoadingContents:${widget.isLoadingContents}");

    if (widget.isLoadingContents) return const SizedBox();

    return SafeArea(
      child: DraggableScrollableSheet(
        controller: widget.scrollController ?? scrollController,
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.05,
        maxChildSize: 1,
        builder: (BuildContext context, ScrollController controller) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                // sigmaX: 20.0,
                // sigmaY: 20.0,
                sigmaX: 0,
                sigmaY: 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: themeData.colorScheme.onPrimary,
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      const BottomSheetDragger(),
                      if (widget.contents.isEmpty) ...[
                        const SizedBox(height: 50),
                        Text(
                          "No Content Found",
                          style: themeData.textTheme.bodyMedium,
                        ),
                      ] else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          itemCount: widget.contents.length,
                          itemBuilder: (BuildContext context, int index) {
                            CourseDTOModel model = widget.contents[index];

                            if (widget.contentBuilder != null) {
                              return widget.contentBuilder!(model);
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
