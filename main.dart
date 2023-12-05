import 'package:flutter/material.dart';

import 'Controller/sqlite_db.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String gender = 'Male';
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Your Fullname'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height in CM'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight in KG'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Gender:'),
                SizedBox(width: 10),
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Male'),
                SizedBox(width: 10),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'BMI Value $result',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              child: Text('Calculate BMI and Save'),
            ),
          ],
        ),
      ),
    );
  }

  void calculateBMI() async {
    String name = nameController.text;
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);

    double bmi = weight / ((height / 100) * (height / 100));
    String bmiCategory;

    if (gender == 'Male') {
      bmiCategory = getBMIMale(bmi);
    } else {
      bmiCategory = getBMIFemale(bmi);
    }

    Map<String, dynamic> bmiData = {
      'username': name,
      'weight': weight,
      'height': height.toInt(), // Store height as integer
      'gender': gender,
      'status': bmiCategory,
    };

    // Insert BMI data into SQLite database
    int id = await SQLiteDB().insert('bmi', bmiData);
    print('BMI data inserted with ID: $id');

    setState(() {
      result = '''
    $bmi
    $gender $bmiCategory
  ''';
    });
  }

  String getBMIMale(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight. Careful during strong wind!';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'That’s ideal! Please maintain';
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return 'Overweight! Work out please';
    } else {
      return 'Whoa Obese! Dangerous mate!';
    }
  }

  String getBMIFemale(double bmi) {
    if (bmi < 16.0) {
      return 'Underweight. Careful during strong wind!';
    } else if (bmi >= 16.0 && bmi < 22.0) {
      return 'That’s ideal! Please maintain';
    } else if (bmi >= 22.0 && bmi < 27.0) {
      return 'Overweight! Work out please';
    } else {
      return 'Whoa Obese! Dangerous mate!';
    }
  }

}