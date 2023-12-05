import '../Controller/sqlite_db.dart';
import '../Controller/request_controller.dart';

class Calculator {
  static const String SQLiteTable = "bmiCalculator";
  int? id;
  String name;
  double weight;
  int height;

  Calculator(this.weight, this.name, this.height);

  Calculator.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
  name = json['name'] as String,
  weight = json['weight'] as double, // Parse as double directly
  height = json['height'] as int;

  Map<String, dynamic> toJson() =>
  {'name': name, 'weight': weight, 'height': height};

  Future<bool>save() async {
    await SQLiteDB().insert(SQLiteTable, toJson());
    RequestController req = RequestController(path: "/api/calculator.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      return true;
    }
    else {
      if (await SQLiteDB().insert(SQLiteTable, toJson()) != 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<List<Calculator>> loadAll() async {
  RequestController req = RequestController(path: "/api/calculator.php");
  await req.get();

  if (req.status() == 200 && req.result() != null) {
  List<dynamic> items = req.result();
  return items.map((item) => Calculator.fromJson(item)).toList();
  } else {
  List<Map<String, dynamic>> result = await SQLiteDB().queryAll(SQLiteTable);
  return result.map((item) => Calculator.fromJson(item)).toList();
  }
  }
}