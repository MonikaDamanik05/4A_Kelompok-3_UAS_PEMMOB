//import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_app/dto/dataLogin.dart';
import 'package:my_app/dto/komentar.dart';
import 'package:my_app/dto/kuliner.dart';
import 'package:my_app/dto/profil.dart';
import 'dart:convert';
import 'package:my_app/endpoints/endpoints.dart';
import 'package:my_app/utils/constants.dart';
import 'package:my_app/utils/secure_storage_util.dart';

class DataService {
  // Fetch data from kuliner endpoint
  static Future<List<Kuliner>> fetchKuliner([String? query]) async {
    final url = query != null && query.isNotEmpty
        ? '${Endpoints.readkuliner}?query=$query'
        : Endpoints.readkuliner;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Kuliner.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load kuliner data');
    }
  }

  // Create new kuliner data
  static Future<Kuliner> createKuliner(
      String name, String description, double price) async {
    final response = await http.post(
      Uri.parse(Endpoints.createkuliner),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'price': price,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return Kuliner.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create kuliner data: ${response.statusCode}');
    }
  }

  // Update kuliner data
  static Future<Kuliner> updateKuliner(
      int id, String name, String description, double price) async {
    final response = await http.put(
      Uri.parse('${Endpoints.updatekuliner}/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'price': price,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Kuliner.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to update kuliner data: ${response.statusCode}');
    }
  }

  // Delete kuliner data
  static Future<void> deleteKuliner(int id) async {
    final response =
        await http.delete(Uri.parse('${Endpoints.deletekuliner}/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete kuliner data: ${response.statusCode}');
    }
  }

static Future<double?> fetchRating(int idKuliner) async {
      final response = await http.get(Uri.parse('${Endpoints.bintang}$idKuliner'));
      if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rating'] != null ? double.parse(data['rating'].toString()) : null;
    } else if (response.statusCode == 404) {
      // No ratings found
      return null; // Return null to indicate no ratings found
    } else {
      throw Exception('Failed to fetch rating (${response.statusCode})');
    }
  } 

  static Future<http.Response> register(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse(Endpoints.register);
    final data = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<http.Response> sendLoginData(
      String email, String password) async {
    final url = Uri.parse(Endpoints.dataLogin);

    final data = {'email': email, 'password': password};

    final response = await http.post(
      url,
      body: data,
    );

    return response;
  }

  static Future<dataLogin> fetchProfile(String? accessToken) async {
    accessToken ??= await SecureStorageUtil.storage.read(key: tokenStoreName);

    final response = await http.get(
      Uri.parse(Endpoints.login1),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      try {
        return dataLogin.fromJson(jsonResponse);
      } catch (e) {
        throw Exception('Failed to parse Profile: $e');
      }
    } else {
      throw Exception(
          'Failed to load Profile with status code: ${response.statusCode}');
    }
  }

  static Future<Profile?> fetchUserData(int idUser) async {
    try {
      final response = await http.get(
        Uri.parse('${Endpoints.readUserById}?id_user=$idUser'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Profile.fromJson(data['datas'][0]);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  static Future<void> updateUserData(
    int idUser,
    String namaLengkap,
    String email,
    String alamat,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${Endpoints.updateUser}/$idUser'),
        body: {
          'nama_lengkap': namaLengkap,
          'email': email,
          'alamat': alamat,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  static Future<void> uploadImage(int idUser, File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.uploadUserPhoto),
      );
      request.fields['id_user'] = idUser.toString();
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<List<Komentar>> fetchKomentar() async {
    final response = await http.get(Uri.parse(Endpoints.readkomentar));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'] as List<dynamic>;
      return data.map((item) => Komentar.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data komentar');
    }
  }

  static Future<void> createKomentar(
    int idKuliner,
    int idUser,
    String deskripsi,
    String bintang,
  ) async {
    final uri = Uri.parse(Endpoints.createkomentar);
    final response = await http.post(
      uri,
      body: {
        'id_kuliner': idKuliner.toString(),
        'id_user': idUser.toString(),
        'deskripsi': deskripsi,
        'bintang': bintang,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create comment');
    }
  }

  static Future<Komentar> updateKomentar(
    int idUlasan,
    int idKuliner,
    int idUser,
    String deskripsi,
    String bintang,
    String foto,
  ) async {
    final response = await http.put(
      Uri.parse('${Endpoints.updatekomentar}/$idUlasan'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, dynamic>{
        'id_kuliner': idKuliner,
        'id_user': idUser,
        'deskripsi': deskripsi,
        'bintang': bintang,
        'foto': foto,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Komentar.fromJson(jsonResponse['datas']);
    } else {
      throw Exception(
          'Gagal memperbarui data komentar: ${response.statusCode}');
    }
  }

  static Future<void> deleteKomentar(int id) async {
    final response =
        await http.delete(Uri.parse('${Endpoints.deletekomentar}/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data komentar: ${response.statusCode}');
    }
  }

  static Future<String> uploadFotoKomentar(
    int idUlasan,
    String filePath,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(Endpoints.fotokomentar));
    request.fields['id_ulasan'] = idUlasan.toString();
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);
      return jsonResponse['file_path'];
    } else {
      throw Exception('Gagal mengunggah foto: ${response.statusCode}');
    }
  }
}
