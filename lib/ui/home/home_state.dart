import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String? message;

  const HomeState({this.message});

  HomeState copyWith({String? message}) {
    return HomeState(message: message ?? this.message);
  }

  @override
  List<Object?> get props => [message];
}
