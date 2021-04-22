import 'package:meta/meta.dart';

class Event {
  Event({
      @required this.id,
      @required this.name,
      @required this.place,
      @required this.budget,
      @required this.start,
      @required this.comment});

   String id;
   String name;
   String place;
   int budget;
   String comment;
   DateTime start;


  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String place = data['place'];
    final int budget = data['budget'];
    final String comment = data['comment'];
    final int startMilliseconds = data['start'];
    return Event(
      id: documentId,
      name: name,
      place: place,
      budget: budget,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      comment: comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'place': place,
      'budget': budget,
      'start': start.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
