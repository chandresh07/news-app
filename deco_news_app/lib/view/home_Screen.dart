


import 'package:cached_network_image/cached_network_image.dart';
import 'package:deco_news_app/models/news_channels_headlines_model.dart';
import 'package:deco_news_app/view/categories_screen.dart';
import 'package:deco_news_app/view/news_detail_screen.dart';
import 'package:deco_news_app/view_model/news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList { bbcNews, geographic, reuters, cnn}
class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu ;

  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-News';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.view_list_rounded)
          , onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesScreen()));
          }, ),
          title: Text("Deco News"),
          centerTitle: true,
          actions: [
            PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
                icon: Icon(Icons.more_vert,color: Colors.black,),
                onSelected: (FilterList item){
                if(FilterList.bbcNews.name== item.name){
                  name = 'bbc-News';
                }
                if(FilterList.geographic.name== item.name){
                  name = 'national-geographic';
                }
                if(FilterList.reuters.name== item.name){
                  name = 'reuters';
                }
                if(FilterList.cnn.name== item.name) {
                  name = 'cnn';
                }
               // newsViewModel.fetchNewsChannelsHeadlinesApi();
                setState(() {
                  selectedMenu = item;
                });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                  PopupMenuItem<FilterList>(
                      child: Text('BBC News'),
                    value: FilterList.bbcNews,
                  ),
                  PopupMenuItem<FilterList>(
                    child: Text('national-geographic'),
                    value: FilterList.geographic,
                  ),
                  PopupMenuItem<FilterList>(
                    child: Text('reuters'),
                    value: FilterList.reuters,
                  ),
                  PopupMenuItem<FilterList>(
                    child: Text('CNN'),
                    value: FilterList.cnn,
                  ),
                ]
            )
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              width: width,
              height: height * .55,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                            scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                              DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsDetailScreen(
                                  NewsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  NewsTitle: snapshot.data!.articles![index].title.toString(),
                                  NewsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description:snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString()
                              ))
                              );
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height : height * 0.6,
                                      width: width * .9,
                                      padding: EdgeInsets.symmetric(horizontal: height * .02,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(child: spinkit2,),
                                          errorWidget: (context,url,error)=> Icon(Icons.error_outline,color: Colors.red,),
                                        ),
                                      )
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        height: height * .22,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,),
                                                Text(format.format(datetime)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('General'),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                  NewsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  NewsTitle: snapshot.data!.articles![index].title.toString(),
                                  NewsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description:snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString()
                              )));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context, url) => Container(child: Center(
                                        child: SpinKitCircle(
                                          size: 50,
                                          color: Colors.blue,
                                        ),
                                      )
                                      ),
                                      //errorWidget: (context,url,error)=> Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                  Expanded(child:
                                  Container(
                                    height: height * .18,
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(snapshot.data!.articles![index].title.toString(),
                                          maxLines: 3,
                                          style: TextStyle(fontSize: 15,color: Colors.black54),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data!.articles![index].source!.name.toString(),
                                              style: TextStyle(fontSize: 11,color: Colors.black54),
                                            ),
                                            Text(format.format(datetime),
                                              style: TextStyle(fontSize: 11,color: Colors.black54),
                                            ),


                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}

  const spinkit2  = SpinKitFadingCircle(
    color: Colors.blue,
  );

