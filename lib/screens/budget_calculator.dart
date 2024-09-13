import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BudgetCalculatorPage extends StatefulWidget {
  @override
  _BudgetCalculatorPageState createState() => _BudgetCalculatorPageState();
}

class _BudgetCalculatorPageState extends State<BudgetCalculatorPage> {
  final _formKey = GlobalKey<FormState>();

  // Income and Expenses Sliders
  double salary = 80000;
  double investments = 1000;
  double otherIncome = 2000;
  double taxRate = 28;

  double rental = 1400;
  double utilities = 250;
  double transportation = 250;
  double food = 400;
  double insurance = 200;
  double healthcare = 200;
  double misc = 200;

  double availableBudget = 0;

  // Function to calculate budget
  void calculateBudget() {
    double totalIncome = salary + investments + otherIncome;
    double taxedIncome = totalIncome * (1 - (taxRate / 100));

    double totalExpenses = rental * 12 +
        utilities * 12 +
        transportation * 12 +
        food * 12 +
        insurance +
        healthcare * 12 +
        misc * 12;

    setState(() {
      availableBudget = taxedIncome - totalExpenses;
    });
  }

  // Predictive Analysis (simple)
  String analyzeSpending() {
    if (availableBudget < 0) {
      return "You are overspending. Consider reducing your transportation or food expenses.";
    } else if (availableBudget < 5000) {
      return "You have a limited surplus. You may want to reduce miscellaneous spending.";
    } else {
      return "You are saving well. Consider increasing your investments.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIxpense Budget Calculator',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Income (Yearly)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildSlider('Salary & Earned Income', salary, 50000, 200000,
                  (val) {
                setState(() {
                  salary = val;
                });
              }),
              buildSlider('Investments & Savings', investments, 0, 50000,
                  (val) {
                setState(() {
                  investments = val;
                });
              }),
              buildSlider('Other Income', otherIncome, 0, 10000, (val) {
                setState(() {
                  otherIncome = val;
                });
              }),
              buildSlider('Income Tax Rate (%)', taxRate, 0, 50, (val) {
                setState(() {
                  taxRate = val;
                });
              }),
              SizedBox(height: 20),
              Text(
                'Expenses (Monthly)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildSlider('Rental', rental, 500, 5000, (val) {
                setState(() {
                  rental = val;
                });
              }),
              buildSlider('Utilities', utilities, 100, 1000, (val) {
                setState(() {
                  utilities = val;
                });
              }),
              buildSlider('Transportation', transportation, 100, 2000, (val) {
                setState(() {
                  transportation = val;
                });
              }),
              buildSlider('Food', food, 100, 2000, (val) {
                setState(() {
                  food = val;
                });
              }),
              buildSlider('Insurance', insurance, 100, 2000, (val) {
                setState(() {
                  insurance = val;
                });
              }),
              buildSlider('Healthcare', healthcare, 100, 2000, (val) {
                setState(() {
                  healthcare = val;
                });
              }),
              buildSlider('Miscellaneous', misc, 100, 2000, (val) {
                setState(() {
                  misc = val;
                });
              }),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    calculateBudget();
                  },
                  child: Text('Calculate Budget'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (availableBudget != 0)
                Column(
                  children: [
                    Center(
                      child: Text(
                        'Available Budget: \u{20B9}${availableBudget.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      analyzeSpending(),
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                    SizedBox(height: 20),
                    buildChart(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSlider(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 100,
          activeColor: Colors.blue,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
        Text("\u{20B9}${value.toStringAsFixed(2)}"),
        SizedBox(height: 10),
      ],
    );
  }

  // Visualization using fl_chart
  Widget buildChart() {
    return Column(
      children: [
        Text(
          'Income vs Expenses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(toY: salary / 1000, color: Colors.blue)
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                        toY: (rental * 12) / 1000, color: Colors.red)
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                        toY: (utilities * 12) / 1000, color: Colors.green)
                  ],
                  showingTooltipIndicators: [0],
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(value.toString());
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      switch (value.toInt()) {
                        case 0:
                          return Text('Salary');
                        case 1:
                          return Text('Rental');
                        case 2:
                          return Text('Utilities');
                        default:
                          return Text('');
                      }
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
