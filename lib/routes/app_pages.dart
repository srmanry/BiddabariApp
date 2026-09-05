import 'package:get/get.dart';

import '../features/course_details/binding/course_details_binding.dart';
import '../features/course_details/presentation/screens/course_details_screen.dart';
import '../features/home/binding/home_binding.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '${AppRoutes.courseDetails}/:id',
      page: () => const CourseDetailsScreen(),
      binding: CourseDetailsBinding(),
    ),
  ];
}
