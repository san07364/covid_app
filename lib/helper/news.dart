import 'package:http/http.dart' as http;
import 'package:covid_19/models/article.dart';
import 'dart:convert';

class News {
  List<Article> news = [];

  Future<List<Article>> getNews() async {
    String url =
        "http://newsapi.org/v2/top-headlines?q=COVID&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=763c677b02464078b7e49e0273d2ac1e";

    try {
      var response = await http.get(url);

      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            Article article = Article(
              title: element['title'],
              author: element['author'],
              description: element['description'],
              urlToImage: element['urlToImage'],
              publshedAt: DateTime.parse(element['publishedAt']),
              content: element["content"],
              articleUrl: element["url"],
            );
            news.add(article);
          }
        });
      }
    } catch (SocketException) {
      print("no data");
    }

    if (news.length > 0) {
      return news;
    } else {
      return null;
    }
  }
}
