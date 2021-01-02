import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import 'date_picker_title_widget.dart';

/// DatePicker widget.
///
/// @author dylan wu
/// @since 2019-05-10
class ListPickerWidget extends StatefulWidget {
  ListPickerWidget({
    Key key,
    this.pickerTheme: DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.list
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;

  final List<String> list;

  final DateVoidCallback onCancel;
  final DegreeValueCallback onChange, onConfirm;

  @override
  State<StatefulWidget> createState() => _ListPickerWidgetState();
}

class _ListPickerWidgetState extends State<ListPickerWidget> {
  FixedExtentScrollController _degreescroll;

  _ListPickerWidgetState() {
    _degreescroll = new FixedExtentScrollController(initialItem: 3);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render date picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget datePickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      Widget titleWidget = DatePickerTitleWidget(
        pickerTheme: widget.pickerTheme,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, datePickerWidget]);
    }
    return datePickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    var degree = widget.list[_intent];
    if (widget.onConfirm != null) {
      widget.onConfirm(
        degree, 
        degree
      );
    }
    Navigator.pop(context);
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = List<Widget>();

    Widget dgrPicker = _renderlist(
      scrollCtrl: _degreescroll,
      valueChanged: (value) {
        setState(() {
          _intent = value;
        });
      },
    );
    pickers.add(dgrPicker);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  int _intent = 0;

  Widget _renderlist({
    @required FixedExtentScrollController scrollCtrl,
    @required ValueChanged<int> valueChanged,
  }) {
    var intentions = widget.list;
    print("-- " + intentions[0]);
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: widget.pickerTheme.pickerHeight,
        decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
        child: CupertinoPicker.builder(
          backgroundColor: widget.pickerTheme.backgroundColor,
          scrollController: scrollCtrl,
          itemExtent: widget.pickerTheme.itemHeight,
          onSelectedItemChanged: valueChanged,
          childCount: widget.list.length,
          diameterRatio: 100000,
          squeeze: 1.0,
          itemBuilder: (context, index) {
            print(intentions[index]);
            return _renderItemComponent(intentions[index]);
          },
        ),
      ),
    );
  }

  Widget _renderItemComponent(String value) {
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      //padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        value,
        style:
            widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }
  
}
