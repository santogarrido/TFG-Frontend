import 'package:flutter/material.dart';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/providers/facility_provider.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/screens/admin/admin_create_facility_screen.dart';
import 'package:pointmaster/screens/admin/admin_facility_detail_screen.dart';
import 'package:pointmaster/screens/login_screen.dart';
import 'package:pointmaster/widgets/screens/facility_card.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<FacilityProvider>(context, listen: false).getFacilities(),
    );
  }

  Future<void> _goToCreateFacilityScreen() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const AdminCreateFacilityScreen(),
      ),
    );

    if (created == true && mounted) {
      await Provider.of<FacilityProvider>(context, listen: false).getFacilities();
    }
  }

  Future<void> _logout() async {
    await Provider.of<UserProvider>(context, listen: false).logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _toggleFacilityActivation(bool currentlyActive, int facilityId) async {
    final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
    if (currentlyActive) {
      await facilityProvider.deactivateFacility(facilityId);
    } else {
      await facilityProvider.activateFacility(facilityId);
    }
    await facilityProvider.getFacilities();
    if (!mounted) return;
    final message = facilityProvider.errorMessage ??
        (currentlyActive ? 'Club desactivado' : 'Club activado');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _editFacility(Facility facility) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminCreateFacilityScreen(facilityToEdit: facility),
      ),
    );
    if (updated == true && mounted) {
      await Provider.of<FacilityProvider>(context, listen: false).getFacilities();
    }
  }

  Widget _swipeBackground({
    required IconData icon,
    required String label,
    required Color color,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            alignment == Alignment.centerLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final facilityProvider = Provider.of<FacilityProvider>(context);
    final facilities = facilityProvider.facilities;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text('Administrador'),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          onSelected: (value) async {
            if (value == 'logout') await _logout();
          },
          itemBuilder: (_) => const [
            PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreateFacilityScreen,
        backgroundColor: const Color(0xFFC4AD55),
        child: const Icon(Icons.add),
      ),
      body: facilityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : facilityProvider.errorMessage != null
              ? Center(
                  child: Text(
                    facilityProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: facilityProvider.getFacilities,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: facilities.length,
                    itemBuilder: (context, index) {
                      final facility = facilities[index];
                      return Dismissible(
                        key: ValueKey('facility-${facility.id}'),
                        direction: DismissDirection.horizontal,
                        background: _swipeBackground(
                          icon: facility.activated ? Icons.toggle_off : Icons.toggle_on,
                          label: facility.activated ? 'Desactivar' : 'Activar',
                          color: facility.activated ? Colors.red : Colors.green,
                          alignment: Alignment.centerLeft,
                        ),
                        secondaryBackground: _swipeBackground(
                          icon: Icons.edit,
                          label: 'Editar',
                          color: Colors.blue,
                          alignment: Alignment.centerRight,
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            await _toggleFacilityActivation(facility.activated, facility.id);
                          } else {
                            await _editFacility(facility);
                          }
                          return false;
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminFacilityDetailScreen(facility: facility),
                              ),
                            );
                          },
                          child: FacilityCard(facility: facility),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
