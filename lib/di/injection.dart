import 'package:alpha/ui/home/home_bloc.dart';
import 'package:alpha/ui/login/login_bloc.dart';
import 'package:alpha/ui/upload_image/upload_image_bloc.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerFactory<HomeBloc>(() => HomeBloc());
  getIt.registerFactory<LoginBloc>(() => LoginBloc());
  getIt.registerFactory<UploadImageBloc>(() => UploadImageBloc());
}
