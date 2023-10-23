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

  /// Whether to prefer going to the left or to the right.
  ///
  /// If this property is null, default is [TextDirection.rtl]
  final TextDirection textDirection;

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

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the popup menu is closed.
  final VoidCallback? onClosed;

  const FlexibleDropdown({
    Key? key,
    required this.child,
    required this.overlayChild,
    this.textDirection = TextDirection.rtl,
    this.offset = Offset.zero,
    this.barrierColor,
    this.barrierShape,
    this.onOpened,
    this.onClosed,
  }) : super(key: key);

  @override
  State<FlexibleDropdown> createState() => _FlexibleDropdownState();
}

class _FlexibleDropdownState extends State<FlexibleDropdown> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showOverlayDialog,
      // canRequestFocus: _canRequestFocus,
      child: widget.child,
    );
  }

  /// show the overlay dialog of the button
  void _showOverlayDialog() {
    // final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    // final PopupMenuPosition popupMenuPosition = popupMenuTheme.position ?? PopupMenuPosition.over;
    final Offset offset = Offset(0.0, button.size.height) + widget.offset;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    widget.onOpened?.call();

    /// Show flexible dropdown
    final NavigatorState navigator =
        Navigator.of(context, rootNavigator: false);
    navigator
        .push(
      FlexibleDropdownRoute(
        child: widget.overlayChild,
        position: position,
        textDirection: widget.textDirection,
        barrierShape: widget.barrierShape,
        barrierBgColor: widget.barrierColor,
      ),
    )
        .then((value) {
      if (!mounted) return;
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

  FlexibleDropdownRoute({
    required this.child,
    required this.position,
    this.barrierBgColor,
    this.barrierShape,
    this.textDirection = TextDirection.rtl,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

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
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: false,
      removeBottom: false,
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
              child: child,
              builder: (context, child) {
                return Transform.scale(
                  alignment: Alignment.topCenter,
                  scaleY: animation.value,
                  child: child,
                );
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
