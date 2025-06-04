import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrEditDoctorPage extends StatefulWidget {
  final String? docId;
  final Map<String, dynamic>? existingData;

  const AddOrEditDoctorPage({super.key, this.docId, this.existingData});

  @override
  State<AddOrEditDoctorPage> createState() => _AddOrEditDoctorPageState();
}

class _AddOrEditDoctorPageState extends State<AddOrEditDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _nameController.text = widget.existingData!['name'] ?? '';
      _specialityController.text = widget.existingData!['speciality'] ?? '';
      _hospitalController.text = widget.existingData!['hospital'] ?? '';
      _locationController.text = widget.existingData!['location'] ?? '';
      _timeController.text = widget.existingData!['time'] ?? '';
      _feesController.text = widget.existingData!['fees']?.toString() ?? '';
      _ratingController.text = widget.existingData!['rating']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialityController.dispose();
    _hospitalController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _feesController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> saveDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final doctorData = {
      'name': _nameController.text,
      'speciality': _specialityController.text,
      'hospital': _hospitalController.text,
      'location': _locationController.text,
      'time': _timeController.text,
      'fees': int.tryParse(_feesController.text) ?? 0,
      'rating': int.tryParse(_ratingController.text) ?? 0,
      'likes': widget.existingData?['likes'] ?? 0,
    };

    final doctorsRef = FirebaseFirestore.instance.collection('doctors');

    try {
      if (widget.docId != null) {
        // Update
        await doctorsRef.doc(widget.docId).update(doctorData);
      } else {
        // Add new
        await doctorsRef.add(doctorData);
      }

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Error saving doctor: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save doctor.')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.docId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Doctor" : "Add Doctor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: "Name"),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter name" : null,
                      ),
                      TextFormField(
                        controller: _specialityController,
                        decoration: const InputDecoration(labelText: "Speciality"),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter speciality" : null,
                      ),
                      TextFormField(
                        controller: _hospitalController,
                        decoration: const InputDecoration(labelText: "Hospital"),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter hospital" : null,
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(labelText: "Location"),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter location" : null,
                      ),
                      TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(labelText: "Available Time"),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter time" : null,
                      ),
                      TextFormField(
                        controller: _feesController,
                        decoration: const InputDecoration(labelText: "Fees"),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? "Please enter fees" : null,
                      ),
                      TextFormField(
                        controller: _ratingController,
                        decoration: const InputDecoration(labelText: "Rating (0-5)"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Enter rating";
                          final rating = int.tryParse(value);
                          if (rating == null || rating < 0 || rating > 5) {
                            return "Rating must be between 0 and 5";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: saveDoctor,
                        child: Text(isEditing ? "Update Doctor" : "Add Doctor"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
