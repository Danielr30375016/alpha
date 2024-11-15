// ignore_for_file: prefer_const_constructors

import 'package:alpha/di/injection.dart';
import 'package:alpha/ui/appbar/app_bar_widget.dart';
import 'package:alpha/ui/login/login_bloc.dart';
import 'package:alpha/ui/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ignore: prefer_typing_uninitialized_variables
  late final _emailController;
  // ignore: prefer_typing_uninitialized_variables
  late final _passwordController;
  final _loginBloc = getIt<LoginBloc>();

  // Animación del gradiente
  @override
  void initState() {
    _loginBloc.getFirstState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutoShopAppBar(onLanguageChange: (value) {}),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {},
        bloc: _loginBloc,
        builder: (context, state) => AnimatedContainer(
          duration: const Duration(seconds: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: state.listColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          curve: Curves.easeInOut,
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    constraints:
                        const BoxConstraints(maxWidth: 600, maxHeight: 400),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(child: Container()),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white60),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.grey[850],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (value) {
                            _onSubmitted();
                          },
                          obscureText: !state
                              .showPassword, // Cambiar el valor según la visibilidad
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white60),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.grey[850],
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white60,
                              ),
                              onPressed: () {
                                _loginBloc.togglePasswordVisibility();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _onSubmitted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Color del botón
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitted() {
    _loginBloc.login(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);
  }
}
