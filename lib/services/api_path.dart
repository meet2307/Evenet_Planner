
class APIPath {
  static String event(String uid, String eventId) => 'users/$uid/Events/$eventId';
  static String events(String uid) => 'users/$uid/Events';

  static String guest(String uid, String eventId, String guestId) => 'users/$uid/Events/$eventId/Guests/$guestId';
  static String guests(String uid, String eventId) => 'users/$uid/Events/$eventId/Guests';

  static String task(String uid, String eventId, String taskId) => 'users/$uid/Events/$eventId/Tasks/$taskId';
  static String tasks(String uid, String eventId) => 'users/$uid/Events/$eventId/Tasks';

  static String budget(String uid, String eventId, String budgetId) => 'users/$uid/Events/$eventId/Budgets/$budgetId';
  static String budgets(String uid, String eventId) => 'users/$uid/Events/$eventId/Budgets';

  static String vendor(String uid, String eventId, String vendorId) => 'users/$uid/Events/$eventId/Vendors/$vendorId';
  static String vendors(String uid, String eventId) => 'users/$uid/Events/$eventId/Vendors';
}