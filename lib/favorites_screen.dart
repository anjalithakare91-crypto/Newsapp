import 'package:flutter/material.dart';
import 'package:news_app/services/favorite_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  bool offlineOnly = false;

  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await FavoriteService.getFavorites();

    setState(() {
      favorites = data;
    });
  }

  void removeArticle(int index) async {

    await FavoriteService.removeFavorite(
      favorites[index]["title"] ?? "",
    );

    loadFavorites();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Removed from favorites")),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),

      /// HEADER
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: favorites.isEmpty
          ? emptyState()
          : Column(
        children: [

          /// Offline Toggle
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Only Offline Content",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Show only downloaded articles",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                Switch(
                  value: offlineOnly,
                  onChanged: (val) {
                    setState(() {
                      offlineOnly = val;
                    });
                  },
                )
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Favorites List
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadFavorites,
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {

                  final item = favorites[index];

                  return Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 1),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item["image"] ??
                                "https://via.placeholder.com/150",
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [

                                  Text(
                                    (item["category"] ?? "News")
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),

                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius:
                                      BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "Saved",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 6),

                              /// TITLE
                              Text(
                                item["title"] ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [

                                  Text(
                                    item["time"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      removeArticle(index);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),

      /// Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined), label: "News"),

          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Search"),

          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: "Saved"),

          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  /// EMPTY STATE
  Widget emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.bookmark_border,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              "No Favorites Yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Tap the bookmark icon on any article to save it for later.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}