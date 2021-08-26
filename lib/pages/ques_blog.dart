import 'package:flutter/material.dart';
import 'package:queschat/components/ques_blog_adapter.dart';

class QuesBlog extends StatefulWidget {
  @override
  _QuesBlogState createState() => _QuesBlogState();
}

class _QuesBlogState extends State<QuesBlog> {
  List<QuesBlogGS> quesBlogGSs =new List<QuesBlogGS>();
  @override
  Widget build(BuildContext context) {
    quesBlogGSs.add(new QuesBlogGS("But I must explain to you how all this mistaken idea of","1h ago","https://kmeducationhub.de/wp-content/uploads/2014/08/wc-knowledgemanagement-conferences.jpg"));
    quesBlogGSs.add(new QuesBlogGS("But I must explain to you how all this mistaken idea of","1h ago","https://kmeducationhub.de/wp-content/uploads/2014/08/wc-knowledgemanagement-conferences.jpg"));
    quesBlogGSs.add(new QuesBlogGS("But I must explain to you how all this mistaken idea of","1h ago","https://kmeducationhub.de/wp-content/uploads/2014/08/wc-knowledgemanagement-conferences.jpg"));
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: quesBlogGSs.length,
          itemBuilder: (BuildContext context,int index){
      return QuesBlogAdapter(quesBlogGSs[index]);
      }),
    );
  }
}
