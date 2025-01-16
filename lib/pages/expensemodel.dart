class Expense {
  int id;
  String title;
  double amount;
  DateTime date;
  String category;

  Expense({
    required this.title,
    required this.id,
    required this.amount,
    required this.date,
    required this.category,
  });

  toMap() {
    return {"description": title, "price": amount, "category": category};
  }
}
