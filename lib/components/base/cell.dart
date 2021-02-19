import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import '../../styles/var.dart';
import '../../mixins/route_mixins.dart';
import './icon.dart';

/// ### FlanCell 单元格
/// 单元格为列表中的单个展示项。
class FlanCell extends RouteStatelessWidget {
  const FlanCell({
    Key key,
    this.title,
    this.value,
    this.label,
    this.size = FlanCellSize.normal,
    this.iconName,
    this.iconUrl,
    this.iconPrefix = kFlanIconsFamily,
    this.border = true,
    this.clickable = false,
    this.isLink = false,
    this.isRequired = false,
    this.center = false,
    this.arrowDirection = FlanCellArrowDirection.right,
    this.titleStyle,
    this.valueStyle,
    this.labelStyle,
    this.onClick,
    this.child,
    this.titleSlot,
    this.labelSlot,
    this.iconSlot,
    this.rightIconSlot,
    this.extraSlots,
    String toName,
    PageRoute toRoute,
    bool replace = false,
  })  : assert(size != null && size is FlanCellSize),
        assert(iconPrefix != null),
        assert(border != null),
        assert(clickable != null),
        assert(isLink != null),
        assert(isRequired != null),
        assert(center != null),
        assert(
            arrowDirection != null && arrowDirection is FlanCellArrowDirection),
        super(
          key: key,
          toName: toName,
          toRoute: toRoute,
          replace: replace,
        );

  // ****************** Props ******************
  /// 左侧标题
  final String title;

  /// 右侧内容
  final String value;

  /// 标题下方的描述信息
  final String label;

  /// 单元格大小，可选值为 `large`
  final FlanCellSize size;

  /// 左侧图标名称
  final int iconName;

  /// 左侧图片链接
  final String iconUrl;

  /// 图标类名前缀，同 Icon 组件的 class-prefix 属性
  final String iconPrefix;

  /// 是否显示内边框
  final bool border;

  /// 是否开启点击反馈
  final bool clickable;

  /// 是否展示右侧箭头并开启点击反馈
  final bool isLink;

  /// 是否显示表单必填星号
  final bool isRequired;

  /// 是否使内容垂直居中
  final bool center;

  /// 箭头方向，可选值为 `left` `up` `down`
  final FlanCellArrowDirection arrowDirection;

  /// 左侧标题额外样式
  final TextStyle titleStyle;

  /// 右侧内容额外类名
  final TextStyle valueStyle;

  /// 描述信息额外类名
  final TextStyle labelStyle;

  // ****************** Events ******************
  /// 点击单元格时触发
  final GestureTapCallback onClick;

  // ****************** Slots ******************
  /// 自定义右侧 value 的内容
  final Widget child;

  /// 自定义左侧 title 的内容
  final Widget titleSlot;

  /// 自定义标题下方 label 的内容
  final Widget labelSlot;

  /// 自定义左侧图标
  final FlanIcon iconSlot;

  /// 自定义右侧按钮，默认为 `arrow`
  final FlanIcon rightIconSlot;

  /// 自定义单元格最右侧的额外内容
  final Widget extraSlots;

  @override
  Widget build(BuildContext context) {
    Widget cell = Padding(
      padding: EdgeInsets.symmetric(
        vertical: this._sizeStyle.paddingVertical,
        horizontal: ThemeVars.cellHorizontalPadding,
      ),
      child: Row(
        crossAxisAlignment:
            this.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          this._buildLeftIcon(context),
          this._buildTitle(context),
          this._buildValue(context),
          this._buildRigthIcon(context),
          this.extraSlots,
        ].where((element) => element != null).toList(),
      ),
    );

    if (this.isRequired) {
      cell = Stack(
        children: [
          Positioned(
            top: this._sizeStyle.paddingVertical,
            left: ThemeVars.paddingXs,
            child: Text(
              "*",
              style: TextStyle(
                color: ThemeVars.cellRequiredColor,
                fontSize: ThemeVars.cellFontSize,
                height: 1.4,
              ),
            ),
          ),
          cell,
        ],
      );
    }

