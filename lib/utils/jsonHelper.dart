class JsonHelper {
  static Map<String, dynamic> removeNulls(Map<String, dynamic> data) {
    Map<String, dynamic> result = {};
    data.keys.forEach((key) {
      if (data[key] != null) result[key] = data[key];
    });
    return result;
  }
}
