import '../../core/base_state.dart';
import '../../core/get_it.dart';
import '../../helper/preferences_helper.dart';
import '../../helper/socket_helper.dart';
import '../../viewmodel/shuffle/shuffle_view_model_list.dart';
import '../../views/shuffle/list.dart';
import '../../views/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ShuffleView extends StatefulWidget {
  @override
  _ShuffleViewState createState() => _ShuffleViewState();
}

class _ShuffleViewState extends BaseState<ShuffleView> {
  var shuffleVM = getIt<ShufListState>();

  Widget _buildShuffleList(ShuffleListVM vm) {
    return Observer(builder: (context) {
      switch (vm.status) {
        case ListStatus.loading:
          return Center(child: CircularProgressIndicator());
          break;
        case ListStatus.loaded:
          return ShuffleList();
          break;
        case ListStatus.empty:
          return Center(
            child: Text("Dados não disponíveis"),
          );
          break;
        default:
          return Container();
      }
    });
  }

  @override
  void initState() {
    SocketHelper.shared.connectSocket();
    shuffleVM.fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chat app'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await SharedPreferencesHelper.shared.removeToken();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignInView()),
                    (route) => false);
              })
        ],
      ),
      body: _buildShuffleList(shuffleVM),
    );
  }
}
