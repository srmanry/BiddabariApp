import 'package:get/get.dart';

import '../logic/course_details_controller.dart';

class CourseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final courseId = int.tryParse(Get.parameters['id'] ?? '') ?? 0;
    Get.lazyPut<CourseDetailsController>(
      () => CourseDetailsController(courseId),
    );
  }
}
