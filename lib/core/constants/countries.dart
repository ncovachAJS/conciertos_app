const _countriesEs = <String, String>{
  'Todo el mundo': '',
  'España': 'ES',
  'Portugal': 'PT',
  'Francia': 'FR',
  'Reino Unido': 'GB',
  'Alemania': 'DE',
  'Italia': 'IT',
  'Países Bajos': 'NL',
  'Bélgica': 'BE',
  'Suiza': 'CH',
  'Austria': 'AT',
  'Polonia': 'PL',
  'República Checa': 'CZ',
  'Argentina': 'AR',
  'Chile': 'CL',
  'Uruguay': 'UY',
  'Brasil': 'BR',
  'México': 'MX',
  'Estados Unidos': 'US',
  'Canadá': 'CA',
  'Japón': 'JP',
  'Australia': 'AU',
};

const _countriesEn = <String, String>{
  'Worldwide': '',
  'Spain': 'ES',
  'Portugal': 'PT',
  'France': 'FR',
  'United Kingdom': 'GB',
  'Germany': 'DE',
  'Italy': 'IT',
  'Netherlands': 'NL',
  'Belgium': 'BE',
  'Switzerland': 'CH',
  'Austria': 'AT',
  'Poland': 'PL',
  'Czech Republic': 'CZ',
  'Argentina': 'AR',
  'Chile': 'CL',
  'Uruguay': 'UY',
  'Brazil': 'BR',
  'Mexico': 'MX',
  'United States': 'US',
  'Canada': 'CA',
  'Japan': 'JP',
  'Australia': 'AU',
};

Map<String, String> localizedCountries(String languageCode) =>
    languageCode == 'en' ? _countriesEn : _countriesEs;

// Kept for backwards compatibility — defaults to Spanish
const countries = _countriesEs;
