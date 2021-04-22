import 'package:event_manager_app/app/home/budget/edit_budget_page.dart';
import 'package:event_manager_app/app/home/models/budget.dart';
import 'package:event_manager_app/components/custom_list_tile.dart';
import 'package:event_manager_app/components/custome_text_for_popup.dart';
import 'package:event_manager_app/components/gradient_appbar.dart';
import 'package:event_manager_app/components/gradient_floating_add_button.dart';
import 'package:event_manager_app/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/components/list_items_builder.dart';
import 'package:event_manager_app/components/show_alert_dialog.dart';
import 'package:event_manager_app/components/show_exception_alert_dialog.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:provider/provider.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => BudgetsPage(database: database, event: event),
      ),
    );
  }

  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  TextEditingController searchController = TextEditingController();
  bool searchState = false;
  String _selection;

  Future<void> _confirmDelete(BuildContext context, Budget budget) async {
    final didRequestDelete = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure that you want to delete?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    );
    if (didRequestDelete == true) {
      _delete(context, budget);
    }
  }

  Future<void> _delete(BuildContext context, Budget budget) async {
    try {
      await widget.database.deleteBudget(widget.event, budget);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
        stream: widget.database.eventStream(eventId: widget.event.id),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          final event = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scaffold(
              appBar: AppBar(
                title: !searchState
                    ? Text('Budgets')
                    : TextField(
                        decoration: InputDecoration(
                          icon: IconButton(
                            icon: Icon(
                              Icons.arrow_back_sharp,
                              color: Colors.white,
                            ),
                            tooltip: 'Back',
                            onPressed: () {
                              setState(() {
                                searchState = !searchState;
                                searchController.clear();
                              });
                            },
                          ),
                          hintText: " Search Here.",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        controller: searchController,
                      ),
                elevation: 10.0,
                flexibleSpace: GradientAppbar(
                    start: Color(0xFF61A3FE), end: Color(0xFF63FFD5)),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: !searchState
                        ? IconButton(
                            icon: Icon(
                              Icons.search,
                            ),
                            tooltip: 'Search',
                            onPressed: () {
                              setState(() {
                                searchState = !searchState;
                              });
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            tooltip: 'Cancel',
                            onPressed: () {
                              setState(() {
                                searchState = !searchState;
                                searchState = !searchState;
                              });
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: !searchState
                        ? PopupMenuButton<String>(
                            icon: Icon(Icons.sort_rounded),
                            onSelected: (String result) {
                              setState(() {
                                _selection = result;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: "ascending_name",
                                child: Text('Ascending By Name'),
                              ),
                              const PopupMenuItem<String>(
                                value: "descending_name",
                                child: Text('Descending By Name'),
                              ),
                              const PopupMenuItem<String>(
                                value: "default",
                                child: Text('Default'),
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
              ),
              body: (searchState)
                  ? _buildSearchContents(context, event)
                  : (_selection == "ascending_name")
                      ? _buildContents(context, event, "ascending_name")
                      : (_selection == "descending_name")
                          ? _buildContents(context, event, "descending_name")
                          : (_selection == "default")
                              ? _buildContents(context, event, "default")
                              : _buildContents(context, event, "default"),
              floatingActionButton: FloatingActionButton(
                child: GradientFloatingAddButton(
                    start: Color(0xFF61A3FE),
                    end: Color(0xFF63FFD5),
                    searchState: searchState),
                onPressed: () => !searchState
                    ? EditBudgetPage.show(
                        context: context,
                        database: widget.database,
                        event: event,
                      )
                    : setState(() {
                        searchState = !searchState;
                        searchController.clear();
                      }),
              ),
            ),
          );
        });
  }

  Widget _buildContents(BuildContext context, Event event, String action) {
    return StreamBuilder<List<Budget>>(
      stream: widget.database.budgetsStream(eventId: event.id, order: action),
      builder: (context, snapshot) {
        return ListItemsBuilder<Budget>(
          snapshot: snapshot,
          itemBuilder: (context, budget) => Slidable(
            key: Key('budget-${budget.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: kDeleteColor,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, budget),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: kEditColor,
                icon: Icons.edit,
                onTap: () => EditBudgetPage.show(
                  context: context,
                  database: widget.database,
                  event: event,
                  budget: budget,
                ),
              ),
            ],
            child: CustomListTile(
              budget: budget,
              onTap: () => showDialogFunc(context, budget)
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchContents(BuildContext context, Event event) {
    return StreamBuilder<List<Budget>>(
      stream: widget.database.queryBudgetsStream(
          eventId: event.id, budgetName: searchController.text),
      builder: (context, snapshot) {
        return ListItemsBuilder<Budget>(
          snapshot: snapshot,
          itemBuilder: (context, budget) => Slidable(
            key: Key('budget-${budget.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: kDeleteColor,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, budget),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: kEditColor,
                icon: Icons.edit,
                onTap: () => EditBudgetPage.show(
                  context: context,
                  database: widget.database,
                  event: event,
                  budget: budget,
                ),
              ),
            ],
            child: CustomListTile(
              budget: budget,
              onTap: () => showDialogFunc(context, budget)
            ),
          ),
        );
      },
    );
  }

  showDialogFunc(BuildContext context, Budget budget) {
    final String name = budget.name;
    final String category = budget.category;
    final int estimated_amount = budget.estimated_amount;
    final String note = budget.note;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Budget Details ",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Name : $name"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Gender : $category"),
                    SizedBox(height: 10),
                    CutomeTextWidget(
                        title: "Estimated Amount : $estimated_amount"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Note : $note"),
                    SizedBox(
                      height: size.height*0.02,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Ok",
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
