import 'package:flutter/material.dart';

enum TabItem { guests, tasks, budgets, vendors}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.guests: TabItemData(title: 'Guests', icon: Icons.person),
    TabItem.tasks: TabItemData(title: 'Tasks', icon: Icons.add_to_photos_sharp),
    TabItem.budgets: TabItemData(title: 'Budget', icon: Icons.attach_money),
    TabItem.vendors: TabItemData(title: 'Vendors', icon: Icons.business_center_sharp),
  };
}