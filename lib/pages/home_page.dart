
import 'package:expense_tracker_frontend1/pages/expense_form.dart';
import 'package:expense_tracker_frontend1/viewmodels/expense_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseViewmodel>().getExpenses();
  }

  // Function to show the Expense form
  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: AddExpenseForm(
            onSubmit: (expense, isEditing) {
              context.read<ExpenseViewmodel>().addanExpense(
                    title: expense.title,
                    id: expense.id,
                    amount: expense.amount,
                    category: expense.category,
                  );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use GetX for navigation

          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text(
              "4300 GBP",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.transparent,
      ),
      body: context.watch<ExpenseViewmodel>().isLoading
          ? const Center(
              child: CupertinoActivityIndicator(radius: 30),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "4150 GBP",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        context.watch<ExpenseViewmodel>().expensedata.length,
                    itemBuilder: (context, index) {
                      final expense =
                          context.watch<ExpenseViewmodel>().expensedata[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(expense.title),
                          subtitle: Text(
                              '${expense.category} | ${expense.date.toLocal()}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$${expense.amount.toStringAsFixed(2)}'),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.grey),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Expense'),
                                        content: AddExpenseForm(
                                          expense: expense,
                                          onSubmit: (expense, isEditing) {
                                            if (isEditing) {
                                              context
                                                  .read<ExpenseViewmodel>()
                                                  .updateExpense(e: expense);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.grey),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete Expense"),
                                      content: const Text(
                                          "Are you sure you want to delete this expense?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<ExpenseViewmodel>()
                                                .deleteExpense(expense.id);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'decreaseButton',
            onPressed: () {
              context.read<ExpenseViewmodel>();
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addButton',
            onPressed: _showAddExpenseDialog,
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
