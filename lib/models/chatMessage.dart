// To parse this JSON data, do
//
//     final chatMessage = chatMessageFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
    ChatMessage({
        @required this.type,
        @required this.dbRowId,
        @required this.callback,
        @required this.id,
        @required this.parentId,
        @required this.message,
    });

    String? type;
    String? dbRowId;
    String? callback;
    int? id;
    int? parentId;
    String? message;

    factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        type: json["type"] == null ? null : json["type"],
        dbRowId: json["db_row_id"] == null ? null : json["db_row_id"],
        callback: json["callback"] == null ? null : json["callback"],
        id: json["id"] == null ? null : json["id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        message: json["message"] == null ? null : json["message"],
    );

    Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "db_row_id": dbRowId == null ? null : dbRowId,
        "callback": callback == null ? null : callback,
        "id": id == null ? null : id,
        "parent_id": parentId == null ? null : parentId,
        "message": message == null ? null : message,
    };
}
