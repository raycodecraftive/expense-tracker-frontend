import 'package:flutter/material.dart';

class Decreaseexpenseform extends StatelessWidget {
  final Function(double amount) onSubmit;

  const Decreaseexpenseform({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: amountController,
          decoration: const InputDecoration(labelText: 'Amount to Decrease'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(amountController.text) ?? 0.0;
            if (amount > 0) {
              onSubmit(amount);
              Navigator.pop(context);
            }
          },
          child: const Text('Decrease'),
        ),
      ],
    );
  }
}
