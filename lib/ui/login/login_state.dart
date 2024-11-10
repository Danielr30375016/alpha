import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  final List<Color> listColors;
  final bool showPassword;

  const LoginState({
    this.listColors = const [Colors.black87],
    this.showPassword = false,
  });

  @override
  List<Object?> get props => [listColors, showPassword];

  LoginState copyWith({
    List<Color>? listColors,
    bool? showPassword,
  }) {
    return LoginState(
      listColors: listColors ?? this.listColors,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
