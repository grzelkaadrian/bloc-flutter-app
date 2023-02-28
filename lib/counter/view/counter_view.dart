import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app/counter/counter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../model/album.dart';

var num;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$num'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make requests for JSON objects')),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            state++;
            if (state > 0 && state <= 100) {
              num = state;
            } else {
              num = 1;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(22),
                  child: Text(
                    'min object number is 1, max is 100, do not go above or below it',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 90),
                  child: Text(
                    'Object number: $num',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                FutureBuilder<Album>(
                  future: fetchAlbum(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.title,
                        style: TextStyle(fontSize: 24),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(fontSize: 24),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.keyboard_arrow_left),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.keyboard_arrow_right),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
        ],
      ),
    );
  }
}
