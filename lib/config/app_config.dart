abstract final class AppConfig {
  static const sharedApiBaseUrl = 'https://api.antinna.in';

  // Supply the real deployment URLs when the public and authenticated APIs
  // are finalized. The shared API is the stable Antinna endpoint.
  static const publicApiBaseUrl = sharedApiBaseUrl;
  static const authenticatedApiBaseUrl = sharedApiBaseUrl;

  // Replace these paths with the API contract paths without changing layers.
  static const publicCatalogPath = '/catalog';
  static const authenticatedCatalogPath = '/catalog';
  static const sharedCatalogPath = '/store/catalog';
}
