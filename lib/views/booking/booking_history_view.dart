import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
//import '../../models/booking_model.dart';

class BookingHistoryView extends StatefulWidget {
  const BookingHistoryView({super.key});

  @override
  State<BookingHistoryView> createState() =>
      _BookingHistoryViewState();
}

class _BookingHistoryViewState extends State<BookingHistoryView> {
  @override
  Widget build(BuildContext context) {
    final bookings = BookingService.getBookings();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('My Bookings'),
        centerTitle: true,
      ),
      body: bookings.isEmpty
          ? const Center(
              child: Text('No bookings yet'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final canCancel =
                    DateTime.now().isBefore(booking.checkIn) &&
                    booking.status == 'Confirmed';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.roomType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_formatDate(booking.checkIn)} → ${_formatDate(booking.checkOut)}',
                        ),
                        Text(
                          'Guests: ${booking.adults} Adults, ${booking.children} Children',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Total: ₹${booking.totalPrice.toInt()}',
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Status: ${booking.status}',
                          style: TextStyle(
                            color: booking.status ==
                                    'Cancelled'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (canCancel)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  BookingService
                                      .cancelBooking(
                                          booking.id);
                                });
                              },
                              child:
                                  const Text('Cancel Booking'),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
