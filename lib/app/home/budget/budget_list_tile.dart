import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/budget.dart';

class BudgetListTile extends StatelessWidget {
  const BudgetListTile({Key key, @required this.budget, this.onTap}) : super(key: key);
  final Budget budget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(budget.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
