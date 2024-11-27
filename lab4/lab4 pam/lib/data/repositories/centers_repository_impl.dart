import '../../domain/entities/centers.dart';
import '../../domain/repositories/centers_repository.dart';
import '../data_sourses/json_data_source.dart';

class MedicalCenterRepositoryImpl implements MedicalCenterRepository {
  final JsonDataSource dataSource;

  MedicalCenterRepositoryImpl(this.dataSource);

  @override
  Future<List<MedicalCenter>> getMedicalCenters() async {
    final data = await dataSource.loadJsonData();
    return (data['nearby_centers'] as List)
        .map((center) => MedicalCenter.fromJson(center))
        .toList();
  }
}
