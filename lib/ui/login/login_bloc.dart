import 'dart:async';

import 'package:alpha/ui/admin_marketplace/admin_marketplace_screen.dart';
import 'package:alpha/ui/login/login_state.dart';
import 'package:alpha/ui/upload_image/upload_image_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(const LoginState());

  void getFirstState() {
    emit(const LoginState(listColors: [
      Color(0xFF1A2530), // Azul profundo más oscuro
      Color(0xFF0F6E63), // Verde azulado más oscuro
      Color(0xFF1C1C1C), // Gris muy oscuro
    ]));
    Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      List<Color> listColors = [];
      listColors.addAll(state.listColors);
      listColors.insert(0, state.listColors.last);
      listColors.removeLast();
      emit(LoginState(listColors: listColors));
    });
  }

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        // context.go("${UpLoadImageScreen.routeName.replaceAll(':id', "50")}");
        context.go(AdminMarketplaceScreen.routeName);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }
}