    if (this._isClickable) {
      cell = InkWell(
        splashColor: Colors.transparent,
        highlightColor: ThemeVars.black.withOpacity(0.1),
        enableFeedback: false,
        onTap: () {
          if (this.onClick != null) {
            this.onClick();
          }
          this.route(context);
        },
        child: cell,
      );
    }

    return Semantics(
      container: true,
      button: this._isClickable,
      child: Material(
        type: this._isClickable ? MaterialType.button : MaterialType.canvas,
        textStyle: this._cellTextStyle,
        color: ThemeVars.cellBackgroundColor,
        child: Ink(
          decoration: this.border
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: ThemeVars.cellBorderColor,
                    ),
                  ),
                )
              : null,
          child: cell,
        ),
      ),
    );
  }

  /// 是否有左侧标题
  bool get _hasTitle =>
      this.titleSlot != null || (this.title != null && this.title.isNotEmpty);

  /// 是否有右侧内容
  bool get _hasValue =>
      this.child != null || (this.value != null && this.value.isNotEmpty);

  /// 是否有标题下方的描述信息
  bool get _hasLabel =>
      this.labelSlot != null || (this.label != null && this.label.isNotEmpty);

  /// 默认字体样式
  TextStyle get _cellTextStyle {
    return TextStyle(
      color: ThemeVars.cellTextColor,
      fontSize: this._sizeStyle.titleFontSize,
      height: ThemeVars.cellLineHeight / this._sizeStyle.titleFontSize,
    );
  }

  /// 是否可以点击
  bool get _isClickable => this.isLink || this.clickable;

  double get _iconLineHeight =>
      ThemeVars.cellLineHeight + (Platform.isAndroid ? 6.0 : 0.0);

  /// 单元格大小样式
  _FlanCellSizeStyle get _sizeStyle {
    return {
      FlanCellSize.normal: _FlanCellSizeStyle(
        paddingVertical: ThemeVars.cellVerticalPadding,
        titleFontSize: ThemeVars.cellFontSize,
        labelFontSize: ThemeVars.cellLabelFontSize,
      ),
      FlanCellSize.large: _FlanCellSizeStyle(
        paddingVertical: ThemeVars.cellLargeVerticalPadding,
        titleFontSize: ThemeVars.cellLargeTitleFontSize,
        labelFontSize: ThemeVars.cellLargeLabelFontSize,
      ),
    }[this.size];
  }

  /// 构建标题
  Widget _buildTitle(BuildContext context) {
    if (this._hasTitle) {
      Widget title = this.titleSlot ?? Text(this.title);
      TextStyle tStyle = _cellTextStyle;

      if (this.titleStyle != null) {
        tStyle = tStyle.merge(this.titleStyle);
      }
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: tStyle,
              child: title,
            ),
            this._buildLabel(context),
          ].where((element) => element != null).toList(),
        ),
      );
    }
    return null;
  }

  /// 构建标题下方的描述信息
  Widget _buildLabel(BuildContext context) {
    if (this._hasLabel) {
      final label = Padding(
        padding: EdgeInsets.only(top: ThemeVars.cellLabelMarginTop),
        child: this.labelSlot ?? Text(this.label),
      );

      TextStyle lstyle = _cellTextStyle.copyWith(
        color: ThemeVars.cellLabelColor,
        fontSize: this._sizeStyle.labelFontSize,
        height: ThemeVars.cellLineHeight / this._sizeStyle.labelFontSize,
      );
      if (this.labelStyle != null) {
        lstyle = lstyle.merge(this.labelStyle);
      }
      return DefaultTextStyle(
        style: lstyle,
        child: label,
      );
    }
    return null;
  }

  /// 构建右侧内容
  Widget _buildValue(BuildContext context) {
    if (_hasValue) {
      final value = Expanded(
        child: Align(
          alignment: Alignment.topRight,
          child: this.child ?? Text(this.value),
        ),
      );

      final vStyle = _cellTextStyle.copyWith(
        color: !this._hasTitle ? ThemeVars.textColor : ThemeVars.cellValueColor,
      );
      if (this.valueStyle != null) {
        vStyle..merge(this.valueStyle);
      }
      return DefaultTextStyle(
        style: vStyle,
        child: value,
      );
    }

    return null;
  }

  /// 构建左侧图标
  Widget _buildLeftIcon(BuildContext context) {
    if (this.iconSlot != null) {
      return IconTheme(
        data: IconThemeData(
          size: ThemeVars.cellIconSize,
        ),
        child: Container(
          height: this._iconLineHeight,
          alignment: Alignment.center,
          child: this.iconSlot,
        ),
      );
    }

    if (this.iconName != null || this.iconUrl != null) {
      return Padding(
        padding: EdgeInsets.only(right: ThemeVars.paddingBase),
        child: Container(
          constraints: BoxConstraints(minWidth: ThemeVars.cellFontSize),
          height: this._iconLineHeight,
          alignment: Alignment.center,
          child: FlanIcon(
            iconName: this.iconName,
            iconUrl: this.iconUrl,
            size: ThemeVars.cellIconSize,
            classPrefix: this.iconPrefix,
          ),
        ),
      );
    }
    return null;
  }

  /// 构建右侧图标
  Widget _buildRigthIcon(BuildContext context) {
    if (this.rightIconSlot != null) {
      return IconTheme(
        data: IconThemeData(
          size: ThemeVars.cellIconSize,
          color: ThemeVars.cellRightIconColor,
        ),
        child: Container(
          height: this._iconLineHeight,
          alignment: Alignment.center,
          child: this.rightIconSlot,
        ),
      );
    }

    if (this.isLink) {
      final int iconName = {
        FlanCellArrowDirection.down: FlanIcons.arrow_down,
        FlanCellArrowDirection.up: FlanIcons.arrow_up,
        FlanCellArrowDirection.left: FlanIcons.arrow_left,
        FlanCellArrowDirection.right: FlanIcons.arrow,
      }[this.arrowDirection];

      return Padding(
        padding: EdgeInsets.only(left: ThemeVars.paddingBase),
        child: Container(
          height: this._iconLineHeight,
          constraints: BoxConstraints(minWidth: ThemeVars.cellFontSize),
          alignment: Alignment.center,
          child: FlanIcon(
            iconName: iconName,
            color: ThemeVars.cellRightIconColor,
            size: ThemeVars.cellIconSize,
            classPrefix: this.iconPrefix,
          ),
        ),
      );
    }

    return null;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<String>("title", title));
    properties.add(DiagnosticsProperty<String>("value", value));
    properties.add(DiagnosticsProperty<FlanCellSize>("size", size,
        defaultValue: FlanCellSize.normal));
    properties.add(DiagnosticsProperty<int>("iconName", iconName));
    properties.add(DiagnosticsProperty<String>("iconUrl", iconUrl));
    properties.add(DiagnosticsProperty<String>("iconPrefix", iconPrefix));
    properties
        .add(DiagnosticsProperty<bool>("border", border, defaultValue: true));
    properties.add(
        DiagnosticsProperty<bool>("clickable", clickable, defaultValue: false));
    properties
        .add(DiagnosticsProperty<bool>("isLink", isLink, defaultValue: false));
    properties.add(DiagnosticsProperty<bool>("isRequired", isRequired,
        defaultValue: false));
    properties
        .add(DiagnosticsProperty<bool>("center", center, defaultValue: false));
    properties.add(DiagnosticsProperty<FlanCellArrowDirection>(
        "arrowDirection", arrowDirection,
        defaultValue: FlanCellArrowDirection.right));
    properties.add(DiagnosticsProperty<TextStyle>("titleStyle", titleStyle));
    properties.add(DiagnosticsProperty<TextStyle>("valueStyle", valueStyle));
    properties.add(DiagnosticsProperty<TextStyle>("labelStyle", labelStyle));
    properties.add(DiagnosticsProperty<FlanCellSize>("size", size,
        defaultValue: FlanCellSize.normal));
    super.debugFillProperties(properties);
  }
}

/// 单元格大小
enum FlanCellSize {
  large,
  normal,
}

/// 箭头方向
enum FlanCellArrowDirection {
  up,
  down,
  left,
  right,
}

/// 单元格样式类
class _FlanCellSizeStyle {
  const _FlanCellSizeStyle({
    this.paddingVertical,
    this.titleFontSize,
    this.labelFontSize,
  });

  final double paddingVertical;
  final double titleFontSize;
  final double labelFontSize;
}
