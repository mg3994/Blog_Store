import 'package:flutter/material.dart';

class LocationSelectorDialog extends StatefulWidget {
  final Function(String city, String state, String country) onSelected;

  const LocationSelectorDialog({super.key, required this.onSelected});

  @override
  State<LocationSelectorDialog> createState() => _LocationSelectorDialogState();
}

class _LocationSelectorDialogState extends State<LocationSelectorDialog> {
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');

  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Location'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your location to find serviceable products near you:'),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City (e.g., Gurugram)'),
            ),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State (e.g., Haryana)'),
            ),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSelected(
              _cityController.text.trim(),
              _stateController.text.trim(),
              _countryController.text.trim(),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
