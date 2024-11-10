import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpLoadImageScreen extends StatefulWidget {
  static const routeName = '/upload-image';
  const UpLoadImageScreen({
    super.key,
  });
  @override
  _UpLoadImageScreenState createState() => _UpLoadImageScreenState();
}

class _UpLoadImageScreenState extends State<UpLoadImageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;
  String? _imageUrl;

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  var pickedFile;
  late String imageUrl;

  Future<void> _pickImage() async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Error: Usuario no autenticado.");
      return;
    } else {
      if (pickedFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('car_images/${DateTime.now().millisecondsSinceEpoch}');

        if (kIsWeb) {
          // Código para Web: Usa `Uint8List`
          Uint8List imageData = await pickedFile.readAsBytes();
          await storageRef.putData(imageData);
        } else {
          // Código para dispositivos móviles: Usa `File`
          io.File imageFile = io.File(pickedFile.path);
          await storageRef.putFile(imageFile);
        }

        // Obtener la URL de descarga
        imageUrl = await storageRef.getDownloadURL();
        print('Image URL: $imageUrl');
        // Aquí puedes asignar `imageUrl` a una variable o hacer lo que necesites con él
      }
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      await _uploadImage();

      final carData = {
        'model': _modelController.text,
        'brand': _brandController.text,
        'mileage': _mileageController.text,
        'price': _priceController.text,
        'engine': _engineController.text,
        'year': int.parse(_yearController.text),
        'image': imageUrl,
        'createdAt': DateTime.now().millisecondsSinceEpoch, // Timestamp as int
      };

      await FirebaseFirestore.instance.collection('cars').add(carData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Car added successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Car')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: 'Model'),
                  validator: (value) => value!.isEmpty ? 'Enter model' : null),
              TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: 'Brand'),
                  validator: (value) => value!.isEmpty ? 'Enter brand' : null),
              TextFormField(
                  controller: _mileageController,
                  decoration: InputDecoration(labelText: 'Mileage'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter mileage' : null),
              TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter price' : null),
              TextFormField(
                  controller: _engineController,
                  decoration: InputDecoration(labelText: 'Engine'),
                  validator: (value) => value!.isEmpty ? 'Enter engine' : null),
              TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter year' : null),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _pickImage, child: Text('Choose Image')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitData, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
