class CourseModel {
  final int id;
  final String title;
  final String subTitle;
  final int price;
  final String banner;
  final int discountType;
  final int discountAmount;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final String durationInMonth;
  final String totalClass;
  final int totalExam;
  final int totalLive;

  const CourseModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.banner,
    required this.discountType,
    required this.discountAmount,
    required this.discountStartDate,
    required this.discountEndDate,
    required this.durationInMonth,
    required this.totalClass,
    required this.totalExam,
    required this.totalLive,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      subTitle: json['sub_title'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      banner: json['banner'] as String? ?? '',
      discountType: (json['discount_type'] as num?)?.toInt() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toInt() ?? 0,
      discountStartDate: _parseDate(json['discount_start_date']),
      discountEndDate: _parseDate(json['discount_end_date']),
      durationInMonth: json['duration_in_month']?.toString() ?? '',
      totalClass: json['total_class']?.toString() ?? '',
      totalExam: (json['total_exam'] as num?)?.toInt() ?? 0,
      totalLive: (json['total_live'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sub_title': subTitle,
      'price': price,
      'banner': banner,
      'discount_type': discountType,
      'discount_amount': discountAmount,
      'discount_start_date': discountStartDate?.toIso8601String(),
      'discount_end_date': discountEndDate?.toIso8601String(),
      'duration_in_month': durationInMonth,
      'total_class': totalClass,
      'total_exam': totalExam,
      'total_live': totalLive,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString().replaceFirst(' ', 'T'));
  }

  static const _brokenHost = 'https://api.biddabari.com';
  static const _cdnBase = 'https://storage.biddabari.online/biddabari-bucket';

  /// The API returns banner URLs on a host that 404s; the actual files are
  /// served from a separate storage CDN with the same path.
  String get bannerUrl => banner.startsWith(_brokenHost)
      ? banner.replaceFirst(_brokenHost, _cdnBase)
      : banner;

  int get discountedPrice => (price - discountAmount).clamp(0, price);

  bool get hasActiveDiscount {
    if (discountAmount <= 0 || discountEndDate == null) return false;
    final now = DateTime.now();
    if (discountStartDate != null && now.isBefore(discountStartDate!)) {
      return false;
    }
    return now.isBefore(discountEndDate!);
  }
}
