import '../models/room_model.dart';

class RoomService {
  static List<RoomModel> getRooms() {
    return [
      RoomModel(
        id: '1',
        type: 'Deluxe Room',
        pricePerNight: 4500,
        maxGuests: 3,
        rating: 4.5,
        latitude: 12.9716,
        longitude: 77.5946,
      ),
      RoomModel(
        id: '2',
        type: 'Executive Suite',
        pricePerNight: 7500,
        maxGuests: 4,
        rating: 4.8,
        latitude: 12.9721,
        longitude: 77.5933,
      ),
      RoomModel(
        id: '3',
        type: 'Standard Room',
        pricePerNight: 3000,
        maxGuests: 2,
        rating: 4.2,
        latitude: 12.9700,
        longitude: 77.5900,
      ),
    ];
  }
}
