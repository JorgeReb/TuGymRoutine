import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/services/exercise_service.dart';

class HistoryUserWorkouts extends StatelessWidget {
  final Usuario user;
  
  const HistoryUserWorkouts({super.key, required this.user});

  Future getHistoryUserWorkouts() async{
    return await ExerciseService().getHistoryUserWorkoutsById(user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInDown(
        child: FutureBuilder(
          future: getHistoryUserWorkouts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(padding: EdgeInsets.only(top: 50),child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',style: TextStyle(color: Theme.of(context).colorScheme.secondary));
            } else {
              Map<String, dynamic> datos = snapshot.data;
              return SizedBox(
                height: 700,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: datos.length,
                  itemBuilder: (context, index) {
                    String documentId = datos.keys.elementAt(index);
                    Map<String, dynamic> data = datos[documentId];   
                    List<String> exerciseIds = [];
                    for (var i = 1; i < data['exercises'].length+1; i++) {
                      exerciseIds.add(data['exercises']['$i']?['id']);
                    }
                    return Column(
                      children: [
                        ListTile( 
                          title: Text('${data['workout_name']}\n', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600, fontSize: 20, fontStyle: FontStyle.italic)),
                          subtitle: 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 1; i < data['exercises'].length+1; i++)  
                              ...[
                              Text('${data['exercises']['$i']?['name']}', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w400)),
                              const SizedBox(height: 5),
                              for(var j = 1; j < data['exercises']['$i']?['series'].length; j++ )
                                if(data['exercises']['$i']['series']['$j'] != null)
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('${data['exercises']['$i']['series']['$j']?['kilos']} kg',style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w100) ),
                                        Text(' ${data['exercises']['$i']['series']['$j']?['repetitions']} reps',style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w100) ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 20),
                      ],
                    );
                  }                   
                ),
              );
            }
          }
        )
      ),
    );
  }
}