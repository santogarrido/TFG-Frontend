import 'package:flutter/material.dart';
import 'package:pointmaster/models/court.dart';

class CourtCard extends StatelessWidget {
  final Court court;
  final VoidCallback onTap;

  const CourtCard({
    super.key,
    required this.court,
    required this.onTap,
  });

@override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFC4AD55),
            width: 1.5,
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre
              Text(
                court.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Categoría
              Row(
                children: [
                  const Icon(Icons.sports_tennis, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(court.category),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Duración reserva
              Row(
                children: [
                  const Icon(Icons.timer, size: 18),
                  const SizedBox(width: 6),
                  Text('${court.bookingDuration} min'),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.euro, size: 18),
                  const SizedBox(width: 6),
                  Text('${court.price.toStringAsFixed(2)} €'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
