import '../../domain/entities/doctor.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../data_sourses/json_data_source.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final JsonDataSource dataSource;

  DoctorRepositoryImpl(this.dataSource);

  @override
  Future<List<Doctor>> getDoctors() async {
    final data = await dataSource.loadJsonData();
    return (data['doctors'] as List)
        .map((doctor) => Doctor.fromJson(doctor))
        .toList();
  }
}
