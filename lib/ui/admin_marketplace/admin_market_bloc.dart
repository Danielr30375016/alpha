import 'package:alpha/domain/models/car_model.dart';
import 'package:alpha/ui/admin_marketplace/admin_market_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMarketBloc extends Cubit<AdminMarketState> {
  AdminMarketBloc() : super(const AdminMarketState());

  void getFirstState() async {
    List<CarModel> cars = await getCars();
    cars.addAll([...cars]);
    cars.addAll([...cars]);
    emit(AdminMarketState(loadInfo: true, cars: cars));
  }

  Future<List<CarModel>> getCars() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('cars').get();
    return querySnapshot.docs.map((doc) => CarModel.fromJson(doc)).toList();
  }

  void clearMessage() {
    emit(const AdminMarketState(showMessage: 0));
  }

  Future<void> deleteCar(BuildContext context, CarModel carModel) async {
    await FirebaseFirestore.instance
        .collection('cars')
        .doc(carModel.id!)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car deleted successfully')));
    getFirstState();
  }
}
