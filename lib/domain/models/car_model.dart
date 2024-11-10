import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CarModel {
  int? id;
  String model;
  String brand;
  String mileage;
  String price;
  String engine;
  int year;
  String image;
  int createdAt;

  CarModel({
    required this.id,
    required this.model,
    required this.brand,
    required this.mileage,
    required this.price,
    required this.engine,
    required this.year,
    required this.image,
    required this.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json['id'] as int?,
        model: json['model'] as String,
        brand: json['brand'] as String,
        mileage: json['mileage'] as String,
        price: json['price'] as String,
        engine: json['engine'] as String,
        year: (json['year'] as num).toInt(),
        image: json['image'] as String,
        createdAt: json['createdAt'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'brand': brand,
        'mileage': mileage,
        'price': price,
        'engine': engine,
        'year': year,
        'image': image,
        'createdAt': createdAt,
      };
}
