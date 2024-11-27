import '../../domain/entities/centers.dart';

abstract class MedicalCenterRepository {
  Future<List<MedicalCenter>> getMedicalCenters();
}
