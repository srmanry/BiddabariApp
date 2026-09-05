import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../data/models/course_model.dart';
import '../data/repository/home_repository.dart';

class HomeController extends GetxController with StateMixin<List<CourseModel>> {
  final HomeRepository _repository;

  HomeController(this._repository);

  List<CourseModel> get courses => state ?? [];
  final isOffline = false.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasOffline = false;

  @override
  void onInit() {
    super.onInit();
    _loadCachedThenFetch();
    _watchConnectivity();
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    super.onClose();
  }

  void _watchConnectivity() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) {
      final offline = results.every((r) => r == ConnectivityResult.none);
      isOffline.value = offline;
      if (_wasOffline && !offline) {
        fetchCourses(silent: true);
      }
      _wasOffline = offline;
    });
  }

  Future<void> _loadCachedThenFetch() async {
    final cached = _repository.getCachedCourses();
    if (cached != null && cached.isNotEmpty) {
      change(cached, status: RxStatus.success());
      await fetchCourses(silent: true);
    } else {
      await fetchCourses(silent: false);
    }
  }

  Future<void> fetchCourses({bool silent = false}) async {
    if (!silent) {
      change(state, status: RxStatus.loading());
    }
    try {
      final result = await _repository.fetchCourses();
      change(
        result,
        status: result.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (e) {
      if (courses.isEmpty) {
        change(
          null,
          status: RxStatus.error(
            'কোর্স লোড করা যায়নি। ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।',
          ),
        );
      }
    }
  }

  Future<void> reload() => fetchCourses();
}
