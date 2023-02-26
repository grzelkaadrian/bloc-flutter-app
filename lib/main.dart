import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './models/json.dart';

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ScaffoldWidget());
  }
}

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bloc Test'),
          actions: const [
            Icon(Icons.home),
          ],
        ),
        body: const BodyWidget());
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({
    super.key,
  });

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Text('');
          }
        },
      ),
    );
  }
}
