import 'package:flutter/material.dart' hide AppBar, Scaffold, ScaffoldState;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:mui/src/scaffold/scaffold.dart';

const double _kLeadingWidth = kToolbarHeight;
const kFloatingToolbarHeight = 50.0;

class AppBar extends StatefulWidget implements PreferredSizeWidget {
  AppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.elevation,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.textTheme,
    this.primary = true,
    this.floating = false,
    this.centerTitle,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
  })  : assert(automaticallyImplyLeading != null),
        assert(elevation == null || elevation >= 0.0),
        assert(primary != null),
        assert(titleSpacing != null),
        preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final Widget leading;
  final bool floating;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final double elevation;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final double titleSpacing;

  @override
  final Size preferredSize;

  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (centerTitle != null) return centerTitle;
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return actions == null || actions.length < 2;
    }
    return null;
  }

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  static const double _defaultElevation = 4.0;

  void _handleDrawerButton() {
    Scaffold.of(context).openDrawer();
  }

  void _handleDrawerButtonEnd() {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ScaffoldState scaffold = Scaffold.of(context, nullOk: true);
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    IconThemeData overallIconTheme = widget.iconTheme;
    TextStyle centerStyle = widget.textTheme?.title ??
        appBarTheme.textTheme?.title ??
        theme.textTheme.title;
    TextStyle sideStyle = widget.textTheme?.body1 ??
        appBarTheme.textTheme?.body1 ??
        theme.textTheme.body1;

    Widget leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _handleDrawerButton,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else {
        if (canPop)
          leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: _kLeadingWidth),
        child: leading,
      );
    }

    Widget title = widget.title;
    if (title != null) {
      bool namesRoute;
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          namesRoute = true;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          break;
      }
      title = DefaultTextStyle(
        style: centerStyle,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Semantics(
          namesRoute: namesRoute,
          child: _AppBarTitleBox(child: title),
          header: true,
        ),
      );
    }

    Widget actions;
    if (widget.actions != null && widget.actions.isNotEmpty) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions,
      );
    } else if (hasEndDrawer) {
      actions = IconButton(
        icon: const Icon(Icons.menu),
        onPressed: _handleDrawerButtonEnd,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }

    // Allow the trailing actions to have their own theme if necessary.
    if (actions != null) {
      actions = IconTheme.merge(
        data: overallIconTheme,
        child: actions,
      );
    }

    final Widget toolbar = NavigationToolbar(
      leading: leading,
      middle: title,
      trailing: actions,
      centerMiddle: widget._getEffectiveCenterTitle(theme),
      middleSpacing: widget.titleSpacing,
    );

    final Color backgroundColor =
        widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    // If the toolbar is allocated less than kToolbarHeight make it
    // appear to scroll upwards within its shrinking container.
    Widget appBar = ClipRect(
      child: CustomSingleChildLayout(
        delegate: const _ToolbarContainerLayout(),
        child: IconTheme.merge(
          data: overallIconTheme,
          child: DefaultTextStyle(
            style: sideStyle,
            child: toolbar,
          ),
        ),
      ),
    );

    /// TODO: make it floating
    if (widget.floating)
      appBar = Hero(
        tag: "search_transition",
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: EdgeInsets.fromLTRB(22, 0, 22, 0),
          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
          height: 54.0,
          child: Material(
            child: appBar,
            color: backgroundColor,
            elevation:
                widget.elevation ?? appBarTheme.elevation ?? _defaultElevation,
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      );

    // The padding applies to the toolbar and tabbar, not the flexible space.
    if (widget.primary) {
      appBar = SafeArea(
        top: true,
        child: appBar,
      );
    }

    appBar = Align(
      alignment: Alignment.topCenter,
      child: appBar,
    );

    appBar = Semantics(
      explicitChildNodes: true,
      child: appBar,
    );

    if (!widget.floating)
      appBar = AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: Material(
          color: backgroundColor,
          elevation:
              widget.elevation ?? appBarTheme.elevation ?? _defaultElevation,
          child: appBar,
        ),
      );

    final bool isDark = backgroundColor.computeLuminance() < 0.179;
    final brightness = isDark ? Brightness.light : Brightness.dark;

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: brightness,
          statusBarBrightness: brightness,
          statusBarColor: Colors.transparent,
        ),
        child: appBar,
      ),
    );
  }
}

class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout();

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: kToolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, kToolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => false;
}

class _AppBarTitleBox extends SingleChildRenderObjectWidget {
  const _AppBarTitleBox({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  @override
  _RenderAppBarTitleBox createRenderObject(BuildContext context) {
    return _RenderAppBarTitleBox(
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderAppBarTitleBox renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

class _RenderAppBarTitleBox extends RenderAligningShiftedBox {
  _RenderAppBarTitleBox({
    RenderBox child,
    TextDirection textDirection,
  }) : super(
            child: child,
            alignment: Alignment.center,
            textDirection: textDirection);

  @override
  void performLayout() {
    final BoxConstraints innerConstraints =
        constraints.copyWith(maxHeight: double.infinity);
    child.layout(innerConstraints, parentUsesSize: true);
    size = constraints.constrain(child.size);
    alignChild();
  }
}
