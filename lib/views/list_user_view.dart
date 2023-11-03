import 'package:flutter/material.dart';
import 'package:tu_gym_routine/models/user.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/widgets/utils.dart';


class ListUserView extends StatelessWidget {
  const ListUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder (
          future: UserService().getUsers(), 
          builder: (context, snapshot) {
            if (snapshot.hasData) {
               final List<Usuario> users = [];
                for (var user in snapshot.data!) {
                  users.add(user);
                }
                return buildDataTable(users);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          },),
      )
    );
  }

  
  Widget buildDataTable(List<Usuario> users) {
    final columns = ['Nombre', 'Email'];
    return DataTable(
      dividerThickness: 2,
      dataRowColor: MaterialStatePropertyAll(Colors.grey.shade200),
      columns: getColumns(columns), 
      rows: getRows(users)
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(column, style: const TextStyle(fontStyle: FontStyle.italic),),
          ),
        ),
      );
    }).toList();
  }

  List<DataRow> getRows(List<Usuario> users) => users.map((Usuario user) {
    final cells = [user.name, user.email];
    return DataRow(
      cells: Utils.modelBuilder(cells, (index, cell){
        return DataCell(Align(
          alignment: Alignment.center,
          child: Text(cell)));
      }),
    );
  }).toList(); 
}
