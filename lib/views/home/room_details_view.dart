import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../booking/booking_confirmation_view.dart';
import '../../models/booking_model.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailsView extends StatefulWidget {
  final RoomModel room;

  const RoomDetailsView({super.key, required this.room});

  @override
  State<RoomDetailsView> createState() => _RoomDetailsViewState();
}

class _RoomDetailsViewState extends State<RoomDetailsView> {
  DateTime? checkIn;
  DateTime? checkOut;
  int adults = 1;
  int children = 0;

  final Color primary = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: Text(widget.room.type),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ROOM HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.type,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '₹${widget.room.pricePerNight.toInt()} / night',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.star,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(widget.room.rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Max ${widget.room.maxGuests} guests',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // MAP BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                ),
                onPressed: _openMap,
                icon: const Icon(Icons.map),
                label: const Text('View Hotel on Map'),
              ),
            ),

            const SizedBox(height: 20),

            // DATES SECTION
            _Section(
              title: 'Dates',
              child: Column(
                children: [
                  _outlineButton(
                    text: checkIn == null
                        ? 'Select Check-in Date'
                        : 'Check-in: ${_formatDate(checkIn!)}',
                    onTap: _selectCheckIn,
                  ),
                  const SizedBox(height: 10),
                  _outlineButton(
                    text: checkOut == null
                        ? 'Select Check-out Date'
                        : 'Check-out: ${_formatDate(checkOut!)}',
                    onTap:
                        checkIn == null ? null : _selectCheckOut,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // GUESTS SECTION
            _Section(
              title: 'Guests',
              child: Column(
                children: [
                  _guestRow(
                    label: 'Adults',
                    value: adults,
                    onAdd: () {
                      if (adults + children <
                          widget.room.maxGuests) {
                        setState(() => adults++);
                      }
                    },
                    onRemove: () {
                      if (adults > 1) {
                        setState(() => adults--);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  _guestRow(
                    label: 'Children',
                    value: children,
                    onAdd: () {
                      if (adults + children <
                          widget.room.maxGuests) {
                        setState(() => children++);
                      }
                    },
                    onRemove: () {
                      if (children > 0) {
                        setState(() => children--);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BOOK BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                ),
                onPressed: _canBook() ? _onBookNow : null,
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canBook() => checkIn != null && checkOut != null;

  void _onBookNow() {
    final nights = checkOut!.difference(checkIn!).inDays;
    final totalPrice = nights * widget.room.pricePerNight;

    final booking = BookingModel(
      id: const Uuid().v4(),
      roomType: widget.room.type,
      checkIn: checkIn!,
      checkOut: checkOut!,
      adults: adults,
      children: children,
      totalPrice: totalPrice.toDouble(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BookingConfirmationView(booking: booking),
      ),
    );
  }

  Widget _outlineButton({
    required String text,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }

  Widget _guestRow({
    required String label,
    required int value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove),
            ),
            Text(value.toString()),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  Future<void> _selectCheckIn() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        checkIn = picked;
        checkOut = null;
      });
    }
  }

  Future<void> _selectCheckOut() async {
    if (checkIn == null) return;
    final picked = await showDatePicker(
      context: context,
      firstDate: checkIn!.add(const Duration(days: 1)),
      lastDate: checkIn!.add(const Duration(days: 365)),
      initialDate: checkIn!.add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => checkOut = picked);
    }
  }

  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.room.latitude},${widget.room.longitude}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open map'),
        ),
      );
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
