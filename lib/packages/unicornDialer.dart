import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class UnicornOrientation {
  static const horizontal = 0;
  static const vertical = 1;
}

class UnicornButton extends FloatingActionButton {
  final FloatingActionButton currentButton;
  final String labelText;
  final double labelFontSize;
  final Color? labelColor;
  final Color? labelBackgroundColor;
  final Color? labelShadowColor;
  final bool labelHasShadow;
  final bool hasLabel;

  UnicornButton(
      {Key? key, required this.currentButton,
        this.labelText = "",
        this.labelFontSize = 14.0,
        this.labelColor,
        this.labelBackgroundColor,
        this.labelShadowColor,
        this.labelHasShadow = true,
        this.hasLabel = false})
      : super(key: key,
        onPressed: () {},
      );

  Widget returnLabel() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: labelHasShadow
                ? [
              BoxShadow(
                color: labelShadowColor == null
                    ? const Color.fromRGBO(204, 204, 204, 1.0)
                    : labelShadowColor!,
                blurRadius: 3.0,
              ),
            ]
                : null,
            color: labelBackgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(3.0)), //color: Colors.white,
        padding: const EdgeInsets.all(9.0),
        child: Text(labelText,
            style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.bold,
                color: labelColor ?? const Color.fromRGBO(119, 119, 119, 1.0))));
  }

  @override
  Widget build(BuildContext context) {
    return currentButton;
  }
}

class UnicornDialer extends StatefulWidget {
  final int orientation;
  final Icon parentButton;
  final Icon? finalButtonIcon;
  final bool hasBackground;
  final Color parentButtonBackground;
  final List<UnicornButton> childButtons;
  final int animationDuration;
  final int mainAnimationDuration;
  final double childPadding;
  final Color backgroundColor;
  final Function? onMainButtonPressed;
  final Object parentHeroTag;
  final bool hasNotch;

  const UnicornDialer(
      {required this.parentButton,
        required this.parentButtonBackground,
        required this.childButtons,
        this.onMainButtonPressed,
        this.orientation = 1,
        this.hasBackground = true,
        this.backgroundColor = Colors.white30,
        this.parentHeroTag = "parent",
        this.finalButtonIcon,
        this.animationDuration = 180,
        this.mainAnimationDuration = 200,
        this.childPadding = 4.0,
        this.hasNotch = false});

  @override
  _UnicornDialer createState() => _UnicornDialer();
}

class _UnicornDialer extends State<UnicornDialer> with TickerProviderStateMixin {
  bool isFirst = true;

  late AnimationController _animationController;
  late AnimationController _parentController;

