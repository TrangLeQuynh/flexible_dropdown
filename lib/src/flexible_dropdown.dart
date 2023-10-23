import 'package:flutter/material.dart';
import '../widgets/modal_barrier_layout.dart';
import '../widgets/overlay_route_layout.dart';

class FlexibleDropdown extends StatefulWidget {
  final Widget child;
  final Widget overlayChild;

  final double? elevation;
  final TextDirection textDirection;
  /// The offset is applied relative to the initial position
  /// set by the [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  final Offset offset;
  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;
  /// Called when the popup menu is shown.
  final VoidCallback? onClosed;

  const FlexibleDropdown({
    Key? key,
    required this.child,
    required this.overlayChild,
    this.textDirection = TextDirection.rtl,
    this.offset = Offset.zero,
    this.elevation,
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

  void _showOverlayDialog() {
    // final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
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
    final NavigatorState navigator = Navigator.of(context, rootNavigator: false);
    navigator.push(
      FlexibleDropdownRoute(
        capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
        child: widget.overlayChild,
        position: position,
        elevation: widget.elevation, // popupMenuTheme.elevation
        textDirection: widget.textDirection,
      ),
    ).then((value) {
      if (!mounted) return;
      widget.onClosed?.call();
    });
  }
}

class FlexibleDropdownRoute<T> extends PopupRoute<T> {
  final CapturedThemes capturedThemes;
  final Widget child;
  final RelativeRect position;
  final TextDirection textDirection;
  final double? elevation;

  FlexibleDropdownRoute({
    required this.capturedThemes,
    required this.child,
    required this.position,
    this.textDirection = TextDirection.rtl,
    this.elevation,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Color? get barrierColor => null;

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Flexible Dropdown';

  @override
  Widget buildModalBarrier() => ModalBarrierLayout(position: position);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
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
