import 'package:flutter/material.dart';
import '../models/enum_type.dart';
import '../widgets/modal_barrier_layout.dart';
import '../widgets/overlay_route_layout.dart';

class FlexibleDropdown extends StatefulWidget {
  /// [Required]
  ///
  /// [child] is the widget used for this button and the button will utilize an [InkWell] for taps.
  final Widget child;

  /// [Required]
  ///
  /// [overlayChild] is the widget which displayed after the user taps on [child]
  final Widget overlayChild;

  /// [rootNavigator] using in Navigator. Is Root???
  final bool rootNavigator;

  /// Whether to prefer going to the left or to the right.
  ///
  /// If this property is null, default is [TextDirection.rtl]
  final TextDirection textDirection;

  /// Animation type of flexible dropdown
  ///
  final AnimationType? animationType;

  /// The alignment of the origin of the coordinate system
  ///
  /// For example, to set the origin of the scale to bottom middle, you can use
  /// an alignment of (0.0, 1.0).
  final Alignment? animationAlignment;

  /// The color to use for the modal barrier.
  ///
  /// If this property is null, the barrier will be Colors.black38 with opacity 0.2.
  final Color? barrierColor;

  /// If provided, the shape used for the modal barrier.
  ///
  /// If this property is null, then [BarrierShape.normal] is used.
  final BarrierShape? barrierShape;

  /// The offset is applied relative to the initial position
  /// set by the [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  ///
  final Offset offset;

  /// The duration the transition going forwards and reverse.
  ///
  /// When not set, the duration defaults to 350ms.
  final Duration? duration;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the popup menu is closed.
  final VoidCallback? onClosed;

  /// The border radius of the containing rectangle. This is effective only if
  /// [highlightShape] is [BoxShape.rectangle].
  ///
  /// If this is null, it is interpreted as [BorderRadius.zero].
  final BorderRadius? borderRadius;

  /// The duration of the animation that animates the hover effect.
  ///
  /// The default is 50ms.
  final Duration? hoverDuration;

  /// The splash color of the ink response. If this property is null then the
  /// splash color of the theme, [ThemeData.splashColor], will be used.
  ///
  /// See also:
  ///
  ///  * [splashFactory], which defines the appearance of the splash.
  ///  * [radius], the (maximum) size of the ink splash.
  ///  * [highlightColor], the color of the highlight.
  final Color? splashColor;

  final Color? highlightColor;

  /// slice position
  final Offset? beginPosition;
  final Offset? endPosition;

  const FlexibleDropdown({
    Key? key,
    required this.child,
    required this.overlayChild,
    this.rootNavigator = true,
    this.textDirection = TextDirection.rtl,
    this.offset = Offset.zero,
    this.animationType,
    this.animationAlignment,
    this.duration,
    this.barrierColor,
    this.barrierShape,
    this.onOpened,
    this.onClosed,
    this.borderRadius,
    this.hoverDuration,
    this.splashColor,
    this.highlightColor,
    this.beginPosition,
    this.endPosition,
  }) : super(key: key);

  @override
  State<FlexibleDropdown> createState() => _FlexibleDropdownState();
}

class _FlexibleDropdownState extends State<FlexibleDropdown> {
  final FocusNode _flexibleFocusMode = FocusNode();

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _flexibleFocusMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showOverlayDialog,
      canRequestFocus: true,
      focusNode: _flexibleFocusMode,
      borderRadius: widget.borderRadius,
      hoverDuration: widget.hoverDuration,
      splashColor: widget.splashColor,
      highlightColor: widget.highlightColor,
      child: widget.child,
    );
  }

  /// show the overlay dialog of the button
  void _showOverlayDialog() {
    _flexibleFocusMode.requestFocus();

    // final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    // final PopupMenuPosition popupMenuPosition = popupMenuTheme.position ?? PopupMenuPosition.over;
    final Offset offset = Offset(0.0, button.size.height) + widget.offset;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    widget.onOpened?.call();

    /// Show flexible dropdown
    final NavigatorState navigator = Navigator.of(context, rootNavigator: widget.rootNavigator);
    navigator.push(
      FlexibleDropdownRoute(
        child: widget.overlayChild,
        position: position,
        textDirection: widget.textDirection,
        barrierShape: widget.barrierShape,
        barrierBgColor: widget.barrierColor,
        duration: widget.duration,
        animationType: widget.animationType ?? AnimationType.scale,
        animationAlignment: widget.animationAlignment ?? Alignment.topCenter,
        beginPosition: widget.beginPosition,
        endPosition: widget.endPosition,
      ),
    ).then((value) {
      if (!mounted) return;
      _flexibleFocusMode.unfocus();
      widget.onClosed?.call();
    });
  }
}

class FlexibleDropdownRoute<T> extends PopupRoute<T> {
  final Widget child;
  final RelativeRect position;
  final TextDirection textDirection;
  final Color? barrierBgColor;
  final BarrierShape? barrierShape;
  final Duration? duration;
  final AnimationType animationType;
  final Alignment animationAlignment;
  final Offset? beginPosition;
  final Offset? endPosition;

  FlexibleDropdownRoute({
    required this.child,
    required this.position,
    this.barrierBgColor,
    this.barrierShape,
    this.duration,
    this.textDirection = TextDirection.rtl,
    required this.animationType,
    required this.animationAlignment,
    this.beginPosition,
    this.endPosition,
  });

  @override
  Duration get transitionDuration =>
      duration ?? const Duration(milliseconds: 350);

  @override
  Duration get reverseTransitionDuration =>
      duration ?? const Duration(milliseconds: 350);

  @override
  Color? get barrierColor => null;

  /// This allows the popup to be dismissed by tapping the scrim or by pressing
  /// the escape key on the keyboard.
  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Flexible Dropdown';

  @override
  Widget buildModalBarrier() => ModalBarrierLayout(
    position: position,
    barrierColor: barrierBgColor,
    barrierShape: barrierShape,
  );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          final mediaQuery = MediaQuery.of(context);
          return CustomSingleChildLayout(
            delegate: OverlayRouteLayout(
              position,
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
              textDirection,
            ),
            child: AnimatedBuilder(
              animation: animation,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (mediaQuery.size.height - position.top).abs(),
                  ),
                  child: child,
                ),
              ),
              builder: (context, child) {
                switch (animationType) {
                  case AnimationType.scale:
                    return ScaleTransition(
                      scale: animation,
                      alignment: animationAlignment,
                      child: child,
                    );
                  case AnimationType.scaleY:
                    return Transform.scale(
                      alignment: animationAlignment,
                      scaleY: animation.value,
                      child: child,
                    );
                  case AnimationType.scaleX:
                    return Transform.scale(
                      alignment: animationAlignment,
                      scaleX: animation.value,
                      child: child,
                    );
                  case AnimationType.size:
                    return SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: 0.0,
                      axis: Axis.vertical,
                      child: child,
                    );
                  case AnimationType.slide:
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: beginPosition ?? const Offset(0, -1.0),
                        end: endPosition ?? Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  case AnimationType.rotate:
                    return RotationTransition(
                      turns: animation,
                      alignment: animationAlignment,
                      child: child,
                    );
                  case AnimationType.fade:
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  case AnimationType.none:
                    return child ?? const SizedBox();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}
