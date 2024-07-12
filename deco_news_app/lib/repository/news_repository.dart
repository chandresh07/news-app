
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/categories_news_model.dart';
import '../models/news_channels_headlines_model.dart';

class NewsRepository{

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String channelName)async{
    String url = "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=42b557ea6d0e4bf18997232c48e4db5e";
       // "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=42b557ea6d0e4bf18997232c48e4db5e";
    print(url);
    // "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=42b557ea6d0e4bf18997232c48e4db5e";
    //"https://newsapi.org/v2/everything?q=cricket&sortBy=publishedAt&apiKey=f217beb8b57140f79bf1a442777bc85f";

    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);

    }
    throw Exception("Error");
  }


  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    String url = "https://newsapi.org/v2/everything?q=${category}&apiKey=42b557ea6d0e4bf18997232c48e4db5e";

    final response = await http.get(Uri.parse(url));
    if(kDebugMode){
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);

    }
    throw Exception("Error");
  }
}