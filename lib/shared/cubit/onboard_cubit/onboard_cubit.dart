import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/modules/onboarding/onboarding_screen.dart';
import 'onboard_state.dart';


class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(OnboardInitial());

  OnboardCubit get(context) => BlocProvider.of(context);

  List<OnBoardModelClass> pages = [
    OnBoardModelClass(
        title: "Title 1", body: "Body 1", image: "assets/images/onboard1.png"),
    OnBoardModelClass(
        title: "Title 2", body: "Body 2", image: "assets/images/onboard2.png"),
    OnBoardModelClass(
        title: "Title 3", body: "Body 3", image: "assets/images/onboard3.png"),
  ];

  bool isLastPage = false;

  onPageChanged({required index}){
    if(pages.length - 1 == index){
      isLastPage = true;
    }
    else{
      isLastPage = false;
    }
    emit(ChangeOnboardPageState());
  }
}
