/// Atajos disponibles para la fila de accesos rápidos del dashboard.
/// El nombre (`name`) es lo que se guarda en SharedPreferences: no renombrar
/// valores existentes sin migrar lo guardado (los nombres desconocidos se
/// descartan al cargar, así que eliminar uno es seguro).
///
/// Solo van aquí acciones que no estén ya en la barra inferior de la app.
enum QuickActionId {
  add,
  events,
  stats,
  import,
  friends,
  calendar,
  memory,
  records,
}

/// Máximo de atajos en la fila.
const int kMaxQuickActions = 5;

/// Los cinco de siempre; es lo que ve quien no ha personalizado nada.
const List<QuickActionId> kDefaultQuickActions = [
  QuickActionId.add,
  QuickActionId.events,
  QuickActionId.stats,
  QuickActionId.import,
  QuickActionId.friends,
];

/// Atajos que solo se ofrecen a usuarios con Pro real (fase de pruebas).
const Set<QuickActionId> kProOnlyQuickActions = {QuickActionId.records};
