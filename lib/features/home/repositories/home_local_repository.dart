import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_frontend/features/home/model/song_model.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadLocalSong(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSongs() {
    List<SongModel> songs = [];

    for (final key in box.keys) {
      final song = SongModel.fromJson(box.get(key));
      songs.add(song);
    }

    return songs;
  }
}
