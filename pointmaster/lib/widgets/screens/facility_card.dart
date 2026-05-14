import 'package:flutter/material.dart';
import 'package:pointmaster/models/facility.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;

  const FacilityCard({
    super.key,
    required this.facility,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = facility.imageUrl.trim();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFC4AD55),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(3, 7),
          ),
        ],
      ),

      child: Column(
        children: [
          // Cabecera dorada
          Container(
            height: 23,
            decoration: BoxDecoration(
              color: Color(0xFFC4AD55),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Imagen
                Hero(
                  tag: 'facility-image-${facility.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: imageUrl.isEmpty
                        ? Container(
                            width: 165,
                            height: 165,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )
                        : Image.network(
                            imageUrl,
                            width: 165,
                            height: 165,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                width: 165,
                                height: 165,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                  ),
                ),

                const SizedBox(width: 16),

                // Nombre + localización + horario
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      // Nombre
                      Text(
                        facility.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Localización
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                          ),
                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              facility.location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Horario
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                          ),
                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              "${facility.openTime} - ${facility.closeTime}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
