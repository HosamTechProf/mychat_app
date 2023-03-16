import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat_app/modules/login/login_screen.dart';
import 'package:mychat_app/network/local/cache_helper.dart';
import 'package:mychat_app/shared/components.dart';
import 'package:mychat_app/shared/constants.dart';
import 'package:mychat_app/shared/cubit/onboard_cubit/onboard_cubit.dart';
import 'package:mychat_app/shared/cubit/onboard_cubit/onboard_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController pageController = PageController();

  void skipOnBoarding(BuildContext context){
    CacheHelper.saveData(key: "onBoarding", value: true).then((value){
      if(value!){
        navigateToAndKeep(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardCubit(),
      child: BlocConsumer<OnboardCubit, OnboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                TextButton(
                  onPressed: () {
                    skipOnBoarding(context);
                  },
                  child: Text("SKIP"),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView.builder(
                      onPageChanged: (index) {
                        OnboardCubit().get(context).onPageChanged(index: index);
                      },
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildOnBoardPageItem(
                          OnboardCubit().get(context).pages[index]),
                      itemCount: OnboardCubit().get(context).pages.length,
                      controller: pageController,
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Row(
                    children: [
                      SmoothPageIndicator(
                          controller: pageController,
                          count: OnboardCubit().get(context).pages.length,
                          effect: ExpandingDotsEffect(
                              activeDotColor: kPrimaryColor),
                          onDotClicked: (index) {}),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () {
                          if (OnboardCubit().get(context).isLastPage) {
                            skipOnBoarding(context);
                          } else {
                            pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn);
                          }
                        },
                        child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildOnBoardPageItem(OnBoardModelClass page) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(page.image),
        )),
        SizedBox(
          height: 20,
        ),
        Text(
          page.title,
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        Text(page.body)
      ],
    );

class OnBoardModelClass {
  final String title;
  final String body;
  final String image;

  OnBoardModelClass(
      {required this.title, required this.body, required this.image});
}
