import 'package:alpha/di/injection.dart';
import 'package:alpha/domain/models/car_model.dart';
import 'package:alpha/ui/appbar/app_bar_widget.dart';
import 'package:alpha/ui/upload_image/upload_image_bloc.dart';
import 'package:alpha/ui/upload_image/upload_image_state.dart';
import 'package:alpha/ui/widgets/car_card.dart';
import 'package:alpha/ui/widgets/pop_up_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpLoadImageScreen extends StatefulWidget {
  static const routeName = '/upload-image';
  const UpLoadImageScreen({super.key});

  @override
  _UpLoadImageScreenState createState() => _UpLoadImageScreenState();
}

class _UpLoadImageScreenState extends State<UpLoadImageScreen> {
  final UploadImageBloc _uploadImageBloc = getIt<UploadImageBloc>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  var pickedFile;
  late String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutoShopAppBar(onLanguageChange: (value) {}),
      backgroundColor: Colors.grey[850],
      body: BlocConsumer<UploadImageBloc, UploadImageState>(
          bloc: _uploadImageBloc,
          listener: (context, state) {
            if (state.showMessage == 1) {
              PopUpWindow.showError(context, 'Error: Image not selected');
              _uploadImageBloc.clearMessage();
            }
          },
          builder: (context, state) {
            if (!state.loadInfo) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _uploadImageBloc.getFirstState();
              });
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Complete the details below to list a car for sale:',
                              style: TextStyle(color: Colors.white54),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ..._buildTextFormFields(),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: constraints.maxWidth,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  _buildImagePickerButton(),
                                  _buildSubmitButton(state),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 600, maxHeight: 400),
                      child: CarCard(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/alpha-ea10f.firebasestorage.app/o/car_images%2F1731261706628?alt=media&token=104d9233-97f0-4e70-9aae-c987f970ef35",
                        model: 'Modelo ${_modelController.text}',
                        brand: 'Marca ${_brandController.text}',
                        mileage: '${_mileageController.text} km',
                        price: _priceController.text,
                        engine: _engineController.text,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  List<Widget> _buildTextFormFields() {
    final fields = [
      {
        'label': 'Model',
        'hintText': 'e.g., Accord',
        'controller': _modelController
      },
      {
        'label': 'Brand',
        'hintText': 'e.g., Honda',
        'controller': _brandController
      },
      {
        'label': 'Mileage (km)',
        'hintText': 'e.g., 15000',
        'controller': _mileageController
      },
      {
        'label': 'Price (USD)',
        'hintText': 'e.g., 25000',
        'controller': _priceController
      },
      {
        'label': 'Engine Type',
        'hintText': 'e.g., V6',
        'controller': _engineController
      },
      {
        'label': 'Year',
        'hintText': 'e.g., 2020',
        'controller': _yearController
      },
    ];
    return fields
        .map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                  controller: field['controller'] as TextEditingController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: field['label'] == 'Year' ||
                          field['label'] == 'Price (USD)' ||
                          field['label'] == 'Mileage (km)'
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: field['label'] as String,
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: field['hintText'] as String,
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ${field['label']}';
                    }
                    if (field['label'] == 'Year') {
                      try {
                        if (int.parse(value) < 1900) {
                          return 'Please enter a valid year';
                        }
                      } catch (e) {
                        return 'Please enter a valid year';
                      }
                    }
                    return null;
                  }),
            ))
        .toList();
  }

  Widget _buildImagePickerButton() {
    return ElevatedButton.icon(
      onPressed: _uploadImageBloc.pickImage,
      icon: const Icon(Icons.image, color: Colors.white70),
      label:
          const Text('Choose Image', style: TextStyle(color: Colors.white70)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSubmitButton(UploadImageState state) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _uploadImageBloc.submitData(
              context,
              CarModel(
                id: null,
                model: _modelController.text,
                brand: _brandController.text,
                mileage: _mileageController.text,
                price: _priceController.text,
                engine: _engineController.text,
                year: int.parse(_yearController.text),
                image: '',
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Submit', style: TextStyle(color: Colors.black)),
    );
  }
}
