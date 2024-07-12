

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewsDetailScreen extends StatefulWidget{
final  String NewsImage , NewsTitle, NewsDate,author,description,content , source;
   const NewsDetailScreen({Key? key,
   required this.NewsImage,
   required this.NewsTitle,
   required this.NewsDate,
   required this.author,
     required this.description,
     required this.content,
   required this.source,

   }) : super (key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    DateTime dateTime = DateTime.parse(widget.NewsDate);
    return Scaffold(
      appBar: AppBar(
        title: Text("Deco News"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            height:  height * .45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(40)),
              child: CachedNetworkImage(
                imageUrl: widget.NewsImage,
                fit: BoxFit.cover,
                placeholder: (context ,url)=> Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(top: 20,right: 20,left: 20,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(40)),
            ),
            child: ListView(
                children: [
                  Text(widget.NewsTitle),
                  SizedBox(height: height * .02,),
                  Row(
                    children: [
                      Expanded(child: Text(widget.source)),
                      Text(format.format(dateTime)),
                    ],
                  ),
                  SizedBox(height: height * .03,),
                  Text(widget.description,
                  overflow: TextOverflow.visible ,),
                ],
            ),
          )
        ],
      ),
    );
  }
}