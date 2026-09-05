import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/storage_keys.dart';
import '../models/course_model.dart';

class HomeRepository {
  final Dio _dio = ApiClient.dio;
  final GetStorage _storage = GetStorage();

  Future<List<CourseModel>> fetchCourses() async {
    try {
      final response = await _dio.get('app-home-courses');
      final data = response.data as Map<String, dynamic>;
      final list = (data['courses'] as List<dynamic>? ?? [])
          .map((e) => CourseModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      await _cacheCourses(list);
      return list;
    } on DioException {
      final cached = getCachedCourses();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  Future<void> _cacheCourses(List<CourseModel> courses) async {
    await _storage.write(
      StorageKeys.homeCourses,
      courses.map((c) => c.toJson()).toList(),
    );
    await _storage.write(
      StorageKeys.homeCoursesFetchedAt,
      DateTime.now().toIso8601String(),
    );
  }

  List<CourseModel>? getCachedCourses() {
    final raw = _storage.read(StorageKeys.homeCourses);
    if (raw == null) return null;
    return (raw as List<dynamic>)
        .map((e) => CourseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  DateTime? getCacheTimestamp() {
    final raw = _storage.read(StorageKeys.homeCoursesFetchedAt);
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }
}
