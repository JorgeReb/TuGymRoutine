import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tu_gym_routine/blocs/admin/admin_bloc.dart';
import 'package:tu_gym_routine/constants/constants.dart';
import 'package:tu_gym_routine/models/usuario.dart';
import 'package:tu_gym_routine/services/user_service.dart';
import 'package:tu_gym_routine/widgets/utils.dart';

class ListUserView extends StatefulWidget {
  const ListUserView({super.key});

  @override
  State<ListUserView> createState() => _ListUserViewState();
}

class _ListUserViewState extends State<ListUserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          final currentAdminToken = state.token;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FutureBuilder<List<Usuario>>(
              future: getUsersList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userList = snapshot.data;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10, left: 30,right: 30, bottom: 10),
                        child: TextField(
                          style: const TextStyle(color: primaryColor),
                          cursorColor: primaryColor,
                          decoration:
                              const InputDecoration(
                                labelText: 'Buscar por nombre',
                                labelStyle: TextStyle(color: primaryColor),
                                suffixIcon: Icon(Icons.account_circle_rounded, size: 30, color: primaryColor),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                ),
                          onChanged: (value) {},
                        ),
                      ),
                      PaginatedDataTable(
                        horizontalMargin: 15,
                        columns: const [
                          DataColumn(label: Text('NOMBRE')),
                          DataColumn(label: Text('EMAIL')),
                          DataColumn(label: Text('UID')),
                        ],
                        source: _UsuarioDataSource(userList!, context),
                        columnSpacing: 20,
                        rowsPerPage: 5,
                      ),
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
          );
        },
      ),
    );
  }
}

Future<List<Usuario>> getUsersList() async {
  final List<Usuario> users = await UserService().getUsers();

  final List<Usuario> userList = users.map((user) {
    return Usuario(id: user.id, name: user.name, email: user.email);
  }).toList();

  return userList;
}

class _UsuarioDataSource extends DataTableSource {
  final List<Usuario> _userList;
  final BuildContext context;

  _UsuarioDataSource(this._userList, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= _userList.length) return null;

    final user = _userList[index];
    return DataRow(cells: [
      DataCell(Text(user.name, style: const TextStyle(color: Colors.white),), onTap: () => Navigator.pushNamed(context,'/user'),),
      DataCell(Text(user.email, style: const TextStyle(color: Colors.white))),
      DataCell(Text(user.id, style: const TextStyle(color: Colors.white))),
    ],
    color: MaterialStateProperty.all(primaryColor.withOpacity(0.9))
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _userList.length;

  @override
  int get selectedRowCount => 0;
}
