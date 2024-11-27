import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../data_sourses/json_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final JsonDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Future<List<Category>> getCategories() async {
    final data = await dataSource.loadJsonData();
    return (data['categories'] as List)
        .map((category) => Category.fromJson(category))
        .toList();
  }
}
