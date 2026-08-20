import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

enum IssueType { bug, mejora, otro }

extension IssueTypeLabel on IssueType {
  String get label {
    switch (this) {
      case IssueType.bug:    return '🐛 Bug';
      case IssueType.mejora: return '✨ Mejora';
      case IssueType.otro:   return '💬 Otro';
    }
  }

  /// Tipo de issue en Jira — nombres exactos del proyecto APP de ncovach.atlassian.net
  String get jiraType {
    switch (this) {
      case IssueType.bug:    return 'Error';
      case IssueType.mejora: return 'Feature';
      case IssueType.otro:   return 'Tarea';
    }
  }
}

class JiraService {
  static String get _domain    => dotenv.env['JIRA_DOMAIN']      ?? '';
  static String get _email     => dotenv.env['JIRA_EMAIL']       ?? '';
  static String get _token     => dotenv.env['JIRA_API_TOKEN']   ?? '';
  static String get _projectKey => dotenv.env['JIRA_PROJECT_KEY'] ?? '';

  static bool get isConfigured =>
      _domain.isNotEmpty &&
      _email.isNotEmpty &&
      _token.isNotEmpty &&
      _projectKey.isNotEmpty &&
      !_domain.contains('your-domain');

  /// Crea una incidencia en Jira.
  /// Devuelve la clave del issue creado (p.ej. "APP-42").
  static Future<String> createIssue({
    required IssueType type,
    required String description,
    required String reporterEmail,
  }) async {
    if (!isConfigured) {
      throw const _JiraNotConfiguredException();
    }

    final deviceInfo = await _buildDeviceInfo();

    final credentials = base64Encode(utf8.encode('$_email:$_token'));

    // Cuerpo en formato Atlassian Document Format (ADF)
    final body = {
      'fields': {
        'project': {'key': _projectKey},
        'summary': '[${type.label}] Incidencia desde la app',
        'issuetype': {'name': type.jiraType},
        'description': {
          'type': 'doc',
          'version': 1,
          'content': [
            _adfParagraph('📝 Descripción'),
            _adfParagraph(description.trim()),
            _adfParagraph(''),
            _adfParagraph('📱 Información del dispositivo'),
            _adfParagraph(deviceInfo),
            _adfParagraph(''),
            _adfParagraph('👤 Reportado por: $reporterEmail'),
          ],
        },
        'labels': ['app-report', type.name],
      },
    };

    final uri = Uri.https(_domain, '/rest/api/3/issue');
    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $credentials',
        HttpHeaders.contentTypeHeader:   'application/json',
        HttpHeaders.acceptHeader:        'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['key'] as String;
    } else {
      debugPrint('[Jira] Error ${response.statusCode}: ${response.body}');
      throw Exception(
        'Error al crear el ticket (${response.statusCode}). '
        'Comprueba las credenciales en .env',
      );
    }
  }

  static Map<String, dynamic> _adfParagraph(String text) => {
        'type': 'paragraph',
        'content': [
          {
            'type': 'text',
            'text': text.isEmpty ? ' ' : text,
          }
        ],
      };

  static Future<String> _buildDeviceInfo() async {
    String platform;
    String osVersion = '';
    try {
      platform  = Platform.operatingSystem;
      osVersion = Platform.operatingSystemVersion;
    } catch (_) {
      platform  = defaultTargetPlatform.name;
    }

    String appVersion = '';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = '${info.version}+${info.buildNumber}';
    } catch (_) {}

    final lines = <String>[
      'Plataforma: $platform',
      if (osVersion.isNotEmpty) 'SO: $osVersion',
      if (appVersion.isNotEmpty) 'App: $appVersion',
      'Modo: ${kDebugMode ? 'debug' : kReleaseMode ? 'release' : 'profile'}',
    ];

    return lines.join('\n');
  }
}

class _JiraNotConfiguredException implements Exception {
  const _JiraNotConfiguredException();

  @override
  String toString() =>
      'Jira no configurado. Rellena JIRA_DOMAIN, JIRA_EMAIL, '
      'JIRA_API_TOKEN y JIRA_PROJECT_KEY en el archivo .env';
}
