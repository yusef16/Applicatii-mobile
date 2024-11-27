import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategory {
  final CategoryRepository repository;

  GetCategory(this.repository);

  Future<List<Category>> call() {
    return repository.getCategories();
  }
}
