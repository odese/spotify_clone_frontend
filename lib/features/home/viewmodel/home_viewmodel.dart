import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_frontend/core/providers/current_user_notifier.dart';
import 'package:spotify_clone_frontend/core/utils.dart';
import 'package:spotify_clone_frontend/features/home/model/song_model.dart';
import 'package:spotify_clone_frontend/features/home/repositories/home_local_repository.dart';
import 'package:spotify_clone_frontend/features/home/repositories/home_repository.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  // final token = ref.watch(currentUserNotifierProvider)!.token;
  final token = ref.watch(currentUserNotifierProvider.select((user) => user!.token));

  final res = await ref.watch(homeRepositoryProvider).getAllSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  // final token = ref.watch(currentUserNotifierProvider)!.token;
  final token = ref.watch(currentUserNotifierProvider.select((user) => user!.token));

  final res = await ref.watch(homeRepositoryProvider).getAllFavoriteSongs(
        token: token,
      );

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);

    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong({
    required String songId,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      // Right(value: final r) => state = AsyncValue.data(r),
      Right(value: final r) => _favSongSuccess(r, songId),
    };

    print(val);
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    // final userNotifier = ref.read(currentUserNotifierProvider.notifier);

    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavorited);
  }
}