  bool isOpen = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration));

    _parentController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.mainAnimationDuration));

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    _parentController.dispose();
    super.dispose();
  }

  void mainActionButtonOnPressed() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    _animationController.reverse();

    var hasChildButtons = widget.childButtons.isNotEmpty;

    if(isFirst) {
      isFirst = false;
      if (!_parentController.isAnimating) {
        if (_parentController.isCompleted) {
          _parentController.forward().then((s) {
            _parentController.reverse().then((e) {
              _parentController.forward();
            });
          });
        }
        if (_parentController.isDismissed) {
          _parentController.reverse().then((s) {
            _parentController.forward();
          });
        }
      }
    }

    var mainFAB = AnimatedBuilder(
        animation: _parentController,
        builder: (BuildContext context, Widget? child) {
          return Transform(
              transform: Matrix4.diagonal3(vector.Vector3(
                  _parentController.value,
                  _parentController.value,
                  _parentController.value)),
              alignment: FractionalOffset.center,
              child: FloatingActionButton(
                  isExtended: false,
                  heroTag: widget.parentHeroTag,
                  backgroundColor: widget.parentButtonBackground,
                  onPressed: () {
                    mainActionButtonOnPressed();
                    if (widget.onMainButtonPressed != null) {
                      widget.onMainButtonPressed!();
                    }
                  },
                  child: !hasChildButtons
                      ? widget.parentButton
                      : AnimatedBuilder(
                      animation: _animationController,
                      builder: (BuildContext context, Widget? child) {
                        return Transform(
                          transform: Matrix4.rotationZ(
                              _animationController.value * 0.8),
                          alignment: FractionalOffset.center,
                          child:
                          Icon(_animationController.isDismissed
                              ? widget.parentButton.icon
                              : widget.finalButtonIcon == null
                              ? Icons.close
                              : widget.finalButtonIcon!.icon),
                        );
                      })));
        });

    if (hasChildButtons) {
      var mainFloatingButton = AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
                angle: _animationController.value * 0.8, child: mainFAB);
          });

      List<Widget> childButtonsList = widget.childButtons.isEmpty
          ? []
          : List.generate(widget.childButtons.length, (index) {
        double intervalValue = index == 0
            ? 0.9
            : ((widget.childButtons.length - index) /
            widget.childButtons.length) -
            0.2;

        intervalValue =
        intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

        FloatingActionButton childFAB = FloatingActionButton(
            onPressed: () {
              if (widget.childButtons[index].currentButton.onPressed !=
                  null) {
                widget.childButtons[index].currentButton.onPressed!();
              }

              _animationController.reverse();
            },
            heroTag: widget.childButtons[index].currentButton.heroTag,
            backgroundColor:
            widget.childButtons[index].currentButton.backgroundColor,
            mini: widget.childButtons[index].currentButton.mini,
            tooltip: widget.childButtons[index].currentButton.tooltip,
            key: widget.childButtons[index].currentButton.key,
            elevation: widget.childButtons[index].currentButton.elevation,
            foregroundColor:
            widget.childButtons[index].currentButton.foregroundColor,
            highlightElevation: widget
                .childButtons[index].currentButton.highlightElevation,
            isExtended:
            widget.childButtons[index].currentButton.isExtended,
            shape: widget.childButtons[index].currentButton.shape,
            child: widget.childButtons[index].currentButton.child);

        return Positioned(
          right: widget.orientation == UnicornOrientation.vertical
              ? widget.childButtons[index].currentButton.mini
              ? 4.0
              : 0.0
              : ((widget.childButtons.length - index) * 55.0) + 15,
          bottom: widget.orientation == UnicornOrientation.vertical
              ? ((widget.childButtons.length - index) * 55.0) + 15
              : 8.0,
          child: Row(children: [
            ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve:
                  Interval(intervalValue, 1.0, curve: Curves.linear),
                ),
                alignment: FractionalOffset.center,
                child: (!widget.childButtons[index].hasLabel) ||
                    widget.orientation ==
                        UnicornOrientation.horizontal
                    ? Container()
                    : Container(
                    padding:
                    EdgeInsets.only(right: widget.childPadding),
                    child: widget.childButtons[index].returnLabel())),
            ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve:
                  Interval(intervalValue, 1.0, curve: Curves.linear),
                ),
                alignment: FractionalOffset.center,
                child: childFAB)
          ]),
        );
      });

      var unicornDialWidget = Container(
          margin: widget.hasNotch ? const EdgeInsets.only(bottom: 15.0) : null,
          height: double.infinity,
          child: Stack(
            //fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              //overflow: Overflow.visible,
              clipBehavior: Clip.none,
              children: childButtonsList.toList()
                ..add(Positioned(
                    right: null, bottom: null, child: mainFloatingButton))));

      var modal = ScaleTransition(
          scale: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(1.0, 1.0, curve: Curves.linear),
          ),
          alignment: FractionalOffset.center,
          child: GestureDetector(
              onTap: mainActionButtonOnPressed,
              child: Container(
                color: widget.backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )));

      return widget.hasBackground
          ? Stack(
          alignment: Alignment.topCenter,
          //overflow: Overflow.visible,
          clipBehavior: Clip.none,
          children: [
            Positioned(right: -16.0, bottom: -16.0, child: modal),
            unicornDialWidget
          ])
          : unicornDialWidget;
    }

    return mainFAB;
  }
}
