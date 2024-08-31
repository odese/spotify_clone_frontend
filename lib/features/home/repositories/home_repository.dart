import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_frontend/core/constants/server_constant.dart';
import 'package:spotify_clone_frontend/core/failure/failure.dart';
import 'package:spotify_clone_frontend/features/home/model/song_model.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ServerConstant.serverURL}/song/upload"),
      );

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath("song", selectedAudio.path),
            await http.MultipartFile.fromPath("thumbnail", selectedThumbnail.path),
          ],
        )
        ..fields.addAll(
          {
            "artist": artist,
            "song_name": songName,
            "hex_code": hexCode,
          },
        )
        ..headers.addAll(
          {
            "x-auth-token": token,
          },
        );

      final response = await request.send();

      if (response.statusCode != HttpStatus.created) {
        return Left(AppFailure(await response.stream.bytesToString()));
      } else {
        return Right(await response.stream.bytesToString());
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.serverURL}/song/list"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );

      var resBodyMap = jsonDecode(response.body);

      if (response.statusCode != HttpStatus.ok) {
        // final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap["message"]));
      } else {
        resBodyMap = resBodyMap as List;
        List<SongModel> songs = [];
        for (final map in resBodyMap) {
          songs.add(SongModel.fromMap(map));
        }
        return Right(songs);
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse("${ServerConstant.serverURL}/song/favorite/$songId"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );

      var resBodyMap = jsonDecode(response.body);

      if (response.statusCode != HttpStatus.ok) {
        // final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap["message"]));
      } else {
        return Right(resBodyMap);
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // .......................

  Future<Either<AppFailure, List<SongModel>>> getAllFavoriteSongs({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.serverURL}/song/list/favorites"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );

      var resBodyMap = jsonDecode(response.body);

      if (response.statusCode != HttpStatus.ok) {
        // final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap["message"]));
      } else {
        resBodyMap = resBodyMap as List;
        List<SongModel> songs = [];
        for (final map in resBodyMap) {
          songs.add(SongModel.fromMap(map));
        }
        return Right(songs);
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
