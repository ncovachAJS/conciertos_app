import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/album_record.dart';
import '../models/album_record_model.dart';

/// Lanzada cuando el disco ya está en la colección (HTTP 409).
class RecordAlreadyExistsException implements Exception {}

class RecordsApiService {
  static const _timeout = Duration(seconds: 25);

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthController.instance.token}',
      };

  Future<List<AlbumRecordModel>> getAll() async {
    final res = await http
        .get(Uri.parse(ApiConfig.recordsEndpoint), headers: _headers)
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Records (${res.statusCode})');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => AlbumRecordModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Busca en Discogs a través del backend. Una consulta solo numérica de
  /// 8-14 dígitos se trata como código de barras.
  Future<List<AlbumRecordModel>> search(
    String query, {
    RecordFormat? format,
  }) async {
    final q = query.trim();
    final isBarcode = RegExp(r'^\d{8,14}$').hasMatch(q);
    final uri = Uri.parse(ApiConfig.recordsSearchEndpoint).replace(
      queryParameters: {
        if (isBarcode) 'barcode': q else 'q': q,
        if (format == RecordFormat.vinyl) 'format': 'VINYL',
        if (format == RecordFormat.cd) 'format': 'CD',
      },
    );
    final res = await http.get(uri, headers: _headers).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Records search (${res.statusCode})');
    }
    final items = (jsonDecode(res.body)['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => AlbumRecordModel.fromSearchJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AlbumRecordModel> add(AlbumRecord record) async {
    final res = await http
        .post(
          Uri.parse(ApiConfig.recordsEndpoint),
          headers: _headers,
          body: jsonEncode(AlbumRecordModel.toCreateJson(record)),
        )
        .timeout(_timeout);
    if (res.statusCode == 409) throw RecordAlreadyExistsException();
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Add record (${res.statusCode})');
    }
    return AlbumRecordModel.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  /// Detalle ampliado de Discogs (canciones, géneros, estilos, enlace).
  Future<RecordDetail> getDiscogsDetail(int discogsId) async {
    final res = await http
        .get(
          Uri.parse('${ApiConfig.recordsEndpoint}/discogs/$discogsId'),
          headers: _headers,
        )
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Record detail (${res.statusCode})');
    }
    return RecordDetail.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  /// Actualiza solo los campos indicados (notes, status, condition, rating, price).
  Future<AlbumRecordModel> update(String id, Map<String, dynamic> fields) async {
    final res = await http
        .patch(
          Uri.parse(ApiConfig.recordEndpoint(id)),
          headers: _headers,
          body: jsonEncode(fields),
        )
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Update record (${res.statusCode})');
    }
    return AlbumRecordModel.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }

  Future<void> delete(String id) async {
    final res = await http
        .delete(Uri.parse(ApiConfig.recordEndpoint(id)), headers: _headers)
        .timeout(_timeout);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Delete record (${res.statusCode})');
    }
  }
}
