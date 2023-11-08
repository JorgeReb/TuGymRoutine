import 'package:flutter/material.dart';
import 'package:tu_gym_routine/models/usuario.dart';


class UserPage extends StatefulWidget {

  const UserPage({super.key} );

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Usuario? user;

  @override
  void initState() {
    super.initState();
 
  }

  @override
  void dispose() {
    user = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Text(
            'User View',
            
          ),
          const SizedBox(height: 10),
          if (user == null)
            
          if(user != null)
          const _UserViewBody(),
        ],
      ),
    );
  }
}

class _UserViewBody extends StatelessWidget {
  const _UserViewBody();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: FixedColumnWidth(250)},
      children: const [
        TableRow(children: [
          _AvatarContainer(),
          _UserViewForm(),
        ])
      ],
    );
  }
}

class _UserViewForm extends StatelessWidget {
  const _UserViewForm();

  @override
  Widget build(BuildContext context) {
   
   
    return  Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
                
               
            ), 
            const SizedBox( 
              height: 20,
            ),
            TextFormField(
             
            ),
            const SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),

              //*boton de guardar
              child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.save_outlined,
                        size: 20,
                      ),
                      Text('Guardar')
                    ],
                  )),
            ),
          ],
        ),

    );
  }
}

class _AvatarContainer extends StatelessWidget {
  const _AvatarContainer();

  @override
  Widget build(BuildContext context) {


    return  SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text('Profile', ),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 160,
              child: Stack(
                children: [
                   ClipOval(
                    
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Colors.indigo,
                        elevation: 0,
                        child: const Icon(Icons.camera_alt_outlined, size: 20),
                        onPressed: () {
                          

                         
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Jorge",
              style:  TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
    );
  }
}
