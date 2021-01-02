import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import 'date_picker_title_widget.dart';

/// DatePicker widget.
///
/// @author dylan wu
/// @since 2019-05-10
class DegreePickerWidget extends StatefulWidget {
  DegreePickerWidget({
    Key key,
    this.pickerTheme: DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.degrees
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;

  final Map<String, List<String>> degrees;

  final DateVoidCallback onCancel;
  final DegreeValueCallback onChange, onConfirm;

  @override
  State<StatefulWidget> createState() => _DegreePickerWidgetState();
}

class _DegreePickerWidgetState extends State<DegreePickerWidget> {
  FixedExtentScrollController _degreescroll, _degreedetailsscroll;

  _DegreePickerWidgetState() {
    _degreescroll = new FixedExtentScrollController(initialItem: 3);
    _degreedetailsscroll = new FixedExtentScrollController(initialItem: 0);
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
    var degree = widget.degrees.keys.toList()[_currdgr];
    if (widget.onConfirm != null) {
      widget.onConfirm(
        degree, 
        widget.degrees[degree][_currdtls]
      );
    }
    Navigator.pop(context);
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = List<Widget>();

    Widget dgrPicker = _renderdegree(
      scrollCtrl: _degreescroll,
      valueChanged: (value) {
        // print("-- ** ++" + value.toString());
        setState(() {
          _currdgr = value;
        });
        _degreedetailsscroll.jumpToItem(0);
      },
    );
    pickers.add(dgrPicker);

    Widget dtlsPicker = _renderdegreedetails(
      scrollCtrl: _degreedetailsscroll,
      valueChanged: (value) {
        print("-- ** ++" + value.toString());
        _currdtls = value;
        //_changeMonthSelection(value);
      },
    );
    pickers.add(dtlsPicker);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  int _currdgr = 0;
  int _currdtls = 0;

  Widget _renderdegree({
    @required FixedExtentScrollController scrollCtrl,
    @required ValueChanged<int> valueChanged,
  }) {
    var keys = widget.degrees.keys.toList();
    print("-- " + keys[0]);
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
          childCount: widget.degrees.length,
          diameterRatio: 100000,
          squeeze: 1.0,
          itemBuilder: (context, index) {
            print(keys[index]);
            return _renderItemComponent(keys[index]);
          },
        ),
      ),
    );
  }

  Widget _renderdegreedetails({
    @required FixedExtentScrollController scrollCtrl,
    @required ValueChanged<int> valueChanged,
  }) {
    var keylist = widget.degrees[widget.degrees.keys.toList()[_currdgr]];
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
          childCount: keylist.length,
          diameterRatio: 100000,
          squeeze: 1.0,
          itemBuilder: (context, index) {
            return _renderItemComponent(keylist[index]);
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
