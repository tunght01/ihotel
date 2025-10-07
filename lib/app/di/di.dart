import 'package:get_it/get_it.dart';
import 'package:ihostel/app/di/di.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureInjection(GetIt getIt) => $initGetIt(getIt);
