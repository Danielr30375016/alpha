import 'package:alpha/di/injection.dart';
import 'package:alpha/helper/helper.dart';
import 'package:alpha/ui/admin_marketplace/admin_market_bloc.dart';
import 'package:alpha/ui/admin_marketplace/admin_market_state.dart';
import 'package:alpha/ui/upload_image/upload_image_screen.dart';
import 'package:alpha/ui/widgets/car_card.dart';
import 'package:alpha/ui/widgets/create_new_car.dart';
import 'package:alpha/ui/widgets/template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminMarketplaceScreen extends StatefulWidget {
  static const routeName = '/admin-marketplace';
  const AdminMarketplaceScreen({super.key});

  @override
  State<AdminMarketplaceScreen> createState() => _AdminMarketplaceScreenState();
}

class _AdminMarketplaceScreenState extends State<AdminMarketplaceScreen> {
  final _adminMarketBloc = getIt<AdminMarketBloc>();
  @override
  Widget build(BuildContext context) {
    return Template(
        child: BlocConsumer<AdminMarketBloc, AdminMarketState>(
      bloc: _adminMarketBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (!state.loadInfo) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _adminMarketBloc.getFirstState();
          });
          return const Center(child: CircularProgressIndicator());
        }
        return LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: constraints.maxWidth,
                height: 100,
                child: CreateNewCar(
                  onTap: () {
                    context
                        .go(UpLoadImageScreen.routeName.replaceAll(":id", "0"));
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: constraints.maxWidth,
                child: Wrap(
                  runSpacing: 15,
                  spacing: 15,
                  children: List.generate(state.cars.length, (i) {
                    List<double> size = Helper.getWidthOfCard(constraints);
                    return SizedBox(
                      width: size[0],
                      height: size[1],
                      child: CarCard(
                        imageUrl: state.cars[i].image,
                        model: state.cars[i].model,
                        brand: state.cars[i].brand,
                        mileage: state.cars[i].mileage,
                        price: state.cars[i].price,
                        engine: state.cars[i].engine,
                        isAdmin: true,
                        onTapEdit: () {
                          context.go(
                              UpLoadImageScreen.routeName
                                  .replaceAll(":id", state.cars[i].id!),
                              extra: state.cars[i]);
                        },
                        onTapDelete: () {
                          _adminMarketBloc.deleteCar(context, state.cars[i]);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
