
import 'package:expense_tracker_frontend1/pages/expensemodel.dart';
import 'package:expense_tracker_frontend1/viewmodels/expense_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseForm extends StatefulWidget {
  final Function(Expense e, bool isEditing)
      onSubmit; // Callback function to handle the form submission

  final Expense? expense;

  const AddExpenseForm({
    super.key,
    required this.onSubmit,
    this.expense,
  });

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;
  String _category = 'Food';
  final DateTime _date = DateTime.now();

  final List<String> _categories = [
    'Food',
    'Transportation',
    'Entertainment',
    'Others'
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Check if an existing expense is provided for editing
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _category = widget.expense!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title Field
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onSaved: (value) {
              _title = value!;
            },
          ),
          const SizedBox(height: 12),

          // Amount Field
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onSaved: (value) {
              _amount = double.parse(value!);
            },
          ),
          const SizedBox(height: 12),

          // Category Dropdown
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _category = value!;
              });
            },
            onSaved: (value) {
              _category = value!;
            },
          ),
          const SizedBox(height: 12),

          // Submit Button
          SizedBox(
            child: context.watch<ExpenseViewmodel>().isEditing
                ? const CupertinoActivityIndicator()
                : ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(widget.expense != null
                        ? "Edit Expense"
                        : 'Add Expense'),
                  ),
          ),
        ],
      ),
    );
  }

  // Function to submit the form
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Create Expense object and pass it to the callback
      final newExpense = Expense(
        id: widget.expense != null
            ? widget.expense!.id
            : DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
        title: _title,
        amount: _amount,
        category: _category,
        date: _date,
      );

      // Pass the new expense to the parent widget using the callback
      widget.onSubmit(newExpense, widget.expense != null);

      // Close the dialog
    }
  }
}
