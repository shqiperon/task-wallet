import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Year {
  Year({
    required this.year,
    String? id,
  }) : id = id ?? uuid.v4();
  final String id;
  final String year;
}
