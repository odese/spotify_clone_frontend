import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spotify_clone_frontend/core/constants/server_constant.dart';
import 'package:spotify_clone_frontend/core/failure/failure.dart';
import 'package:spotify_clone_frontend/features/auth/model/user_model.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.serverURL}/auth/signup"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "password": password,
          },
        ),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != HttpStatus.created) {
        return Left(AppFailure(resBodyMap["error"]));
      } else {
        return Right(UserModel.fromMap(resBodyMap));
        // return Right(UserModel.fromJson(response.body));
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.serverURL}/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != HttpStatus.ok) {
        return Left(AppFailure(resBodyMap["error"]));
      } else {
        return Right(
          UserModel.fromMap(resBodyMap["user"]).copyWith(
            token: resBodyMap["token"],
          ),
        );
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstant.serverURL}/auth/"),
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": token,
        },
      );

      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != HttpStatus.ok) {
        return Left(AppFailure(resBodyMap["error"]));
      } else {
        return Right(
          UserModel.fromMap(resBodyMap).copyWith(
            token: token,
          ),
        );
      }
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
