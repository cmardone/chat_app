import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/services.dart';

class UsuariosPage extends StatelessWidget {
  final _refreshController = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usersService = Provider.of<UsersService>(context);

    void _onRefresh() async {
      try {
        await usersService.getUsers();
        _refreshController.refreshCompleted();
      } catch (e) {
        print(e);
        _refreshController.refreshFailed();
      }
    }

    ListTile _usuarioListTile(User user) {
      return ListTile(
        leading: CircleAvatar(
          child: Text(user.name.substring(0, 1)),
          backgroundColor: Colors.blue[100],
        ),
        onTap: () async {
          final chatService = Provider.of<ChatService>(context, listen: false);
          await chatService.setUser(user);
          Navigator.pushNamed(context, 'chat');
        },
        subtitle: Text(user.email),
        title: Text(user.name),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: user.online ? Colors.green[300] : Colors.red,
          ),
          height: 10,
          width: 10,
        ),
      );
    }

    ListView usuariosListView(List<User> usuarios) {
      return ListView.separated(
        itemBuilder: (context, index) => _usuarioListTile(usuarios[index]),
        itemCount: usuarios.length,
        separatorBuilder: (_, index) => Divider(),
        physics: BouncingScrollPhysics(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
            margin: EdgeInsets.only(right: 10),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            authService.logout();
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        title: Text(authService.user?.name ?? '',
            style: TextStyle(color: Colors.black54)),
      ),
      body: SmartRefresher(
        child: usuariosListView(usersService.users),
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
}
