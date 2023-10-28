import 'package:flutter/material.dart';

import 'package:tu_gym_routine/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsers(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return Text(snapshot.data?[index]['name']);
              
            }, 
          );
        }else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}