import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Year {
  Year({
    required this.year,
    this.password,
    String? id,
  }) : id = id ?? uuid.v4();
  final String id;
  final String year;
  String? password;
}
