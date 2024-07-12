




import 'package:deco_news_app/models/news_channels_headlines_model.dart';
import 'package:deco_news_app/repository/news_repository.dart';

import '../models/categories_news_model.dart';

class NewsViewModel {
  final _rep  = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String channelName) async {
    final response = await _rep.fetchNewsChannelsHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel>fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}