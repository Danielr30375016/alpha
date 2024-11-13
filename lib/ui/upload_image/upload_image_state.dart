import 'package:alpha/domain/models/car_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class UploadImageState extends Equatable {
  final bool loadInfo;
  final bool aux;
  final bool loadFirstState;
  final CarModel? carModel;
  XFile? pickedFile;
  final int showMessage;

  UploadImageState({
    this.loadInfo = false,
    this.aux = false,
    this.loadFirstState = false,
    this.pickedFile,
    this.carModel,
    this.showMessage = 0,
  });

  UploadImageState copyWith({
    bool? loadInfo,
    bool? aux,
    bool? loadFirstState,
    CarModel? carModel,
    XFile? pickedFile,
    int? showMessage,
  }) {
    return UploadImageState(
      loadInfo: loadInfo ?? this.loadInfo,
      aux: aux ?? this.aux,
      loadFirstState: loadFirstState ?? this.loadFirstState,
      carModel: carModel ?? this.carModel,
      pickedFile: pickedFile ?? this.pickedFile,
      showMessage: showMessage ?? this.showMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadInfo,
        aux,
        loadFirstState,
        carModel,
        pickedFile,
        showMessage,
      ];
}
