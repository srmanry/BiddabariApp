import 'package:get/get.dart';

import '../../home/data/models/course_model.dart';
import '../../home/logic/home_controller.dart';

class CourseDetailsController extends GetxController {
  final int courseId;

  CourseDetailsController(this.courseId);

  CourseModel? get course {
    final home = Get.find<HomeController>();
    return home.courses.firstWhereOrNull((c) => c.id == courseId);
  }
}
