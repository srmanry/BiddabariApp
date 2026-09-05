import 'package:get/get.dart';

import '../data/repository/home_repository.dart';
import '../logic/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepository());
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
