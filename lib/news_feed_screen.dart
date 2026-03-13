import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/article_detail_screen.dart';
import 'modles/news_model.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {

  List<NewsArticle> articles = [];
  bool loading = true;

  TextEditingController searchController = TextEditingController();

  String selectedCategory = "top";

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchNews({String query = "", String category = "top"}) async {

    setState(() {
      loading = true;
    });

    String url =
        "https://newsdata.io/api/1/latest?apikey=pub_57c4c2f3f9484a0ca7edf695f61bff87&language=en";

    if (category != "top") {
      url += "&category=$category";
    }

    if (query.isNotEmpty) {
      url += "&q=$query";
    }

    try {

      final response = await http.get(Uri.parse(url));

      final data = jsonDecode(response.body);

      List results = data["results"] ?? [];

      setState(() {
        articles = results.map((e) => NewsArticle.fromJson(e)).toList();
        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

      debugPrint("API Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),

      body: SafeArea(
        child: Column(
          children: [

            /// SEARCH HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xffE5E7EB)),
                ),
              ),
              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search news...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xffF3F4F6),
                      ),
                      onSubmitted: (value) {
                        fetchNews(query: value);
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      fetchNews(query: searchController.text);
                    },
                  )
                ],
              ),
            ),

            /// CATEGORY BAR
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [

                  categoryChip("All News", "top"),
                  categoryChip("World", "world"),
                  categoryChip("Technology", "technology"),
                  categoryChip("Sports", "sports"),
                  categoryChip("Business", "business"),
                  categoryChip("Health", "health"),

                ],
              ),
            ),

            /// NEWS LIST
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: articles.length,
                itemBuilder: (context, index) {

                  final article = articles[index];

                  return NewsCard(
                    image: article.image,
                    category: article.category,
                    title: article.title,
                    description: article.description,
                    time: article.time,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CATEGORY CHIP
  Widget categoryChip(String text, String category) {

    bool active = selectedCategory == category;

    return GestureDetector(
      onTap: () {

        setState(() {
          selectedCategory = category;
        });

        fetchNews(category: category);

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {

  final String image;
  final String category;
  final String title;
  final String description;
  final String time;

  const NewsCard({
    super.key,
    required this.image,
    required this.category,
    required this.title,
    required this.description,
    required this.time,
  });

  void openArticle(BuildContext context) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(
          image: image,
          title: title,
          description: description,
          source: category,
          time: time,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => openArticle(context),

      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                image.isNotEmpty
                    ? image
                    : "https://via.placeholder.com/400x200.png?text=No+Image",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// CATEGORY + TIME
                  Row(
                    children: [

                      Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 6),
                      const Text("•"),
                      const SizedBox(width: 6),

                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        icon: const Icon(Icons.open_in_full, size: 20),
                        onPressed: () => openArticle(context),
                      )
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// DESCRIPTION
                  Text(
                    description.isNotEmpty
                        ? description
                        : "No description available",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}