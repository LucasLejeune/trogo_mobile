import 'package:flutter/material.dart';

class AddEquipmentForm extends StatefulWidget {
  const AddEquipmentForm({super.key, required this.title});

  final String title;

  @override
  State<AddEquipmentForm> createState() => _AddEquipmentFormState();
}

class _AddEquipmentFormState extends State<AddEquipmentForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isOption1Checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Form with Checkboxes'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              CheckboxListTile(
                title: Text('Option 1'),
                value: _isOption1Checked,
                onChanged: (bool? value) {
                  setState(() {
                    _isOption1Checked = value ?? false;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
