import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/core/utils/cloudinary_utils.dart';

void main() {
  group('cloudinaryThumbnail', () {
    const cloudinaryUrl =
        'https://res.cloudinary.com/demo/image/upload/v1/conciertos/foto.jpg';

    test('inserts transform params after /upload/', () {
      final result = cloudinaryThumbnail(cloudinaryUrl);
      expect(
        result,
        'https://res.cloudinary.com/demo/image/upload/'
        'w_300,c_fill,q_auto,f_auto/v1/conciertos/foto.jpg',
      );
    });

    test('respects custom width parameter', () {
      final result = cloudinaryThumbnail(cloudinaryUrl, width: 150);
      expect(result, contains('w_150,c_fill,q_auto,f_auto'));
    });

    test('returns non-Cloudinary URL unchanged', () {
      const other = 'https://example.com/image.png';
      expect(cloudinaryThumbnail(other), other);
    });

    test('returns empty string unchanged', () {
      expect(cloudinaryThumbnail(''), '');
    });

    test('handles URL with no /upload/ marker', () {
      const noUpload = 'https://res.cloudinary.com/demo/image/fetch/https://x.com/a.jpg';
      expect(cloudinaryThumbnail(noUpload), noUpload);
    });

    test('default width is 300', () {
      final result = cloudinaryThumbnail(cloudinaryUrl);
      expect(result, contains('w_300,'));
    });

    test('preserves version segment after transform', () {
      final result = cloudinaryThumbnail(cloudinaryUrl);
      expect(result, contains('/v1/conciertos/foto.jpg'));
    });
  });
}
