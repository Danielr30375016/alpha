import 'package:alpha/ui/home/home_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerFactory<HomeBloc>(() => HomeBloc());
}
