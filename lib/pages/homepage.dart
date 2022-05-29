import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinem_app/bloc/moviebloc/movie_bloc.dart';
import 'package:cinem_app/bloc/moviebloc/movie_bloc_event.dart';
import 'package:cinem_app/bloc/moviebloc/movie_bloc_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cinem_app/main.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/movie.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = ['Surabaya', 'Malang', 'Jakarta', 'Bandung'];

  String? value;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
            create: (_) => MovieBloc()
              ..add(
                MovieEventStarted(0, ''),
              ),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 49, 82, 87),
            elevation: 0,
            title: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Hello William',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 20),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
              )
            ],
            flexibleSpace: Container(
              margin: const EdgeInsets.only(top: 50, left: 20),
              child: Row(children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Flexible(
                    flex: 6,
                    child: Container(
                      height: 20,
                      width: 100,
                      child: DropdownButton<String>(
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return items.map((String value) {
                            return Text(
                              value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            );
                          }).toList();
                        },
                        value: value,
                        iconSize: 24,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        items: items.map(buildMenuItem).toList(),
                        onChanged: (value) =>
                            setState(() => this.value = value),
                      ),
                    ))
              ]),
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      //  padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color.fromARGB(255, 49, 82, 87),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              Icon(Icons.search,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              Expanded(
                                child: Text(
                                  "Search Movies",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                )),
          ),
          body: _buildBody(context),
          backgroundColor: Color.fromARGB(255, 49, 82, 87),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<MovieBloc, MovieState>(
                builder: ((context, state) {
                  if (state is MovieLoading) {
                    return Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator()
                          : CupertinoActivityIndicator(),
                    );
                  } else if (state is MovieLoaded) {
                    List<Movie> movies = state.movieList;
                    print(movies.length);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider.builder(
                          itemCount: movies.length,
                          itemBuilder: (BuildContext context, int index) {
                            Movie movie = movies[index];
                            print(movie.backdropPath);
                            return Stack(
                              children: <Widget>[
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Platform.isAndroid
                                            ? CircularProgressIndicator()
                                            : CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              '../assets/images/no-image.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                )
                              ],
                            );
                          },
                          options: CarouselOptions(
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(microseconds: 500),
                            pauseAutoPlayOnTouch: true,
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text('MASIH ERROR!',
                          style: TextStyle(color: Colors.white)),
                    );
                  }
                }),
              )
            ],
          ),
        ),
      );
    });
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
      );
}
