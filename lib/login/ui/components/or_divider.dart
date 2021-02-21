import 'package:flutter/material.dart';
import 'package:my_zhipin_boss/app/app_color.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      // width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OU",
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Colors.black45,
        height: 0,
        thickness: 1.5,
      ),
    );
  }
}
