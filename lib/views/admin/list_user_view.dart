import 'package:flutter/material.dart';

import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/pages/pages.dart';
import 'package:tu_gym_routine/services/user_service.dart';

class ListUserView extends StatefulWidget {
  const ListUserView({super.key});

  @override
  State<ListUserView> createState() => _ListUserViewState();
}

class _ListUserViewState extends State<ListUserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder<List<Usuario>>(
          future: getUsersList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userList = snapshot.data;
              return Column(
                children: [
                  UsersTable(users: userList!),
                ],
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<Usuario>> getUsersList() async {
  final List<Usuario> users =  await UserService().getUsers();

  final List<Usuario> userList = users.map((user) {
    return Usuario(id: user.id, name: user.name, email: user.email, weight: user.weight, height: user.height);
  }).toList();

  return userList;
}

class UsersTable extends StatefulWidget {
  final List<Usuario> users;
  const UsersTable({super.key, required this.users});

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  final TextEditingController _searchController = TextEditingController();
  final List<Usuario> _filteredUsuarios = [];

  @override
  void initState() {
    super.initState();
    _filteredUsuarios.addAll(widget.users);
  }

  void _filterUsuarios(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredUsuarios.clear();
        _filteredUsuarios.addAll(widget.users);
      });
    } else {
      final filteredUsuarios = widget.users.where((usuario) =>usuario.name.toLowerCase().contains(searchTerm.toLowerCase())).toList();
      setState(() {
        _filteredUsuarios.clear();
        _filteredUsuarios.addAll(filteredUsuarios);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = <DataColumn>[
      DataColumn(label: Padding(padding: const EdgeInsets.only(left:15.0),child: Text('Nombre', style: TextStyle(color: Theme.of(context).colorScheme.background),))),
      DataColumn(label: Padding(padding: const EdgeInsets.only(left:27.0),child: Text('Email', style: TextStyle(color: Theme.of(context).colorScheme.background),))),
      DataColumn(label: Text('Peso', style: TextStyle(color: Theme.of(context).colorScheme.background),)),
      DataColumn(label: Text('Altura', style: TextStyle(color: Theme.of(context).colorScheme.background),)),
      DataColumn(label: Text('Visualizar', style: TextStyle(color: Theme.of(context).colorScheme.background),)),
    ];

    final rows = _filteredUsuarios.map((user) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Padding(padding: const EdgeInsets.only(left: 8.0),child: Text(user.name, style: TextStyle(color: Theme.of(context).colorScheme.background)))),
          DataCell(Text(user.email, style: TextStyle(color: Theme.of(context).colorScheme.background))),
          DataCell(Padding(padding: const EdgeInsets.only(left: 5.0),child: Text(user.weight.toString(), style: TextStyle(color: Theme.of(context).colorScheme.background)),)),
          DataCell(Padding(padding: const EdgeInsets.only(left:10.0),child: Text(user.height.toString(), style: TextStyle(color: Theme.of(context).colorScheme.background)),)),
          DataCell(Padding(padding: const EdgeInsets.only(left:15.0),child: Icon(Icons.remove_red_eye_outlined, color: Theme.of(context).colorScheme.background,)
          ), 
          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => UserPage(user: user,)))
          ),
        ],
        
      );
    }).toList();

    return Column(
      children: [
        Padding(
          padding:
            const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            cursorColor: Theme.of(context).colorScheme.secondary,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
              labelText: 'Buscar por nombre',
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)),
            ),
            onChanged: (value) {
              _filterUsuarios(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: PaginatedDataTable(   
            arrowHeadColor: Theme.of(context).colorScheme.background,
            horizontalMargin: 25,
            columnSpacing: 45,
            columns: columns,
            source: _DataSource(rows),
            rowsPerPage: 5,         
          ),
        ),
      ],
    );
  }
}

class _DataSource extends DataTableSource {
  final List<DataRow> _rows;
  _DataSource(this._rows);

  @override
  DataRow? getRow(int index) {
    return index >= _rows.length ? null : _rows[index];
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
