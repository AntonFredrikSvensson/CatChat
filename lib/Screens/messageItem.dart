import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_chat/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MessageItem extends StatefulWidget {

  final int index;
  final DocumentSnapshot document;
  final String id;
  final bool isLastMessageRight;
  final bool isLastMessageLeft;
  final String peerAvatar;
  
  MessageItem({this.index, this.document, this.id, this.isLastMessageLeft, this.isLastMessageRight, this.peerAvatar});

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.document['idFrom'] == widget.id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Container(
            child: Image.network(
              widget.document['content'],
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: widget.isLastMessageRight ? 20.0 : 10.0, right: 10.0),
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
                widget.isLastMessageLeft
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
                    widget.document['content'],
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: widget.isLastMessageRight ? 20.0 : 10.0,
                      right: 10.0),
                ),
              ],
            ),

            // Time
            widget.isLastMessageLeft
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.document['timestamp']))),
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
}