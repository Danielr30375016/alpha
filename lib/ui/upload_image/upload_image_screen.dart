import 'package:alpha/di/injection.dart';
import 'package:alpha/domain/models/car_model.dart';
import 'package:alpha/helper/router.dart';
import 'package:alpha/ui/appbar/app_bar_widget.dart';
import 'package:alpha/ui/upload_image/upload_image_bloc.dart';
import 'package:alpha/ui/upload_image/upload_image_state.dart';
import 'package:alpha/ui/widgets/car_card.dart';
import 'package:alpha/ui/widgets/mage_width_delete_button.dart';
import 'package:alpha/ui/widgets/pop_up_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpLoadImageScreen extends StatefulWidget {
  final String id;
  final CarModel? carModel;
  static const routeName = '/upload-image/:id';

  const UpLoadImageScreen(
      {super.key, required this.id, required this.carModel});

  @override
  // ignore: library_private_types_in_public_api
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
  late String imageUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _brandController.dispose();
    _mileageController.dispose();
    _priceController.dispose();
    _engineController.dispose();
    _yearController.dispose();
    super.dispose();
  }

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
                _uploadImageBloc.getFirstState(widget.id, widget.carModel);
              });
              return const Center(child: CircularProgressIndicator());
            }
            if (state.carModel != null && !state.loadFirstState) {
              _modelController.text = state.carModel!.model;
              _brandController.text = state.carModel!.brand;
              _mileageController.text = state.carModel!.mileage;
              _priceController.text = state.carModel!.price;
              _engineController.text = state.carModel!.engine;
              _yearController.text = state.carModel!.year.toString();
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _uploadImageBloc.loadFirstState();
              });
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
                            ..._buildTextFormFields(state),
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
                            ),
                            const SizedBox(height: 20),
                            if (state.pickedFile != null)
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ImageWithDeleteButton(
                                  selectedImage: state.pickedFile,
                                  onDelete: () async {
                                    setState(() {
                                      state.pickedFile = null;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 600, maxHeight: 400),
                      child: CarCard(
                        isAdmin: false,
                        imageUrl: state.carModel!.image,
                        model: state.carModel!.model,
                        brand: state.carModel!.brand,
                        mileage: state.carModel!.mileage,
                        price: state.carModel!.price,
                        engine: state.carModel!.engine,
                        selectedImage: state.pickedFile,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  List<Widget> _buildTextFormFields(UploadImageState state) {
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
                  onChanged: (value) {
                    if (field['label'] == 'Year') {
                      setState(() {
                        state.carModel!.year = int.parse(value);
                      });
                    }
                    if (field['label'] == 'Mileage (km)') {
                      setState(() {
                        state.carModel!.mileage = value;
                      });
                    }
                    if (field['label'] == 'Price (USD)') {
                      setState(() {
                        state.carModel!.price = value;
                      });
                    }
                    if (field['label'] == 'Engine Type') {
                      setState(() {
                        state.carModel!.engine = value;
                      });
                    }
                    if (field['label'] == 'Model') {
                      setState(() {
                        state.carModel!.model = value;
                      });
                    }
                    if (field['label'] == 'Brand') {
                      setState(() {
                        state.carModel!.brand = value;
                      });
                    }
                  },
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSubmitButton(UploadImageState state) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          bool response =
              await _uploadImageBloc.submitData(context, state.carModel!);
          if (response) context.pop();
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
