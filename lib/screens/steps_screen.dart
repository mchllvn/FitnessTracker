import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  DateTime selectedDate = DateTime.now();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Steps Tracker"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6dd5fa), Color(0xff2980b9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// ===== INPUT CARD =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    /// DATE PICKER
                    InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          initialDate: selectedDate,
                        );
                        if (d != null) setState(() => selectedDate = d);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 10),
                            Text(DateFormat('yyyy-MM-dd')
                                .format(selectedDate)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// STEPS INPUT
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Steps",
                        prefixIcon: const Icon(Icons.directions_walk),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            label: "Add",
                            color: Colors.green,
                            onTap: () {
                              final ok = provider.addSteps(selectedDate,
                                  double.parse(controller.text));
                              if (!ok)
                                _show("Data for this date already exists");
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionButton(
                            label: "Update",
                            color: Colors.orange,
                            onTap: () {
                              provider.updateSteps(selectedDate,
                                  double.parse(controller.text));
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionButton(
                            label: "Delete",
                            color: Colors.red,
                            onTap: () =>
                                provider.deleteSteps(selectedDate),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ===== LIST =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.steps.length,
                itemBuilder: (_, i) {
                  final s = provider.steps[i];
                  final category = provider.stepCategory(s.value);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_walk, size: 30),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${s.value.toInt()} steps",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            Text(DateFormat('yyyy-MM-dd').format(s.date)),
                          ],
                        ),
                        const Spacer(),
                        Text(category,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _categoryColor(category))),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      {required String label,
      required Color color,
      required VoidCallback onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }

  Color _categoryColor(String c) {
    if (c == "Bad") return Colors.red;
    if (c == "Average") return Colors.orange;
    return Colors.green;
  }

  void _show(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }
}