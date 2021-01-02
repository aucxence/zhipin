import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import 'date_picker_title_widget.dart';

/// DatePicker widget.
///
/// @author dylan wu
/// @since 2019-05-10
class RangePickerWidget extends StatefulWidget {
  RangePickerWidget({
    Key key,
    this.pickerTheme: DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;

  final DateVoidCallback onCancel;
  final DegreeValueCallback onChange, onConfirm;

  @override
  State<StatefulWidget> createState() => _RangePickerWidgetState();
}

class _RangePickerWidgetState extends State<RangePickerWidget> {

  var _currYear;
  int _inityear;

  FixedExtentScrollController _yearone, _yeartwo;
  
  @override
  void initState() {
    
    _inityear = new DateTime.now().year - 19;
    _currYear = new DateTime.now().year;
    _begyear = _inityear + 14;
    _endyear = _inityear + 19;

    print("debut $_begyear et fin $_endyear");

    super.initState();
  }

  _RangePickerWidgetState() {
    print("a");
    _yearone = new FixedExtentScrollController(initialItem: 14);
    _yeartwo = new FixedExtentScrollController(initialItem: 4);
    //_yeartwo = new FixedExtentScrollController();
  }

  @override
  Widget build(BuildContext context) {
    //_yearone.jumpToItem(_inityear + 15);
    //_yeartwo.jumpToItem(_inityear + 20);
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
    
    if (widget.onConfirm != null) {
      widget.onConfirm(
        _begyear.toString(), 
        _endyear.toString()
      );
    }
    Navigator.pop(context);
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = List<Widget>();

    Widget dgrPicker = _renderdegree(
      scrollCtrl: _yearone,
      valueChanged: (value) {
        setState(() {
          _begyear = _inityear + value;
        });
        print("-- ** ++" + _begyear.toString());
      },
    );
    pickers.add(dgrPicker);

    Widget dtlsPicker = _renderdegreedetails(
      scrollCtrl: _yeartwo,
      valueChanged: (value) {
        //print("-- ** ++" + value.toString());
        _endyear = _begyear + value;
        //_changeMonthSelection(value);
      },
    );
    pickers.add(dtlsPicker);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  int _begyear;
  int _endyear;

  Widget _renderdegree({
    @required FixedExtentScrollController scrollCtrl,
    @required ValueChanged<int> valueChanged,
  }) {

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
          childCount: _currYear - _inityear + 1,
          diameterRatio: 100000,
          squeeze: 1.0,
          itemBuilder: (context, index) {
            //print(_inityear + index));
            return _renderItemComponent((_inityear + index).toString());
          },
        ),
      ),
    );
  }

  Widget _renderdegreedetails({
    @required FixedExtentScrollController scrollCtrl,
    @required ValueChanged<int> valueChanged,
  }) {
    
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
          childCount: 7,
          diameterRatio: 100000,
          squeeze: 1.0,
          itemBuilder: (context, index) {
            var i = _begyear + index + 1;
            //print(i.toString());
            return _renderItemComponent(i.toString());
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
