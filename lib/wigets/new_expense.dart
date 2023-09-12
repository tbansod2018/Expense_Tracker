import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.onAddExpense, {super.key});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountControlor = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  //validating response
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountControlor.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount < 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      //showing error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid input"),
          content: const Text(
              "please make sure a valid title, amount, date and category was entered"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            )
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountControlor.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, Constraints) {
        final width = Constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
                child: Column(
                  children: [
                    if (width >= 600)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              maxLength: 50,
                              decoration: const InputDecoration(
                                label: Text("Title"),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _amountControlor,
                              decoration: const InputDecoration(
                                prefixText: "\$ ",
                                label: Text("Amount"),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                      ),
                    if (width >= 600)
                      Row(
                        children: [
                          DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(
                                () {
                                  if (value == null) {
                                    return;
                                  }
                                  _selectedCategory = value;
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(_selectedDate == null
                                    ? "Not selected"
                                    : formater.format(_selectedDate!)),
                                IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _amountControlor,
                              decoration: const InputDecoration(
                                prefixText: "\$ ",
                                label: Text("Amount"),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(_selectedDate == null
                                    ? "Not selected"
                                    : formater.format(_selectedDate!)),
                                IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (width >= 600)
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _submitExpenseData();
                            },
                            child: const Text("Save Expense"),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          DropdownButton(
                              value: _selectedCategory,
                              items: Category.values
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name.toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value == null) {
                                    return;
                                  }
                                  _selectedCategory = value;
                                });
                              }),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _submitExpenseData();
                            },
                            child: const Text("Save Expense"),
                          ),
                        ],
                      )
                  ],
                )),
          ),
        );
      },
    );
  }
}
