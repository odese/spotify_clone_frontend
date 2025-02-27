// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SongModel {
  final String id;
  final String song_name;
  final String artist;
  final String thumbnail_url;
  final String song_url;
  final String hex_code;
  SongModel({
    required this.id,
    required this.song_name,
    required this.artist,
    required this.thumbnail_url,
    required this.song_url,
    required this.hex_code,
  });


  SongModel copyWith({
    String? id,
    String? song_name,
    String? artist,
    String? thumbnail_url,
    String? song_url,
    String? hex_code,
  }) {
    return SongModel(
      id: id ?? this.id,
      song_name: song_name ?? this.song_name,
      artist: artist ?? this.artist,
      thumbnail_url: thumbnail_url ?? this.thumbnail_url,
      song_url: song_url ?? this.song_url,
      hex_code: hex_code ?? this.hex_code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': song_name,
      'artist': artist,
      'thumbnail_url': thumbnail_url,
      'song_url': song_url,
      'hex_code': hex_code,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: (map['id'] ?? '') as String,
      song_name: (map['song_name'] ?? '') as String,
      artist: (map['artist'] ?? '') as String,
      thumbnail_url: (map['thumbnail_url'] ?? '') as String,
      song_url: (map['song_url'] ?? '') as String,
      hex_code: (map['hex_code'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) => SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, song_name: $song_name, artist: $artist, thumbnail_url: $thumbnail_url, song_url: $song_url, hex_code: $hex_code)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.song_name == song_name &&
      other.artist == artist &&
      other.thumbnail_url == thumbnail_url &&
      other.song_url == song_url &&
      other.hex_code == hex_code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      song_name.hashCode ^
      artist.hashCode ^
      thumbnail_url.hashCode ^
      song_url.hashCode ^
      hex_code.hashCode;
  }
}
