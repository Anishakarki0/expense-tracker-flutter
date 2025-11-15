import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExpenseHome(),
    );
  }
}

class ExpenseHome extends StatefulWidget {
  const ExpenseHome({super.key});

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  List<Map<String, dynamic>> expenses = [];

  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  DateTime? pickedDate;

  void addExpense() {
    if (amountCtrl.text.isEmpty ||
        noteCtrl.text.isEmpty ||
        pickedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    setState(() {
      expenses.add({
        "amount": double.parse(amountCtrl.text),
        "note": noteCtrl.text,
        "date": "${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}",
      });
    });

    amountCtrl.clear();
    noteCtrl.clear();
    pickedDate = null;

    Navigator.pop(context);
  }

  double getTotal() {
    double total = 0;
    for (var e in expenses) {
      total += e["amount"];
    }
    return total;
  }

  void openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: "Note"),
              ),
              Row(
                children: [
                  Text(
                    pickedDate == null
                        ? "Select Date"
                        : "${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}",
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now(),
                      );
                      if (d != null) {
                        setState(() {
                          pickedDate = d;
                        });
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: addExpense,
                child: const Text("Add Expense"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color.fromARGB(255, 205, 80, 18),
            child: Text(
              "Total: ₹${getTotal()}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text("No expenses"))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: ListTile(
                          title: Text("₹${expenses[i]["amount"]}"),
                          subtitle: Text(
                            "${expenses[i]["note"]}\n${expenses[i]["date"]}",
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() => expenses.removeAt(i));
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
