
import 'package:flutter/material.dart';
import 'package:news_app/services/favorite_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String source;
  final String time;

  const ArticleDetailScreen({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.source,
    required this.time,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {

  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  /// CHECK IF ALREADY SAVED
  void checkFavorite() async {
    bool saved = await FavoriteService.isFavorite(widget.title);

    setState(() {
      isSaved = saved;
    });
  }

  /// TOGGLE FAVORITE
  void toggleFavorite() async {

    if (isSaved) {

      await FavoriteService.removeFavorite(widget.title);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from favorites")),
      );

    } else {

      await FavoriteService.addFavorite({
        "image": widget.image,
        "category": widget.source,
        "title": widget.title,
        "time": widget.time,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved to favorites")),
      );
    }

    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [

          /// FAVORITE ICON
          IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : Colors.black,
            ),
            onPressed: toggleFavorite,
          ),

          /// SHARE
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            Image.network(
              widget.image.isNotEmpty
                  ? widget.image
                  : "https://via.placeholder.com/400x200.png?text=No+Image",
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// SOURCE + TIME
                  Row(
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.source.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        widget.time,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// TITLE
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  Text(
                    widget.description.isNotEmpty
                        ? widget.description
                        : "No description available for this article.",
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.7,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// QUOTE BLOCK
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: const Border(
                        left: BorderSide(
                          color: Colors.blue,
                          width: 4,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Stay informed with trusted news sources and verified information.",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// TAGS
                  Wrap(
                    spacing: 8,
                    children: [
                      chip("News"),
                      chip("Trending"),
                      chip("Latest"),
                    ],
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            )
          ],
        ),
      ),

      /// BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              children: const [
                Icon(Icons.comment_outlined),
                SizedBox(width: 6),
                Text("Comments"),
              ],
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text("Read More"),
            )
          ],
        ),
      ),
    );
  }

  /// TAG CHIP
  static Widget chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey.shade200,
    );
  }
}