import 'package:alpha/domain/models/car_model.dart';
import 'package:alpha/ui/upload_image/upload_image_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class UploadImageBloc extends Cubit<UploadImageState> {
  UploadImageBloc() : super(const UploadImageState());

  Future<void> getFirstState() async {
    CarModel carModel = CarModel(
      id: null,
      model: '',
      brand: '',
      mileage: '',
      price: '',
      engine: '',
      year: 0,
      image: '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    emit(state.copyWith(loadInfo: true, carModel: carModel, aux: !state.aux));
  }

  Future<void> pickImage() async {
    final _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      emit(state.copyWith(pickedFile: pickedFile));
    }
  }

  Future<void> uploadImage(CarModel carModel) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (state.pickedFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('car_images/${DateTime.now().millisecondsSinceEpoch}');

      // Verificar si es una imagen PNG, JPG, etc.
      String contentType =
          'image/jpeg'; // Default, puedes cambiar dependiendo del tipo de imagen.

      if (state.pickedFile!.path.endsWith('.png')) {
        contentType = 'image/png';
      } else if (state.pickedFile!.path.endsWith('.jpg') ||
          state.pickedFile!.path.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      }

      if (kIsWeb) {
        Uint8List imageData = await state.pickedFile!.readAsBytes();
        await storageRef.putData(
            imageData, SettableMetadata(contentType: contentType));
      } else {
        io.File imageFile = io.File(state.pickedFile!.path);
        await storageRef.putFile(
            imageFile, SettableMetadata(contentType: contentType));
      }
      final imageUrl = await storageRef.getDownloadURL();
      print(imageUrl);
      carModel.image = imageUrl;
      carModel.createdAt =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      emit(state.copyWith(
        carModel: carModel,
      ));
    }
  }

  Future<void> submitData(BuildContext context, CarModel carModel) async {
    if (state.pickedFile == null) {
      emit(state.copyWith(showMessage: 1, aux: !state.aux));
      return;
    }
    emit(state.copyWith(carModel: carModel));
    await uploadImage(state.carModel!);
    final carData = state.carModel!.toJson();

    await FirebaseFirestore.instance.collection('cars').add(carData);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Car added successfully')));
  }

  void clearMessage() {
    emit(state.copyWith(showMessage: 0));
  }
}
