/// Utilidades para transformar URLs de Cloudinary en el cliente.
///
/// Cloudinary permite insertar parámetros de transformación en la URL
/// sin necesidad de cambiar nada en el backend ni en el storage.
library cloudinary_utils;

/// Devuelve una URL de thumbnail optimizada para una imagen de Cloudinary.
///
/// Inserta [w_<width>,c_fill,q_auto,f_auto] después de /upload/ para que
/// Cloudinary sirva WebP/AVIF al tamaño exacto.
/// Si la URL no es de Cloudinary, la devuelve sin cambios.
///
/// Ejemplo:
///   https://res.cloudinary.com/cloud/image/upload/v1/conciertos/foto.jpg
///   → https://res.cloudinary.com/cloud/image/upload/w_300,c_fill,q_auto,f_auto/v1/conciertos/foto.jpg
String cloudinaryThumbnail(String url, {int width = 300}) {
  const marker = '/upload/';
  final idx = url.indexOf(marker);
  if (idx == -1) return url;
  return '${url.substring(0, idx + marker.length)}'
      'w_$width,c_fill,q_auto,f_auto/'
      '${url.substring(idx + marker.length)}';
}
