import 'package:cat_chat/Services/chatService.dart';
import 'package:cat_chat/const.dart';
import 'package:cat_chat/models/gifs.dart';
import 'package:flutter/material.dart';


class StickerSelectionList extends StatefulWidget {
  final String id;
  final String peerId;
  final String groupChatId;
  final ScrollController listScrollController;
  StickerSelectionList({this.id, this.peerId, this.groupChatId, this.listScrollController});

  @override
  _StickerSelectionListState createState() => _StickerSelectionListState();
}

class _StickerSelectionListState extends State<StickerSelectionList> {

  final List<Gif> gifsList = gifs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(gifsList.length, (index) {
          return FlatButton(
              onPressed: () => ChatService(id: widget.id, peerId: widget.peerId, groupChatId: widget.groupChatId).sendMessage(gifsList[index].url, 3, widget.listScrollController),
              child: Center(
              child: Image.network(
                gifsList[index].url,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }
}