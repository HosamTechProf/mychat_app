import 'package:mychat_app/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = CacheHelper.getData(key: "isDark") ?? false;

  changeTheme(){
    isDark = !isDark;
    CacheHelper.setBool(key: "isDark", value: isDark);
    print(CacheHelper.getData(key: "isDark"));
    emit(ChangeThemeState());
  }
}
