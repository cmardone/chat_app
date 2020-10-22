import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/user.dart';

class UsuariosPage extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuarios = <User>[
      User(
          id: 'c43c7640-8ccb-41e5-8f2a-ca82e5a407aa',
          name: 'Cristóbal Mardones Bucarey',
          email: 'cmardone@gmail.com',
          online: true),
      User(
          id: '3a0e3bab-4f2b-4870-82ad-b44144a1547a',
          name: 'Emilia Mardones Jiménez',
          email: 'emiliamardonej@gmail.com',
          online: false),
      User(
          id: 'b27dd7a9-5fce-41df-83d3-b7f35e2783a6',
          name: 'Domingo Mardones Jiménez',
          email: 'domingomardonesj@gmail.com',
          online: true),
      User(
          id: 'e91c4c2e-7e4f-40b1-b3db-b5899433d3d4',
          name: 'Daniela Jiménez Castro',
          email: 'daanjica27@gmail.com',
          online: false),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            child: Icon(Icons.offline_bolt, color: Colors.red),
            // child: Icon(Icons.check_circle, color: Colors.blue[400]),
            margin: EdgeInsets.only(right: 10),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        title: Text(authService.user?.name ?? '',
            style: TextStyle(color: Colors.black54)),
      ),
      body: SmartRefresher(
        child: usuariosListView(usuarios),
        controller: _refreshController,
        enablePullDown: true,
        header: ClassicHeader(
          refreshingText: 'Cargando...',
          completeText: 'Actualización terminada',
          failedText: 'Actualización fallida',
          releaseText: 'Suelte para actualizar',
          idleText: 'Dislice hacia abajo',
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  ListView usuariosListView(List<User> usuarios) {
    return ListView.separated(
      itemBuilder: (context, index) => _usuarioListTile(usuarios[index]),
      itemCount: usuarios.length,
      separatorBuilder: (_, index) => Divider(),
      physics: BouncingScrollPhysics(),
    );
  }

  ListTile _usuarioListTile(User usuario) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(usuario.name.substring(0, 1)),
        backgroundColor: Colors.blue[100],
      ),
      subtitle: Text(usuario.email),
      title: Text(usuario.name),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: usuario.online ? Colors.green[300] : Colors.red,
        ),
        height: 10,
        width: 10,
      ),
    );
  }
}
