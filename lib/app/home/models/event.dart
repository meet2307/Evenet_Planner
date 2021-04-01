import 'package:meta/meta.dart';

class Event {
  Event({
      @required this.id,
      @required this.name,
      @required this.budget,
      @required this.start,
      @required this.comment});

   String id;
   String name;
   int budget;
   String comment;
   DateTime start;

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int budget = data['budget'];
    final String comment = data['comment'];
    final int startMilliseconds = data['start'];
    return Event(
      id: documentId,
      name: name,
      budget: budget,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      comment: comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'budget': budget,
      'start': start.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
