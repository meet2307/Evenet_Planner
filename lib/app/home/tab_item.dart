import 'package:flutter/material.dart';

enum TabItem { guests, tasks, budgets, vendors}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon, @required this.color});

  final String title;
  final IconData icon;
  final Color color;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.guests: TabItemData(title: 'Guests', icon: Icons.person , color : Color(0xFFFF8484)),
    TabItem.tasks: TabItemData(title: 'Tasks', icon: Icons.add_to_photos_sharp , color : Color(0xFFFFB463)),
    TabItem.budgets: TabItemData(title: 'Budget', icon: Icons.attach_money , color : Color(0xFF63FFD5)),
    TabItem.vendors: TabItemData(title: 'Vendors', icon: Icons.shopping_cart , color : Color(0xFFFFE130)),
  };
}

// import 'package:flutter/material.dart';
//
// enum TabItem { guests, tasks, budgets, vendors }
//
// class TabItemData {
//   const TabItemData(
//       {@required this.title, @required this.icon, @required this.color});
//
//   final String title;
//   final IconData icon;
//   final Gradient color;
//
//   static const Map<TabItem, TabItemData> allTabs = {
//     TabItem.guests: TabItemData(
//       title: 'Guests',
//       icon: Icons.person,
//       color: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color(0xFF6448FE),
//           Color(0xFF5FC6FF),
//         ],
//       ),
//     ),
//     TabItem.tasks: TabItemData(
//       title: 'Tasks',
//       icon: Icons.add_to_photos_sharp,
//       color: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color(0xFFFE6197),
//           Color(0xFFFFB463),
//         ],
//       ),
//     ),
//     TabItem.budgets: TabItemData(
//       title: 'Budget',
//       icon: Icons.attach_money,
//       color: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color(0xFF61A3FE),
//           Color(0xFF63FFD5),
//         ],
//       ),
//     ),
//     TabItem.vendors: TabItemData(
//       title: 'Vendors',
//       icon: Icons.business_center_sharp,
//       color: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color(0xFFFFA738),
//           Color(0xFFFFE130),
//         ],
//       ),
//     ),
//   };
// }
