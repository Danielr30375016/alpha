import 'package:alpha/ui/home/home_state.dart';
import 'package:bloc/bloc.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(const HomeState());

  Future<void> getFirstState() async {
    emit(const HomeState(message: 'Hello'));
  }
}
