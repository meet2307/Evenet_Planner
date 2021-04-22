import 'package:meta/meta.dart';

class Budget {
  Budget({
    @required this.id,
    @required this.name,
    @required this.category,
    @required this.note,
    @required this.estimated_amount,
  });
  final String id;
  final String name;
  final String category;
  final String note;
  final int estimated_amount;

  factory Budget.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String category = data['category'];
    final String note = data['note'];
    final int estimated_amount = data['estimated_amount'];
    return Budget(
      id: documentId,
      name: name,
      category: category,
      note: note,
      estimated_amount: estimated_amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'note': note,
      'estimated_amount': estimated_amount,
    };
  }
}
