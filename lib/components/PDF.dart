import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager_app/app/home/models/budget.dart';
import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/app/home/models/guest.dart';
import 'package:event_manager_app/app/home/models/vendors.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:event_manager_app/app/home/models/task.dart';

const bool kIsWeb = identical(0, 0.0);

class PDF extends StatefulWidget {
  const PDF({Key key, this.database, this.event, this.uid}) : super(key: key);
  final Database database;
  final Event event;
  final String uid;

  static Future<void> show(BuildContext context,
      {Database database, Event event, String uid}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PDF(
          database: database,
          event: event,
          uid: uid,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  final pdf = pw.Document();

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(BuildContext context, LayoutCallback build,
      PdfPageFormat pageFormat) async {
    final bytes = await build(pageFormat);
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    String filename = widget.event.name.toString();
    final file = File(appDocPath + '/' + '$filename.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => generateDocument(format),
        actions: actions,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final String _name = widget.event.name.toString().toUpperCase();
    final String _place = widget.event.place.toString();
    final String _start = widget.event.start.toString();
    final String _budget = widget.event.budget.toString();

    final guestHeaders = [
      'Name',
      'Gender',
      'Invitation',
      'Note',
      'Phone',
      'Email',
      'Address'
    ];
    final List guestsName = [];
    final taskHeaders = ['Name', 'Category', 'Taskstatus', 'Note'];
    final List tasksName = [];
    final budgetHeaders = ['Name', 'Category', 'Estimated Amount', 'Note'];
    final List budgetsName = [];
    final vendorHeaders = [
      'Name',
      'Category',
      'Estimated Amount',
      'Note',
      'Phone',
      'Email',
      'Website',
      'Address'
    ];
    final List vendorsName = [];

    await FirebaseFirestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("Events")
        .document(widget.event.id)
        .collection("Guests")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        if (value.exists) {
          var gname = value.get("name");
          var gender = value.get("gender");
          var invitation = value.get("invitation");
          var note = value.get("note");
          var phone = value.get("phone");
          var emailid = value.get("emailid");
          var address = value.get("address");
          guestsName.add(Guest(
              name: gname,
              gender: gender,
              invitation: invitation,
              note: note,
              phone: phone,
              emailid: emailid,
              address: address));
        } else {}
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("Events")
        .document(widget.event.id)
        .collection("Tasks")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        if (value.exists) {
          var tname = value.get("name");
          var cat = value.get("category");
          var status = value.get("taskstatus");
          var not = value.get("note");
          tasksName.add(
              Task(name: tname, category: cat, taskstatus: status, note: not));
        } else {}
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("Events")
        .document(widget.event.id)
        .collection("Budgets")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        if (value.exists) {
          var bname = value.get("name");
          var category = value.get("category");
          var note = value.get("note");
          var estimated_amount = value.get("estimated_amount");
          budgetsName.add(Budget(
              name: bname,
              category: category,
              note: note,
              estimated_amount: estimated_amount));
        } else {}
      });
    });
    await FirebaseFirestore.instance
        .collection("users")
        .document(widget.uid)
        .collection("Events")
        .document(widget.event.id)
        .collection("Vendors")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        if (value.exists) {
          var vname = value.get("name");
          var category = value.get("category");
          var note = value.get("note");
          var estimated_amount = value.get("estimated_amount");
          var phone = value.get("phone");
          var emailid = value.get("emailid");
          var website = value.get("website");
          var address = value.get("address");
          vendorsName.add(Vendor(
              name: vname,
              category: category,
              note: note,
              estimated_amount: estimated_amount,
              phone: phone,
              emailid: emailid,
              website: website,
              address: address));
        } else {}
      });
    });

    final guestData = guestsName
        .map((guest) => [
              guest.name,
              guest.gender,
              guest.invitation,
              guest.note,
              guest.phone,
              guest.emailid,
              guest.address
            ])
        .toList();

    final taskData = tasksName
        .map((task) => [task.name, task.category, task.taskstatus, task.note])
        .toList();
    final budgetData = budgetsName
        .map((budget) => [
              budget.name,
              budget.category,
              budget.note,
              budget.estimated_amount
            ])
        .toList();
    final vendorData = vendorsName
        .map((vendor) => [
              vendor.name,
              vendor.category,
              vendor.note,
              vendor.estimated_amount,
              vendor.phone,
              vendor.emailid,
              vendor.website,
              vendor.address
            ])
        .toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Text('Portable Document Format',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
              level: 0,
              title: 'PDF Report Of $_name Event.',
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('PDF Report Of $_name Event.', textScaleFactor: 2),
                    pw.PdfLogo()
                  ])),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Name :'),
              pw.Bullet(text: '$_name\n'),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Place :'),
              pw.Bullet(text: '$_place\n'),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Date & Time :'),
              pw.Bullet(text: '$_start\n'),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Budget :'),
              pw.Bullet(text: '$_budget\n'),
            ],
          ),
          // for ( var i in guestsName ) pw.Header(level: 1, text: 'Guests'),),
          pw.Header(level: 1, text: 'Guests'),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Table.fromTextArray(
                headers: guestHeaders,
                data: guestData,
                context: context,
              ),
            ],
          ),
          pw.Header(level: 1, text: 'Tasks'),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Table.fromTextArray(
                headers: taskHeaders,
                data: taskData,
                context: context,
              ),
            ],
          ),
          pw.Header(level: 1, text: 'Budgets'),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Table.fromTextArray(
                headers: budgetHeaders,
                data: budgetData,
                context: context,
              ),
            ],
          ),
          pw.Header(level: 1, text: 'Vendors'),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Table.fromTextArray(
                headers: vendorHeaders,
                data: vendorData,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
    return await doc.save();
  }
}