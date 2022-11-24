// https://developers.themoviedb.org/3/configuration/get-api-configuration

class TmdbConfiguration {
  String baseUrl;
  String secureBaseUrl;
  List<String> posterSizes;

  TmdbConfiguration(
      {required this.baseUrl,
      required this.secureBaseUrl,
      required this.posterSizes});

  static TmdbConfiguration fromJson(Map<String, Object?> json) {
    return TmdbConfiguration(
        baseUrl: json['base_url'] != null ? json['base_url'] as String : '',
        secureBaseUrl: json['secure_base_url'] != null
            ? json['secure_base_url'] as String
            : '',
        posterSizes: json['poster_sizes'] != null
            ? (json['poster_sizes'] as List).map((e) => e as String).toList()
            : []);
  }
}
