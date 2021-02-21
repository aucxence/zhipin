import 'package:flutter/material.dart';
import 'package:my_zhipin_boss/auth_checker.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';

class LoadChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
        builder: (context, child, model) => Stack(
              children: <Widget>[
                child,
                if (model.loading)
                  ModalBarrier(dismissible: false, color: Colors.black26),
                if (model.loading)
                  Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                      backgroundColor: Colors.grey)
              ],
            ),
        child: AuthChecker());
  }
}
