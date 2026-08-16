import '../../domain/entities/spotify_artist.dart';
import 'spotify_client_service.dart';

/// Servicio de búsqueda de artistas en Spotify.
///
/// Delega en SpotifyClientService que proxía al backend propio.
/// Ya no se llama a Spotify directamente desde el cliente móvil.
class SpotifySearchService {
  final _client = SpotifyClientService();

  Future<SpotifyArtist?> searchArtist(String artist) =>
      _client.searchArtist(artist);
}
