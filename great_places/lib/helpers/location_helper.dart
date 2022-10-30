// const GOOGLE_API_KEY = "";

class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://www.google.com/maps/@$latitude,$longitude,15z';
  }
}
