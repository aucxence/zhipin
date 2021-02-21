import 'package:flutter/material.dart';
import 'package:my_zhipin_boss/login/ui/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final Function validationFn;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.validationFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        autovalidate: true,
        validator: (input) => (this.validationFn(input) || input.length == 0)
            ? null
            : "Ce champ n'est pas correct",
        cursorColor: Colors.black45,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black45,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black45),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
