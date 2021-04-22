import 'package:event_manager_app/components/empty_content.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length+1) {
          return Container(
            // margin: const EdgeInsets.only(bottom: 32),
            // padding: const EdgeInsets.symmetric(
            //     horizontal: 16, vertical: 8),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //   ),
            //   boxShadow: [
            //     BoxShadow(
            //       color: [Color(0xFF6448FE), Color(0xFF5FC6FF)].last.withOpacity(0.4),
            //       blurRadius: 8,
            //       spreadRadius: 2,
            //       offset: Offset(4, 4),
            //     ),
            //   ],
            //   borderRadius: BorderRadius.all(Radius.circular(24)),
            // ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Row(
            //           children: <Widget>[
            //             Icon(
            //               Icons.label,
            //               color: Colors.white,
            //               size: 24,
            //             ),
            //             SizedBox(width: 8),
            //             Text(
            //               "alarm.title",
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontFamily: 'avenir'),
            //             ),
            //           ],
            //         ),
            //         Switch(
            //           onChanged: (bool value) {},
            //           value: true,
            //           activeColor: Colors.white,
            //         ),
            //       ],
            //     ),
            //     Text(
            //       'Mon-Fri',
            //       style: TextStyle(
            //           color: Colors.white, fontFamily: 'avenir'),
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text(
            //           "alarmTime",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontFamily: 'avenir',
            //               fontSize: 24,
            //               fontWeight: FontWeight.w700),
            //         ),
            //         IconButton(
            //             icon: Icon(Icons.delete),
            //             color: Colors.white,
            //             onPressed: () {
            //               // deleteAlarm(alarm.id);
            //             }),
            //       ],
            //     ),
            //   ],
            // ),
          );
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
