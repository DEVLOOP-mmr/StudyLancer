import 'dart:convert';

import 'package:equatable/equatable.dart';

class Document extends Equatable {
  String? name;
  String? link;
  String? type;
  String? id;
  String? reqDocKey;
  Document({
    this.name,
    this.link,
    this.type,
    this.id,
    this.reqDocKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'link': link,
      'type': type,
      'id': id,
      'reqDocKey': reqDocKey,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      name: map['name'],
      link: map['link'],
      type: map['type'],
      id: map['id'],
      reqDocKey: map['reqDocKey'],
    );
  }

  String toJson() => json.encode(toMap());

  Document copyWith({
    String? name,
    String? link,
    String? type,
    String? id,
    String? reqDocKey,
  }) {
    return Document(
      name: name ?? this.name,
      link: link ?? this.link,
      type: type ?? this.type,
      id: id ?? this.id,
      reqDocKey: reqDocKey ?? this.reqDocKey,
    );
  }

  @override
  String toString() {
    return 'Document(name: $name, link: $link, type: $type, id: $id, reqDocKey: $reqDocKey)';
  }

  @override
  List<dynamic> get props {
    return [
      name,
      link,
      type,
      id,
      reqDocKey,
    ];
  }
}
