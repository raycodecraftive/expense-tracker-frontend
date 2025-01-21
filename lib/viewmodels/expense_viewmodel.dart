import 'dart:developer';

import 'package:expense_tracker_frontend1/pages/expensemodel.dart';
import 'package:expense_tracker_frontend1/services/api.dart';
import 'package:flutter/material.dart';

class ExpenseViewmodel extends ChangeNotifier {
  List<Expense> _expensedata = [];
  List<Expense> get expensedata => _expensedata;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void getExpenses() async {
    try {
      _isLoading = true;

      await Future.delayed(const Duration(seconds: 1));
      var resposne = await ApiService.sendRequest(
          url: "http://localhost:3000/expenses", method: HttpMethod.GET);
      if (resposne != null) {
        List<Expense> expenses = [];
        List arrayOfData = (resposne['data']);

        for (var element in arrayOfData) {
          Expense expense = Expense(
              id: element['id'],
              title: element['description'],
              amount: double.tryParse(element['amount'].toString()) ?? -1,
              category: element['category'],
              date: DateTime.parse(element['date']));

          expenses.add(expense);
        }
        _expensedata = expenses;
        notifyListeners();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print("error has been found");
    }
  }

  void addanExpense(
      {required String title,
      required int id,
      required double amount,
      required String category}) async {
    await Future.delayed(const Duration(seconds: 1));

    Expense expense = Expense(
      title: title,
      id: id,
      amount: amount,
      date: DateTime.now(),
      category: category,
    );
    // send the data to an api
    var response = await ApiService.sendRequest(
        method: HttpMethod.POST,
        url: "http://localhost:3000/expenses",
        body: expense.toMap());

    getExpenses();

    print(response);

    notifyListeners();
  }

  // Update an existing expense

  void updateExpense({required Expense e}) async {
    _isEditing = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    //
    Expense expense = _expensedata.firstWhere((expense) => expense.id == e.id);

    await ApiService.sendRequest(
        method: HttpMethod.PUT,
        url: "http://localhost:3000/expenses/${e.id}",
        body: e.toMap());

    /// updating the expense locally
    expense.title = e.title;
    expense.amount = e.amount;
    expense.category = e.category;
    expense.date = DateTime.now();
    _isEditing = false;
    notifyListeners();
  }

  /// Delete an Expense
  void deleteExpense(int id) async {
    try {
      // Find the expense in the local list
      Expense expense = _expensedata.firstWhere((expense) => expense.id == id);

      // Send a DELETE request to the API
      var response = await ApiService.sendRequest(
        method: HttpMethod.DELETE,
        url: "http://localhost:3000/expenses/$id",
        body: {},
      );

      if (response != null) {
        /// Remove the expense from the local list
        _expensedata.removeWhere((expense) => expense.id == id);

        // Notify listeners to update the UI
        notifyListeners();
      } else {
        log("Failed to delete the expense from the Server.");
      }
    } catch (e) {
      log("Error deleting expense: $e");
    }
  }
}
