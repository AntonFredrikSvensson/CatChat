import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_chat/Screens/messageItem.dart';
import 'package:cat_chat/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageList extends StatefulWidget {
  final String id;
  final String peerId;
  final String peerAvatar;
  final String groupChatId;
  final ScrollController listScrollController;

  MessageList({
    this.id,
    this.peerId,
    this.peerAvatar,
    this.groupChatId,
    this.listScrollController,
  });

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  var messageList;
  bool isLastMessageRight;
  bool isLastMessageLeft;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: widget.groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(widget.groupChatId)
                  .collection(widget.groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  messageList = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),

                    itemCount:snapshot.data.documents.length,
                    itemBuilder:(context, index){
                    isLastMessageRight = _isLastMessageRight(index);
                    isLastMessageLeft = _isLastMessageLeft(index);
                    // return buildItem(index, snapshot.data.documents[index], widget.id, isLastMessageRight,isLastMessageLeft);
                    return  MessageItem(index: index, document: messageList[index], id:widget.id, isLastMessageLeft: isLastMessageLeft, isLastMessageRight: isLastMessageRight,);
                    //this.index, this.document, this.id, this.isLastMessageLeft, this.isLastMessageRight, this.peerAvatar
                    },
                    reverse: true,
                    controller: widget.listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document, String id, bool isLastMessageRight, bool isLastMessageLeft) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Container(
            child: Image.network(
              document['content'],
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight ? 20.0 : 10.0, right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: widget.peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                Container(
                  child: Image.network(
                    document['content'],
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight ? 20.0 : 10.0,
                      right: 10.0),
                ),
              ],
            ),

            // Time
            isLastMessageLeft
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool _isLastMessageLeft(int index) {
    if ((index > 0 &&
            messageList != null &&
            messageList[index - 1]['idFrom'] == widget.id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool _isLastMessageRight(int index) {
    if ((index > 0 &&
            messageList != null &&
            messageList[index - 1]['idFrom'] != widget.id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
