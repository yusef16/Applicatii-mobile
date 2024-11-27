import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';
import '../data_sourses/json_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final JsonDataSource dataSource;

  BannerRepositoryImpl(this.dataSource);

  @override
  Future<List<BannerData>> getBanners() async {
    try {
      final data = await dataSource.loadJsonData();
      final bannersJson = data['banners'] as List<dynamic>?;

      if (bannersJson == null) {
        throw Exception("Banners data not found in JSON");
      }

      return bannersJson
          .map((banner) => BannerData.fromJson(banner as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error loading banners: $e");
      throw Exception("Failed to load banners");
    }
  }
}
