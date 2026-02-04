import 'package:flutter/material.dart';
import '../../data/repositories/practice_repository.dart';
import '../pages/practice_page.dart';

class AthkarSearchDelegate extends SearchDelegate {
  final PracticeRepository repository;

  AthkarSearchDelegate({required this.repository});

  @override
  String get searchFieldLabel => 'ابحث في الأذكار...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('ابحث عن دعاء أو ذكر', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<AthkarSearchResult>>(
      future: repository.searchAthkar(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return const Center(child: Text('لا توجد نتائج'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return ListTile(
              title: Text(
                result.item.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                result.categoryTitle,
                style: TextStyle(color: Colors.grey[600]),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PracticePage(
                      categoryId: result.categoryId,
                      title: result.categoryTitle,
                      initialItemId: result.item.id,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
