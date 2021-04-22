// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';
//
// class CreateViewPDF {
//   final pdf = pw.Document();
//   writeOnPdf(){
//     pdf.addPage(
//         pw.MultiPage(
//           pageFormat: PdfPageFormat.a5,
//           margin: pw.EdgeInsets.all(32),
//
//           build: (pw.Context context){
//             return <pw.Widget>  [
//               pw.Header(
//                   level: 0,
//                   child: pw.Text("Easy Approach Document")
//               ),
//
//               pw.Paragraph(
//                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
//               ),
//
//               pw.Paragraph(
//                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
//               ),
//
//               pw.Header(
//                   level: 1,
//                   child: pw.Text("Second Heading")
//               ),
//
//               pw.Paragraph(
//                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
//               ),
//
//               pw.Paragraph(
//                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
//               ),
//
//               pw.Paragraph(
//                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
//               ),
//             ];
//           },
//
//
//         )
//     );
//   }
//
//   Future savePdf() async{
//     Directory documentDirectory = await getApplicationDocumentsDirectory();
//
//     String documentPath = documentDirectory.path;
//
//     File file = File("$documentPath/example.pdf");
//
//     file.writeAsBytesSync(pdf.save());
//   }
// }