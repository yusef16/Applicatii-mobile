import '../entities/banner.dart';

abstract class BannerRepository {
  Future<List<BannerData>> getBanners(); // Change to BannerData
}
