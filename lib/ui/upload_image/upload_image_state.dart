import 'package:alpha/domain/models/car_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageState extends Equatable {
  final bool loadInfo;
  final bool aux;
  final CarModel? carModel;
  final XFile? pickedFile;
  final int showMessage;

  const UploadImageState({
    this.loadInfo = false,
    this.aux = false,
    this.pickedFile,
    this.carModel,
    this.showMessage = 0,
  });

  UploadImageState copyWith({
    bool? loadInfo,
    bool? aux,
    CarModel? carModel,
    XFile? pickedFile,
    int? showMessage,
  }) {
    return UploadImageState(
      loadInfo: loadInfo ?? this.loadInfo,
      aux: aux ?? this.aux,
      carModel: carModel ?? this.carModel,
      pickedFile: pickedFile ?? this.pickedFile,
      showMessage: showMessage ?? this.showMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadInfo,
        aux,
        carModel,
        pickedFile,
        showMessage,
      ];
}
