import 'package:flutter/material.dart';
import 'package:pointmaster/models/user.dart';
import 'package:pointmaster/providers/facility_provider.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/screens/login_screen.dart';
import 'package:pointmaster/screens/users/user_bookings_screen.dart';
import 'package:pointmaster/screens/users/courts_screen.dart';
import 'package:pointmaster/screens/users/user_wallet_screen.dart';
import 'package:pointmaster/widgets/screens/facility_card.dart';
import 'package:provider/provider.dart';

class SelectClubScreen extends StatefulWidget {
  final User activeUser;

  const SelectClubScreen({
    super.key,
    required this.activeUser,
  });

  @override
  State<SelectClubScreen> createState() =>
      _SelectClubScreenState();
}

class _SelectClubScreenState
    extends State<SelectClubScreen> {
  Future<void> _logout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showUserOptionsSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Cartera'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (_) => UserWalletScreen(
                        user: widget.activeUser,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Reservas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (_) => UserBookingsScreen(
                        user: widget.activeUser,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  Navigator.pop(context);
                  await _logout();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<FacilityProvider>(
        context,
        listen: false,
      ).getFacilitiesForUsers();
    });
  }

  @override
  Widget build(BuildContext context) {

    final facilityProvider =
        Provider.of<FacilityProvider>(context);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,

        title: const Text(
          "PointMaster",
          style: TextStyle(
            color: Colors.black,
          ),
        ),

        leading: Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
          ),
          child: Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.22),
                  blurRadius: width * 0.045,
                  offset: Offset(
                    0,
                    width * 0.015,
                  ),
                ),
              ],
            ),

            child: RawMaterialButton(
              shape: const CircleBorder(),
              onPressed: _showUserOptionsSheet,
              elevation: 0,
              fillColor: Colors.white,

              child: Icon(
                Icons.person,
                size: width * 0.055,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),

      body: facilityProvider.isLoading

          // Loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          // Error
          : facilityProvider.errorMessage != null
              ? Center(
                  child: Text(
                    facilityProvider
                        .errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                )

              // Lista de clubes
              : RefreshIndicator(
                  onRefresh: () =>
                      facilityProvider.getFacilitiesForUsers(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    itemCount: facilityProvider
                        .facilitiesForUsers.length,
                    itemBuilder:
                        (context, index) {
                      final facility =
                          facilityProvider
                                  .facilitiesForUsers[
                              index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourtsScreen(
                                facility: facility,
                                activeUser: widget.activeUser,
                              ),
                            ),
                          );
                        },
                        child: FacilityCard(
                          facility: facility,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

