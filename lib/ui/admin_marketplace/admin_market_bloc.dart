import 'package:alpha/domain/models/car_model.dart';
import 'package:alpha/ui/admin_marketplace/admin_market_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMarketBloc extends Cubit<AdminMarketState> {
  AdminMarketBloc() : super(const AdminMarketState());

  void getFirstState() async {
    List<CarModel> cars = await getCars();
    emit(AdminMarketState(loadInfo: true, cars: cars));
  }

  Future<List<CarModel>> getCars() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('cars').get();
    return querySnapshot.docs
        .map((doc) => CarModel.fromJson(doc.data()))
        .toList();
  }

  void clearMessage() {
    emit(const AdminMarketState(showMessage: 0));
  }
}
