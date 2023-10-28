import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      sortColumnIndex: 2,
      sortAscending: false,
      columns: [
        DataColumn(label: Text("Nombre", style: TextStyle(color: Colors.white),)),
        DataColumn(label: Text("Apellido", style: TextStyle(color: Colors.white),)),
        DataColumn(label: Text("Años", style: TextStyle(color: Colors.white),), numeric: true),
      ],
      rows: [
        DataRow(selected: true, cells: [
          DataCell(Text("Andres" , style: TextStyle(color: Colors.white)), showEditIcon: true),
          DataCell(Text("Cruz", style: TextStyle(color: Colors.white),)),
          DataCell(Text("28", style: TextStyle(color: Colors.white),))
        ]),
        DataRow(cells: [
          DataCell(Text("Ramos", style: TextStyle(color: Colors.white),)),
          DataCell(Text("Ayu", style: TextStyle(color: Colors.white),)),
          DataCell(Text("999", style: TextStyle(color: Colors.white),))
        ])
      ],
    );
  }
}
