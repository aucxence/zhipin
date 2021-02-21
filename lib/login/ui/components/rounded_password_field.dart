import 'package:flutter/material.dart';
import 'package:my_zhipin_boss/login/ui/components/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool obscure = true;

  bool isValidPassword(String input) {
    return new RegExp("(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})")
        .hasMatch(input);
  }

  // bool condition1(String input) {
  //   return new RegExp("^(?=.*[a-z])")
  //       .hasMatch(input);
  // }

  bool condition2(String input) {
    return (new RegExp("(?=.*[a-z])").hasMatch(input) ||
        new RegExp("(?=.*[A-Z])").hasMatch(input));
  }

  bool condition3(String input) {
    return new RegExp("(?=.*[0-9])").hasMatch(input);
  }

  bool condition4(String input) {
    return new RegExp("(?=.*[!@#\$%\^&\*])").hasMatch(input);
  }

  bool condition5(String input) {
    return new RegExp("(?=.{6,})").hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: obscure,
        autovalidate: true,
        validator: (input) {
          if (input.length == 0) return null;
          if (!condition5(input)) return "minimum 6 caractère requis";
          if (!condition2(input))
            return "le mot de passe doit contenir 1 lettre";
          if (!condition3(input))
            return "le mot de passe doit contenir 1 chiffre";
          if (!condition4(input))
            return "au moins 1 caractère spécial requis";
          else
            return null;
        },
        onChanged: widget.onChanged,
        cursorColor: Colors.black45,
        decoration: InputDecoration(
          hintText: "Mot de passe",
          hintStyle: TextStyle(color: Colors.black45),
          icon: Icon(
            Icons.lock,
            color: Colors.black45,
          ),
          suffixIcon: IconButton(
            icon: obscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            color: Colors.black45,
            onPressed: () {
              setState(() {
                obscure = !obscure;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
