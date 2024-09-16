import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'recommendation_analysis_page.dart';

class PlantDataEntryPage extends StatefulWidget {
  const PlantDataEntryPage({Key? key}) : super(key: key);

  @override
  _PlantDataEntryPageState createState() => _PlantDataEntryPageState();
}

class _PlantDataEntryPageState extends State<PlantDataEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String? cropType, farmingType, irrigationType, country, state, pincode;
  LatLng? selectedLocation;

  final Map<String, IconData> cropIcons = {
    'Rice': FontAwesomeIcons.seedling,
    'Wheat': FontAwesomeIcons.wheatAwn,
  };

  final Map<String, IconData> farmingIcons = {
    'Organic': FontAwesomeIcons.leaf,
    'Conventional': FontAwesomeIcons.tractor,
  };

  final Map<String, String> irrigationInfo = {
    'Drip': 'Precise water delivery directly to plant roots',
    'Sprinkler': 'Overhead watering simulating rainfall',
    'Flood': 'Field inundation for water-intensive crops',
    'Rain fed': 'Reliance on natural rainfall for irrigation',
  };

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedLocation != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data')));
      
      // Delay for 3 seconds
      await Future.delayed(Duration(seconds: 3));

      // Navigate to RecommendationAnalysisPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationAnalysisPage(
            plantData: {
              'cropType': cropType,
              'farmingType': farmingType,
              'irrigationType': irrigationType,
              'country': country,
              'state': state,
              'pincode': pincode,
              'location': selectedLocation,
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Required fields are missed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Plant Data'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDropdown(
                'Crop Type',
                cropType,
                cropIcons.keys.toList(),
                (value) => setState(() => cropType = value),
                icons: cropIcons,
              ),
              const SizedBox(height: 16),
              buildDropdown(
                'Farming Type',
                farmingType,
                farmingIcons.keys.toList(),
                (value) => setState(() => farmingType = value),
                icons: farmingIcons,
              ),
              const SizedBox(height: 16),
              buildDropdown(
                'Irrigation Type',
                irrigationType,
                irrigationInfo.keys.toList(),
                (value) => setState(() => irrigationType = value),
                infoTexts: irrigationInfo,
              ),
              const SizedBox(height: 16),
              buildDropdown(
                'Country',
                country,
                ['India', 'USA', 'UK'],
                (value) => setState(() => country = value),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                'State',
                state,
                ['Maharashtra', 'Gujarat', 'Punjab'],
                (value) => setState(() => state = value),
              ),
              const SizedBox(height: 16),
              buildDropdown(
                'Pincode',
                pincode,
                ['400001', '380001', '141001'],
                (value) => setState(() => pincode = value),
              ),
              const SizedBox(height: 16),
              const Text('Select Location:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(20.5937, 78.9629),
                    initialZoom: 5.0,
                    onTap: (tapPosition, point) {
                      setState(() => selectedLocation = point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        if (selectedLocation != null)
                          Marker(
                            point: selectedLocation!,
                            width: 80,
                            height: 80,
                            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged,
      {Map<String, IconData>? icons, Map<String, String>? infoTexts}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              if (icons != null && icons[item] != null)
                FaIcon(icons[item]!, size: 20, color: Colors.green),
              const SizedBox(width: 8),
              Text(item),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'This field is required' : null,
      onTap: () {
        if (infoTexts != null && value != null && infoTexts[value] != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(value),
                content: Text(infoTexts[value]!),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}