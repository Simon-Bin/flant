import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../styles/var.dart';

/// 1px 边框
class FlanHairLine extends BorderSide {
  FlanHairLine({
    this.color = ThemeVars.borderColor,
  }) : super(color: color, width: 0.5);

  final Color color;
}

/// 动画曲线构造器
typedef FlanCurveBuilder = Curve Function(bool show);

/// 默认动画曲线构造器
Curve kFlanCurveBuilder(bool show) => show
    ? ThemeVars.animationTimingFunctionEnter
    : ThemeVars.animationTimingFunctionLeave;

/// 过渡动画构造器
typedef FlanTransitionBuilder<T> = Widget Function(
    Animation<T> animation, Widget child);

/// 过渡动画`Fade` 构造器
Widget kFlanFadeTransitionBuilder(animation, child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

/// 过渡动画`Slide Up` 构造器
Widget kFlanSlideUpTransitionBuilder(animation, child) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// 过渡动画`Slide Down` 构造器
Widget kFlanSlideDownTransitionBuilder(animation, child) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// 过渡动画`Slide Left` 构造器
Widget kFlanSlideLeftTransitionBuilder(animation, child) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// 过渡动画`Slide Right` 构造器
Widget kFlanSlideRightTransitionBuilder(animation, child) {
  return SlideTransition(
    position: Tween(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(animation),
    child: child,
  );
}

/// ### 过渡动画
///
/// - `curveBuilder` 动画曲线构造器,通过`show` 判断是进场动画还是离场动画
/// - `transitionBuilder` 过渡动画构造器
/// - 通过类型`Visibility`的子组件`child`的`visible` 控制展示和隐藏
class FlanTransition extends StatefulWidget {
  FlanTransition({
    this.duration,
    this.curveBuilder = kFlanCurveBuilder,
    this.onCompleted,
    this.onDismissed,
    required this.transitionBuilder,
    required this.child,
  });

  /// 动画时间
  final Duration? duration;

  /// 动画曲线构造器
  final FlanCurveBuilder curveBuilder;

  final VoidCallback? onCompleted;

  final VoidCallback? onDismissed;

  /// 过渡动画构造器
  final FlanTransitionBuilder transitionBuilder;

  /// 子组件
  final Visibility child;

  /// 过渡动画`Fade`
  FlanTransition.fade({
    this.duration,
    this.curveBuilder = kFlanCurveBuilder,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kFlanFadeTransitionBuilder,
    required this.child,
  });

  /// 过渡动画`Slide Down`
  FlanTransition.slideDown({
    this.duration,
    this.curveBuilder = kFlanCurveBuilder,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kFlanSlideDownTransitionBuilder,
    required this.child,
  });

  /// 过渡动画`Slide Up`
  FlanTransition.slideUp({
    this.duration,
    this.curveBuilder = kFlanCurveBuilder,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kFlanSlideUpTransitionBuilder,
    required this.child,
  });

  /// 过渡动画`Slide Left`
  FlanTransition.slideLeft({
    this.duration,
    this.curveBuilder = kFlanCurveBuilder,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kFlanSlideLeftTransitionBuilder,
    required this.child,
  });

  /// 过渡动画`Slide Right`
  FlanTransition.slideRight({
    this.duration,
    this.curveBuilder = kFlanCurveBuilder,
    this.onCompleted,
    this.onDismissed,
    this.transitionBuilder = kFlanSlideRightTransitionBuilder,
    required this.child,
  });

  @override
  _FlanTransitionState createState() => _FlanTransitionState();
}

class _FlanTransitionState extends State<FlanTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Visibility content;

  bool get show {
    return this.widget.child.visible;
  }

  @override
  void initState() {
    this.animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? ThemeVars.animationDurationBase,
    )..addStatusListener(this._transitionStatusChange);
    this.content = this.widget.child;
    if (this.show) {
      this.animationController.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    this.animationController
      ..removeStatusListener(this._transitionStatusChange)
      ..dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FlanTransition oldWidget) {
    final preShow = oldWidget.child.visible;
    if (this.show && !preShow) {
      this.setState(() {
        this.content = this.widget.child;
        this.animationController.forward();
      });
    }

    if (!this.show && preShow) {
      this.animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: this.animationController,
      curve: this.widget.curveBuilder(this.show),
    );
    return this.widget.transitionBuilder(curvedAnimation, this.content);
  }

  void _transitionStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      this.setState(() {
        this.content = this.widget.child;

        if (widget.onDismissed != null) {
          widget.onDismissed!();
        }
      });
    } else if (status == AnimationStatus.completed) {
      if (widget.onCompleted != null) {
        widget.onCompleted!();
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<FlanCurveBuilder>(
        "curveBuilder", widget.curveBuilder,
        defaultValue: kFlanCurveBuilder));
    properties.add(DiagnosticsProperty<FlanTransitionBuilder>(
        "transitionBuilder", widget.transitionBuilder));
    super.debugFillProperties(properties);
  }
}