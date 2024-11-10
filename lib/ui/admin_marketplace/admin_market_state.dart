import 'package:alpha/domain/models/car_model.dart';
import 'package:equatable/equatable.dart';

class AdminMarketState extends Equatable {
  final List<CarModel> cars;
  final bool loadInfo;
  final int showMessage;

  const AdminMarketState({
    this.cars = const [],
    this.loadInfo = false,
    this.showMessage = 0,
  });

  @override
  List<Object?> get props => [cars, loadInfo, showMessage];

  AdminMarketState copyWith({
    List<CarModel>? cars,
    bool? loadInfo,
    int? showMessage,
  }) {
    return AdminMarketState(
      cars: cars ?? this.cars,
      loadInfo: loadInfo ?? this.loadInfo,
      showMessage: showMessage ?? this.showMessage,
    );
  }
}
