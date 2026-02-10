class RoomModel {
  final String id;
  final String type;
  final double pricePerNight;
  final int maxGuests;
  final double rating;
  final double latitude;
  final double longitude;

  RoomModel({
    required this.id,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });
}
