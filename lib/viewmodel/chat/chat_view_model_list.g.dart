part of 'chat_view_model_list.dart';

mixin _$ChatListState on ChatListVM, Store {
  final _$messageStatusAtom = Atom(name: 'ChatListVM.messageStatus');

  @override
  MessageStatus get messageStatus {
    _$messageStatusAtom.reportRead();
    return super.messageStatus;
  }

  @override
  set messageStatus(MessageStatus value) {
    _$messageStatusAtom.reportWrite(value, super.messageStatus, () {
      super.messageStatus = value;
    });
  }

  final _$messageListAtom = Atom(name: 'ChatListVM.messageList');

  @override
  ObservableList<ChatViewModel> get messageList {
    _$messageListAtom.reportRead();
    return super.messageList;
  }

  @override
  set messageList(ObservableList<ChatViewModel> value) {
    _$messageListAtom.reportWrite(value, super.messageList, () {
      super.messageList = value;
    });
  }

  final _$fetchMessageAsyncAction = AsyncAction('ChatListVM.fetchMessage');

  @override
  Future<void> fetchMessage(String receiverID) {
    return _$fetchMessageAsyncAction.run(() => super.fetchMessage(receiverID));
  }

  final _$ChatListVMActionController = ActionController(name: 'ChatListVM');

  @override
  dynamic addMessage({String message, bool isMy, bool isImage}) {
    final _$actionInfo =
        _$ChatListVMActionController.startAction(name: 'ChatListVM.addMessage');
    try {
      return super.addMessage(message: message, isMy: isMy, isImage: isImage);
    } finally {
      _$ChatListVMActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
          messageStatus: $messageStatus,
          messageList: $messageList
        ''';
  }
}
