import 'package:event_manager_app/app/home/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    // return BottomNavyBar(
    //   selectedIndex: currentTab.index,
    //   showElevation: true,
    //   onItemSelected: (index) => onSelectTab(TabItem.values[index]),
    //     //_pageController.animateToPage(index,duration: Duration(milliseconds: 300), curve: Curves.ease);
    //   items: [
    //     BottomNavyBarItem(
    //       icon: Icon(Icons.apps),
    //       title: Text('Home'),
    //       activeColor: Colors.red,
    //     ),
    //     BottomNavyBarItem(
    //         icon: Icon(Icons.people),
    //         title: Text('Users'),
    //         activeColor: Colors.purpleAccent
    //     ),
    //     BottomNavyBarItem(
    //         icon: Icon(Icons.message),
    //         title: Text('Messages'),
    //         activeColor: Colors.pink
    //     ),
    //     BottomNavyBarItem(
    //         icon: Icon(Icons.settings),
    //         title: Text('Settings'),
    //         activeColor: Colors.blue
    //     ),
    //   ],
    // );
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.guests),
          _buildItem(TabItem.tasks),
          _buildItem(TabItem.budgets),
          _buildItem(TabItem.vendors),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    var color = currentTab == tabItem ? itemData.color : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(color: color),
      ),
    );
  }
}