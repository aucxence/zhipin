import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/mycupertinopicker/src/widget/list_picker_widget.dart';
import 'package:my_zhipin_boss/mycupertinopicker/src/widget/updated_date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_picker_theme.dart';
import 'date_picker_constants.dart';
import 'date_time_formatter.dart';
import 'i18n/date_picker_i18n.dart';
import 'widget/date_picker_widget.dart';
import 'widget/datetime_picker_widget.dart';
import 'widget/time_picker_widget.dart';

enum DateTimePickerMode {
  //one more item
  updatedpicker,

  //work intentions
  column,

  //schooling range
  range,

  //
  degree,

  /// Display DatePicker
  dateonly,

  /// Display DatePicker
  date,

  /// Display TimePicker
  time,

  /// Display DateTimePicker
  datetime,
}

///
/// author: Dylan Wu
/// since: 2018/06/21
class DatePicker {
  /// Display date picker in bottom sheet.
  ///
  /// context: [BuildContext]
  /// minDateTime: [DateTime] minimum date time
  /// maxDateTime: [DateTime] maximum date time
  /// initialDateTime: [DateTime] initial date time for selected
  /// dateFormat: [String] date format pattern
  /// locale: [DateTimePickerLocale] internationalization
  /// pickerMode: [DateTimePickerMode] display mode: date(DatePicker)、time(TimePicker)、datetime(DateTimePicker)
  /// pickerTheme: [DateTimePickerTheme] the theme of date time picker
  /// onCancel: [DateVoidCallback] pressed title cancel widget event
  /// onClose: [DateVoidCallback] date picker closed event
  /// onChange: [DateValueCallback] selected date time changed event
  /// onConfirm: [DateValueCallback] pressed title confirm widget event
  static void showDatePicker(
    BuildContext context, {
    DateTime minDateTime,
    DateTime maxDateTime,
    DateTime initialDateTime,
    String dateFormat,
    DateTimePickerLocale locale: DATETIME_PICKER_LOCALE_DEFAULT,
    DateTimePickerMode pickerMode: DateTimePickerMode.date,
    DateTimePickerTheme pickerTheme: DateTimePickerTheme.Default,
    DateVoidCallback onCancel,
    DateVoidCallback onClose,
    DateValueCallback onChange,
    DateValueCallback onConfirm,
    int minuteDivider = 1,
    DegreeValueCallback onChge,
    DegreeValueCallback onCnfrm,
    Map<String, List<String>> data,
    String updateditem,
  }) {
    // handle the range of datetime
    if (minDateTime == null) {
      minDateTime = DateTime.parse(DATE_PICKER_MIN_DATETIME);
    }
    if (maxDateTime == null) {
      maxDateTime = DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }

    // handle initial DateTime
    if (initialDateTime == null) {
      initialDateTime = DateTime.now();
    }

    // Set value of date format
    dateFormat = DateTimeFormatter.generateDateFormat(dateFormat, pickerMode);

    Navigator.push(
      context,
      new _DatePickerRoute(
          minDateTime: minDateTime,
          maxDateTime: maxDateTime,
          initialDateTime: initialDateTime,
          dateFormat: dateFormat,
          locale: locale,
          pickerMode: pickerMode,
          pickerTheme: pickerTheme,
          onCancel: onCancel,
          onChange: onChange,
          onConfirm: onConfirm,
          // theme: Theme.of(context, shadowThemeOnly: true),
          theme: Theme.of(context),
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          minuteDivider: minuteDivider,
          onChge: onChge,
          onCnfrm: onCnfrm,
          data: data,
          updateditem: updateditem),
    ).whenComplete(onClose ?? () => {});
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat,
    this.locale,
    this.pickerMode,
    this.pickerTheme,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.theme,
    this.barrierLabel,
    this.minuteDivider,
    this.onChge,
    this.onCnfrm,
    this.data,
    this.updateditem,
    RouteSettings settings,
  }) : super(settings: settings);

  final DateTime minDateTime, maxDateTime, initialDateTime;
  final String dateFormat;
  final DateTimePickerLocale locale;
  final DateTimePickerMode pickerMode;
  final DateTimePickerTheme pickerTheme;
  final VoidCallback onCancel;
  final DateValueCallback onChange;
  final DateValueCallback onConfirm;
  final int minuteDivider;
  final DegreeValueCallback onChge, onCnfrm;
  final Map<String, List<String>> data;

  final String updateditem;

  final ThemeData theme;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    double height = pickerTheme.pickerHeight;
    if (pickerTheme.title != null || pickerTheme.showTitle) {
      height += pickerTheme.titleHeight;
    }

    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child:
          _DatePickerComponent(route: this, pickerHeight: height, data: data),
    );

    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DatePickerComponent extends StatelessWidget {
  final _DatePickerRoute route;
  final double _pickerHeight;
  final Map data;

  _DatePickerComponent(
      {Key key, @required this.route, @required pickerHeight, this.data})
      : this._pickerHeight = pickerHeight;

  @override
  Widget build(BuildContext context) {
    Widget pickerWidget;
    switch (route.pickerMode) {
      case DateTimePickerMode.updatedpicker:
        pickerWidget = UpdatedDatePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          locale: route.locale,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
          updateditem: route.updateditem,
        );
        break;
      case DateTimePickerMode.column:
        pickerWidget = ListPickerWidget(
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChge,
          onConfirm: route.onCnfrm,
          list: data['values'],
        );
        break;
      case DateTimePickerMode.range:
        pickerWidget = RangePickerWidget(
            pickerTheme: route.pickerTheme,
            onCancel: route.onCancel,
            onChange: route.onChge,
            onConfirm: route.onCnfrm);
        break;
      case DateTimePickerMode.degree:
        pickerWidget = DegreePickerWidget(
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChge,
          onConfirm: route.onCnfrm,
          degrees: data,
        );
        break;
      case DateTimePickerMode.dateonly:
        pickerWidget = DatePickerWidgetOnly(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          locale: route.locale,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DateTimePickerMode.date:
        pickerWidget = DatePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initialDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          locale: route.locale,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
        );
        break;
      case DateTimePickerMode.time:
        pickerWidget = TimePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          locale: route.locale,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
          minuteDivider: route.minuteDivider,
        );
        break;
      case DateTimePickerMode.datetime:
        pickerWidget = DateTimePickerWidget(
          minDateTime: route.minDateTime,
          maxDateTime: route.maxDateTime,
          initDateTime: route.initialDateTime,
          dateFormat: route.dateFormat,
          locale: route.locale,
          pickerTheme: route.pickerTheme,
          onCancel: route.onCancel,
          onChange: route.onChange,
          onConfirm: route.onConfirm,
          minuteDivider: route.minuteDivider,
        );
        break;
    }
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(route.animation.value,
                  contentHeight: _pickerHeight),
              child: pickerWidget,
            ),
          );
        },
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.contentHeight});

  final double progress;
  final double contentHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: contentHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
