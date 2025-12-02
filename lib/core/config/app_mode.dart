class AppMode {
  static const String mode = 'development'; // Change to 'production' for live
  
  static bool get isDevelopment => mode == 'development';
  static bool get isProduction => mode == 'production';
}