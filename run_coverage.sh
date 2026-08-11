#!/usr/bin/env bash
# run_coverage.sh — Ejecuta los tests unitarios con cobertura y genera lcov.info para SonarQube.
# Uso: bash run_coverage.sh

set -e

echo "▶ Ejecutando tests unitarios con cobertura..."

flutter test \
  test/core/utils/date_formatter_test.dart \
  test/core/utils/cloudinary_utils_test.dart \
  test/features/concerts/domain/concert_test.dart \
  test/features/concerts/domain/concert_participant_test.dart \
  test/features/concerts/data/concert_model_test.dart \
  test/features/concerts/data/concert_cache_service_test.dart \
  test/features/auth/user_test.dart \
  test/features/friends/friend_test.dart \
  test/features/notifications/notification_model_test.dart \
  test/features/profile/achievement_test.dart \
  test/features/statistics/concert_stats_test.dart \
  test/app/theme_test.dart \
  test/core/utils/utils_test.dart \
  --coverage

echo "▶ Filtrando código generado del informe..."
if command -v lcov &>/dev/null; then
  lcov \
    --remove coverage/lcov.info \
    '**/*.g.dart' \
    '**/firebase_options.dart' \
    '**/l10n/generated/**' \
    '**/setlist_test_page.dart' \
    --output-file coverage/lcov.info \
    --ignore-errors unused 2>/dev/null || true
  echo "▶ Filtrado completado."
else
  echo "⚠️  lcov no instalado — lcov.info sin filtrar (aun así válido para SonarQube)."
fi

echo ""
echo "✅ Informe generado en coverage/lcov.info"
echo "   Ejecuta: sonar-scanner"
