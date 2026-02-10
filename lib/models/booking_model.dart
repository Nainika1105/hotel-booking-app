class BookingModel {
  final String id;
  final String roomType;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final double totalPrice;
  String status; // 👈 NEW

  BookingModel({
    required this.id,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.totalPrice,
    this.status = 'Confirmed',
  });
}
