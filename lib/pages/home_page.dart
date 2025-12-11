import 'dart:convert';

import 'package:appmovie/services/api_services.dart';
import 'package:appmovie/ui/widgets/item_movie_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../models/movie_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List movies = [];
  List<MovieModel> moviesList = [];
  APIServices _apiServices = APIServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{

    moviesList= await _apiServices.getMovies();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xff161823),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: moviesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemMovieListWidget(movieModel: moviesList[index]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
