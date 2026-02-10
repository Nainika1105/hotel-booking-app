import '../models/booking_model.dart';

class BookingService {
  static final List<BookingModel> _bookings = [];

  static void addBooking(BookingModel booking) {
    _bookings.add(booking);
  }

  static List<BookingModel> getBookings() {
    return _bookings;
  }

  static void cancelBooking(String id) {
    final booking =
        _bookings.firstWhere((b) => b.id == id);
    booking.status = 'Cancelled';
  }
}
