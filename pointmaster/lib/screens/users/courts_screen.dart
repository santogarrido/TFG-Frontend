import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/providers/court_provider.dart';
import 'package:pointmaster/screens/users/court_booking_screen.dart';
import 'package:pointmaster/widgets/screens/court_card.dart';

class CourtsScreen extends StatefulWidget {
  final Facility facility;
  final User activeUser;

  const CourtsScreen({
    super.key,
    required this.facility,
    required this.activeUser,
  });

  @override
  State<CourtsScreen> createState() => _CourtsScreenState();
}

class _CourtsScreenState extends State<CourtsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<CourtProvider>(
        context,
        listen: false,
      ).getCourtsForUsers(widget.facility.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final courtProvider = Provider.of<CourtProvider>(context);

    if (courtProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (courtProvider.errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text(courtProvider.errorMessage!)),
      );
    }

    final courts = courtProvider.courtsForUsers
        .where((c) => c.facilityId == widget.facility.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: Text(widget.facility.name),
      ),
      body: RefreshIndicator(
        onRefresh: () => courtProvider.getCourtsForUsers(widget.facility.id),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: courts.isEmpty
              ? [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: const Center(
                      child: Text("No hay pistas disponibles"),
                    ),
                  ),
                ]
                : courts
                    .map(
                      (court) => CourtCard(
                        court: court,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourtBookingScreen(
                                court: court,
                                facility: widget.facility,
                                user: widget.activeUser,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
        ),
      ),
    );
  }
}
