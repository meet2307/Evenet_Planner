import 'package:event_manager_app/app/home/models/budget.dart';
import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/app/home/models/guest.dart';
import 'package:event_manager_app/app/home/models/task.dart';
import 'package:event_manager_app/app/home/models/vendors.dart';
import 'package:event_manager_app/services/api_path.dart';
import 'package:event_manager_app/services/firestore_service.dart';
import 'package:meta/meta.dart';

abstract class Database {
  Stream<Event> eventStream({@required String eventId});
  Future<void> setEvent(Event event);
  Future<void> deleteEvent(Event event);
  Stream<List<Event>> eventsStream({@required String order});
  Stream<List<Event>> queryEventStream({@required String eventName});

  Future<void> setGuest(Event event, Guest guest);
  Future<void> deleteGuest(Event event, Guest job);
  Stream<List<Guest>> guestsStream({@required String eventId, @required String order});
  Stream<List<Guest>> queryGuestsStream({@required String eventId, @required String guestName});

  Future<void> setTask(Event event, Task task);
  Future<void> deleteTask(Event event, Task task);
  Stream<List<Task>> tasksStream({@required String eventId, @required String order});
  Stream<List<Task>> queryTasksStream({@required String eventId, @required String taskName});

  Future<void> setBudget(Event event, Budget budget);
  Future<void> deleteBudget(Event event, Budget budget);
  Stream<List<Budget>> budgetsStream({@required String eventId, @required String order});
  Stream<List<Budget>> queryBudgetsStream({@required String eventId, @required String budgetName});

  Future<void> setVendor(Event event, Vendor vendor);
  Future<void> deleteVendor(Event event, Vendor vendor);
  Stream<List<Vendor>> vendorsStream({@required String eventId, @required String order});
  Stream<List<Vendor>> queryVendorsStream({@required String eventId, @required String vendorName});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setEvent(Event event) => _service.setData(
        path: APIPath.event(uid, event.id),
        data: event.toMap(),
      );

  @override
  Future<void> deleteEvent(Event event) => _service.deleteData(
        path: APIPath.event(uid, event.id),
      );

  @override
  Stream<List<Event>> eventsStream({@required String order}) =>
      _service.collectionStream(
        order: order,
        path: APIPath.events(uid),
        builder: (data, documentId) => Event.fromMap(data, documentId),
      );

  @override
  Stream<List<Event>> queryEventStream({@required String eventName}) =>
      _service.queryCollectionStream(
        name: eventName,
        path: APIPath.events(uid),
        builder: (data, documentId) => Event.fromMap(data, documentId),
      );

  @override
  Stream<Event> eventStream({@required String eventId}) =>
      _service.documentStream(
        path: APIPath.event(uid, eventId),
        builder: (data, documentId) => Event.fromMap(data, documentId),
      );

  @override
  Future<void> setGuest(Event event, Guest guest) => _service.setData(
        path: APIPath.guest(uid, event.id, guest.id),
        data: guest.toMap(),
      );

  @override
  Future<void> deleteGuest(Event event, Guest guest) => _service.deleteData(
        path: APIPath.guest(uid, event.id, guest.id),
      );

  @override
  Stream<List<Guest>> guestsStream({@required String eventId, @required String order}) =>
      _service.collectionStream(
        order: order,
        path: APIPath.guests(uid, eventId),
        builder: (data, documentId) => Guest.fromMap(data, documentId),
      );

  @override
  Stream<List<Guest>> queryGuestsStream({@required String eventId, @required String guestName}) =>
      _service.queryCollectionStream(
        name: guestName,
        path: APIPath.guests(uid, eventId),
        builder: (data, documentId) => Guest.fromMap(data, documentId),
      );

  @override
  Future<void> setTask(Event event, Task task) => _service.setData(
        path: APIPath.task(uid, event.id, task.id),
        data: task.toMap(),
      );

  @override
  Future<void> deleteTask(Event event, Task task) => _service.deleteData(
        path: APIPath.task(uid, event.id, task.id),
      );

  @override
  Stream<List<Task>> tasksStream({@required String eventId, @required String order}) =>
      _service.collectionStream(
        order: order,
        path: APIPath.tasks(uid, eventId),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );

  @override
  Stream<List<Task>> queryTasksStream({String eventId, String taskName}) =>
    _service.queryCollectionStream(
      name: taskName,
      path: APIPath.tasks(uid, eventId),
      builder: (data, documentId) => Task.fromMap(data, documentId),
    );


  @override
  Future<void> setBudget(Event event, Budget budget) => _service.setData(
        path: APIPath.budget(uid, event.id, budget.id),
        data: budget.toMap(),
      );

  @override
  Future<void> deleteBudget(Event event, Budget budget) => _service.deleteData(
        path: APIPath.budget(uid, event.id, budget.id),
      );

  @override
  Stream<List<Budget>> budgetsStream({@required String eventId, @required String order}) =>
      _service.collectionStream(
        order: order,
        path: APIPath.budgets(uid, eventId),
        builder: (data, documentId) => Budget.fromMap(data, documentId),
      );

  @override
  Stream<List<Budget>> queryBudgetsStream({String eventId, String budgetName}) =>
      _service.queryCollectionStream(
        name: budgetName,
        path: APIPath.budgets(uid, eventId),
        builder: (data, documentId) => Budget.fromMap(data, documentId),
      );

  @override
  Future<void> setVendor(Event event, Vendor vendor) => _service.setData(
        path: APIPath.vendor(uid, event.id, vendor.id),
        data: vendor.toMap(),
      );

  @override
  Future<void> deleteVendor(Event event, Vendor vendor) => _service.deleteData(
        path: APIPath.vendor(uid, event.id, vendor.id),
      );

  @override
  Stream<List<Vendor>> vendorsStream({@required String eventId, @required String order}) =>
      _service.collectionStream(
        order: order,
        path: APIPath.vendors(uid, eventId),
        builder: (data, documentId) => Vendor.fromMap(data, documentId),
      );

  @override
  Stream<List<Vendor>> queryVendorsStream({String eventId, String vendorName}) =>
      _service.queryCollectionStream(
        name: vendorName,
        path: APIPath.vendors(uid, eventId),
        builder: (data, documentId) => Vendor.fromMap(data, documentId),
      );
}
