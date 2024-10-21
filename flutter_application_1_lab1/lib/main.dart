import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: Column(
          children: [
            Expanded(
              child: LoanCalculatorScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

// B. Content - Loan Calculator Screen
class LoanCalculatorScreen extends StatefulWidget {
  @override
  _LoanCalculatorScreenState createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Cheia pentru formular
  final TextEditingController _amountController = TextEditingController();
  double _numberOfMonths = 1;
  final TextEditingController _percentController = TextEditingController();
  double _monthlyPayment = 0.0;

  void _calculateMonthlyPayment() {
    if (_formKey.currentState!.validate()) {
      // Validăm formularul
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      double interestRate = double.tryParse(_percentController.text) ?? 0.0;
      double totalInterest = amount * (interestRate / 100) * _numberOfMonths;
      double totalAmount = amount + totalInterest;
      setState(() {
        _monthlyPayment = totalAmount / _numberOfMonths;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    Text(
                      'Loan Calculator',
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 32),

                    // Fields
                    Field(
                      header: 'Enter amount',
                      controller: _amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Field(
                      header: 'Enter number of months',
                      child: SliderField(
                        value: _numberOfMonths,
                        onChanged: (double value) {
                          setState(() {
                            _numberOfMonths = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Field(
                      header: 'Enter % per month',
                      controller: _percentController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a percentage';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),

                    // Item (Calculations result)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30.0),
                          color: CupertinoColors.systemGrey6,
                          child: Text(
                            'You will pay the\napproximate amount\nmonthly:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${_monthlyPayment.toStringAsFixed(2)}€',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeBlue),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Solid (Button)
                    Container(
                      width: 500,
                      child: CupertinoButton.filled(
                        child: Text('Calculate'),
                        onPressed: _calculateMonthlyPayment,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Modifică și clasa Field pentru a include funcția validator
class Field extends StatelessWidget {
  final String header;
  final TextEditingController? controller;
  final String? Function(String?)? validator; // Funcție de validare
  final Widget? child;

  Field({required this.header, this.controller, this.child, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        child ??
            CupertinoTextField(
              controller: controller,
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.inactiveGray),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(12.0),
            ),
        SizedBox(height: 8),
        // Afisam mesajul de eroare, daca exista
        if (validator != null)
          Text(
            validator!(controller?.text) ?? '',
            style: TextStyle(
              color: CupertinoColors.systemRed,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}

class SliderField extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  SliderField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Slider itself
            Container(
              width: double.infinity,
              child: CupertinoSlider(
                value: value,
                min: 1,
                max: 60,
                divisions: 59,
                onChanged: onChanged,
              ),
            ),
            // Positioned circle showing selected value
            Positioned(
              left: ((value - 1) / 59) * MediaQuery.of(context).size.width - 10,
              bottom: 15,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              '60 luni',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}