import 'package:scoped_model/scoped_model.dart';

class LoadModel extends Model{

  bool _loading = false;

  bool get loader => _loading;

  void alternate () {
    this._loading = ! this._loading;
    notifyListeners();
  } 

}