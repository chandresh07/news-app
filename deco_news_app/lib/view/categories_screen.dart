

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deco_news_app/models/categories_news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../view_model/news_view_model.dart';
import 'home_Screen.dart';
import 'news_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});


  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMMM dd, yyyy');

  String categoryName = 'General';

  List<String> categoriesList =[
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        title:  Text("Deco News"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: categoriesList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                     categoryName = categoriesList[index];
                     setState(() {
                     });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: categoryName == categoriesList[index] ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child:Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Center(child: Text(categoriesList[index].toString(),
                          style: TextStyle(color: Colors.white,fontSize: 13),)),
                        ),
                      ),
                    ),
                  );
                  }
                  ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
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
                              padding: EdgeInsets.only(bottom: 15,),
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
                                        )
                                      )
                                      ),
                                      errorWidget: (context,url,error)=> Icon(Icons.error_outline,color: Colors.red,),
                                    ),
                                  ),
                                  Expanded(child:
                                  Container(
                                    height: height * .18,
                                    padding: EdgeInsets.only(left:10),
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
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Text(format.format(datetime),
                                                style: TextStyle(fontSize: 11,color: Colors.black54),
                                              ),
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
        ),
      ),
    );
  }}
