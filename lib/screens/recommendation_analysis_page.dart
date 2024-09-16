import 'package:flutter/material.dart';
import 'dart:math';

class RecommendationAnalysisPage extends StatefulWidget {
  final Map<String, dynamic> plantData;

  const RecommendationAnalysisPage({Key? key, required this.plantData})
      : super(key: key);

  @override
  _RecommendationAnalysisPageState createState() =>
      _RecommendationAnalysisPageState();
}

class _RecommendationAnalysisPageState
    extends State<RecommendationAnalysisPage> {
  late String diseaseIdentification;
  late String fertilizerType;
  late String fertilizerQuantity;
  late String timeOfApplication;
  String sustainableMeasures = '';

  final List<String> diseases = [
    'Bacterial Leaf Blight',
    'Sheath Brown Rot',
    'Rice Blast',
    'Stem Rot'
  ];
  final List<String> fertilizers = [
    'Urea',
    'NPK 15-15-15',
    'Ammonium Sulfate',
    'Potassium Chloride'
  ];
  final List<String> applicationTimes = [
    'Seedling',
    'Vegetative',
    'Reproductive'
  ];

  final List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    generateRecommendations();
  }

  void generateRecommendations() {
    setState(() {
      diseaseIdentification = diseases[Random().nextInt(diseases.length)];
      fertilizerType = fertilizers[Random().nextInt(fertilizers.length)];
      fertilizerQuantity =
          '${Random().nextInt(500) + 100} ${Random().nextBool() ? 'mg' : 'ml'}';
      timeOfApplication =
          applicationTimes[Random().nextInt(applicationTimes.length)];
      sustainableMeasures =
          'Implement crop rotation, use organic mulch, practice integrated pest management';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Analysis'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDropdown(
                'Disease Identification', diseaseIdentification, diseases,
                (value) {
              if (value != null) setState(() => diseaseIdentification = value);
            }),
            const SizedBox(height: 16),
            buildDropdown('Fertilizer Type', fertilizerType, fertilizers,
                (value) {
              if (value != null) setState(() => fertilizerType = value);
            }),
            const SizedBox(height: 16),
            Text('Fertilizer Quantity: $fertilizerQuantity',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            buildDropdown(
                'Time of Application', timeOfApplication, applicationTimes,
                (value) {
              if (value != null) setState(() => timeOfApplication = value);
            }),
            const SizedBox(height: 16),
            const Text('Sustainable Measures:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(sustainableMeasures, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save current recommendation to history
                history.add({
                  'diseaseIdentification': diseaseIdentification,
                  'fertilizerType': fertilizerType,
                  'fertilizerQuantity': fertilizerQuantity,
                  'timeOfApplication': timeOfApplication,
                });
                // Navigate back to Plant Data Entry page
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Home'),
            ),
            const SizedBox(height: 24),
            if (history.isNotEmpty) ...[
              const Text('History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                children: history
                    .map((item) => ListTile(
                          title:
                              Text('Disease: ${item['diseaseIdentification']}'),
                          subtitle: Text(
                              'Fertilizer: ${item['fertilizerType']} - ${item['fertilizerQuantity']}'),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
