import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/main_repository.dart';


final categoryRepositoryProvider = Provider.autoDispose<CategoryRepository>((ref) => CategoryRepository());
class AddCategory extends ConsumerWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryRepository = ref.watch(categoryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryCard(context, 'Books', 'assets/book1.jpg', categoryRepository),
            SizedBox(height: 20),
            _buildCategoryCard(context, 'Cars', 'assets/car1.jfif', categoryRepository),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, String imagePath, CategoryRepository categoryRepository) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed: () async {
            await categoryRepository.saveCategory(title, imagePath);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
