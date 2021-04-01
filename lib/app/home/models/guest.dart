import 'package:meta/meta.dart';

class Guest {
  Guest({
    @required this.id,
    @required this.name,
    @required this.gender,
    @required this.acb,
    @required this.invitation,
    @required this.note,
    @required this.phone,
    @required this.emailid,
    @required this.address,
  });
  final String id;
  final String name;
  final String gender;
  final String acb;
  final String invitation;
  final String note;
  final String phone;
  final String emailid;
  final String address;

  factory Guest.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String gender = data['gender'];
    final String acb = data['acb'];
    final String invitation = data['invitation'];
    final String note = data['note'];
    final String phone = data['phone'];
    final String emailid = data['emailid'];
    final String address = data['address'];
    return Guest(
      id: documentId,
      name: name,
      gender:gender,
      acb: acb,
      invitation:invitation,
      note: note,
      phone:phone,
      emailid: emailid,
      address:address,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'acb': acb,
      'invitation': invitation,
      'note': note,
      'phone': phone,
      'emailid': emailid,
      'address': address,
    };
  }
}
