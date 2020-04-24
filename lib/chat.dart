import 'dart:async';
import 'dart:io';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_chat/Screens/messageList.dart';
import 'package:cat_chat/Screens/stickerSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cat_chat/const.dart';
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  Chat({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  // Widget buildItem(int index, DocumentSnapshot document) {
  //   if (document['idFrom'] == id) {
  //     // Right (my message)
  //     return Row(
  //       children: <Widget>[
  //         Container(
  //           child: Image.network(
  //             document['content'],
  //             width: 100.0,
  //             height: 100.0,
  //             fit: BoxFit.cover,
  //           ),
  //           margin: EdgeInsets.only(
  //               bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
  //         ),
  //       ],
  //       mainAxisAlignment: MainAxisAlignment.end,
  //     );
  //   } else {
  //     // Left (peer message)
  //     return Container(
  //       child: Column(
  //         children: <Widget>[
  //           Row(
  //             children: <Widget>[
  //               isLastMessageLeft(index)
  //                   ? Material(
  //                       child: CachedNetworkImage(
  //                         placeholder: (context, url) => Container(
  //                           child: CircularProgressIndicator(
  //                             strokeWidth: 1.0,
  //                             valueColor:
  //                                 AlwaysStoppedAnimation<Color>(themeColor),
  //                           ),
  //                           width: 35.0,
  //                           height: 35.0,
  //                           padding: EdgeInsets.all(10.0),
  //                         ),
  //                         imageUrl: peerAvatar,
  //                         width: 35.0,
  //                         height: 35.0,
  //                         fit: BoxFit.cover,
  //                       ),
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(18.0),
  //                       ),
  //                       clipBehavior: Clip.hardEdge,
  //                     )
  //                   : Container(width: 35.0),
  //               Container(
  //                 child: Image.network(
  //                   document['content'],
  //                   width: 100.0,
  //                   height: 100.0,
  //                   fit: BoxFit.cover,
  //                 ),
  //                 margin: EdgeInsets.only(
  //                     bottom: isLastMessageRight(index) ? 20.0 : 10.0,
  //                     right: 10.0),
  //               ),
  //             ],
  //           ),

  //           // Time
  //           isLastMessageLeft(index)
  //               ? Container(
  //                   child: Text(
  //                     DateFormat('dd MMM kk:mm').format(
  //                         DateTime.fromMillisecondsSinceEpoch(
  //                             int.parse(document['timestamp']))),
  //                     style: TextStyle(
  //                         color: greyColor,
  //                         fontSize: 12.0,
  //                         fontStyle: FontStyle.italic),
  //                   ),
  //                   margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
  //                 )
  //               : Container()
  //         ],
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //       ),
  //       margin: EdgeInsets.only(bottom: 10.0),
  //     );
  //   }
  // }

  // bool isLastMessageLeft(int index) {
  //   if ((index > 0 &&
  //           listMessage != null &&
  //           listMessage[index - 1]['idFrom'] == id) ||
  //       index == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // bool isLastMessageRight(int index) {
  //   if ((index > 0 &&
  //           listMessage != null &&
  //           listMessage[index - 1]['idFrom'] != id) ||
  //       index == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              //buildListMessage(),
              MessageList(id: id, peerId: peerId, peerAvatar: peerAvatar, groupChatId: groupChatId, listScrollController: listScrollController,),

              // Sticker
              (isShowSticker
                  ? StickerSelectionList(
                      id: id,
                      peerId: peerId,
                      groupChatId: groupChatId,
                      listScrollController: listScrollController,
                    )
                  : Container()),
              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.pets),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  // Widget buildListMessage() {
  //   return Flexible(
  //     child: groupChatId == ''
  //         ? Center(
  //             child: CircularProgressIndicator(
  //                 valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
  //         : StreamBuilder(
  //             stream: Firestore.instance
  //                 .collection('messages')
  //                 .document(groupChatId)
  //                 .collection(groupChatId)
  //                 .orderBy('timestamp', descending: true)
  //                 .limit(20)
  //                 .snapshots(),
  //             builder: (context, snapshot) {
  //               if (!snapshot.hasData) {
  //                 return Center(
  //                     child: CircularProgressIndicator(
  //                         valueColor:
  //                             AlwaysStoppedAnimation<Color>(themeColor)));
  //               } else {
  //                 listMessage = snapshot.data.documents;
  //                 return ListView.builder(
  //                   padding: EdgeInsets.all(10.0),
  //                   itemBuilder: (context, index) =>
  //                       buildItem(index, snapshot.data.documents[index]),
  //                   itemCount: snapshot.data.documents.length,
  //                   reverse: true,
  //                   controller: listScrollController,
  //                 );
  //               }
  //             },
  //           ),
  //   );
  // }
}
