class ApiConfig {
  /// API Key bắt buộc cho mọi request - Cần lấy từ server
  static const String apiKey = "SKT-T1";

  /// Language mặc định (vi hoặc en)
  static const String defaultLanguage = "vi";

  /// Headers bắt buộc cho mọi request
  static Map<String, String> get headers => {
        'X-Api-Key': apiKey,
        'Language': defaultLanguage,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Headers khi đã đăng nhập (có token)
  static Map<String, String> getAuthHeaders(String token) => {
        'X-Api-Key': apiKey,
        'Language': defaultLanguage,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
