import 'package:flutter/material.dart';
import 'package:pointmaster/models/booking.dart';
import 'package:pointmaster/models/court.dart';
import 'package:pointmaster/models/facility.dart';
import 'package:pointmaster/models/wallet_transaction.dart';
import 'package:pointmaster/providers/booking_provider.dart';
import 'package:pointmaster/providers/court_provider.dart';
import 'package:pointmaster/providers/facility_provider.dart';
import 'package:pointmaster/screens/admin/admin_create_court_screen.dart';
import 'package:pointmaster/widgets/screens/court_card.dart';
import 'package:provider/provider.dart';

enum _AdminSection { courts, bookings, wallet }

class AdminFacilityDetailScreen extends StatefulWidget {
  final Facility facility;

  const AdminFacilityDetailScreen({
    super.key,
    required this.facility,
  });

  @override
  State<AdminFacilityDetailScreen> createState() => _AdminFacilityDetailScreenState();
}

class _AdminFacilityDetailScreenState extends State<AdminFacilityDetailScreen> {
  _AdminSection _selectedSection = _AdminSection.courts;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadInitialData);
  }

  Future<void> _loadInitialData() async {
    await Provider.of<CourtProvider>(context, listen: false).getCourts(widget.facility.id);
  }

  Future<void> _refreshCurrentSection() async {
    if (_selectedSection == _AdminSection.courts) {
      await Provider.of<CourtProvider>(context, listen: false).getCourts(widget.facility.id);
    } else if (_selectedSection == _AdminSection.bookings) {
      await Provider.of<BookingProvider>(context, listen: false).getBookingsByFacility(widget.facility.id);
    } else {
      final facilityProvider = Provider.of<FacilityProvider>(context, listen: false);
      await facilityProvider.getWalletFacility(widget.facility.id);
      await facilityProvider.getWalletFacilityTransactions(widget.facility.id);
    }
  }

  Future<void> _changeSection(_AdminSection section) async {
    setState(() => _selectedSection = section);
    await _refreshCurrentSection();
  }

  Future<void> _openCreateCourtScreen() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminCreateCourtScreen(facilityId: widget.facility.id),
      ),
    );

    if (created == true) {
      await Provider.of<CourtProvider>(context, listen: false).getCourts(widget.facility.id);
    }
  }

  Future<void> _openEditCourtScreen(Court court) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminCreateCourtScreen(
          facilityId: widget.facility.id,
          courtToEdit: court,
        ),
      ),
    );

    if (updated == true) {
      await Provider.of<CourtProvider>(context, listen: false).getCourts(widget.facility.id);
    }
  }

  Future<void> _toggleCourtActivation(Court court) async {
    final courtProvider = Provider.of<CourtProvider>(context, listen: false);
    if (court.activated) {
      await courtProvider.deactivateCourt(court.id);
    } else {
      await courtProvider.activateCourt(court.id);
    }
    await courtProvider.getCourts(widget.facility.id);
    if (!mounted) return;
    final message = courtProvider.errorMessage ??
        (court.activated ? 'Pista desactivada' : 'Pista activada');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _swipeBackground({
    required IconData icon,
    required String label,
    required Color color,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
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
    final courtProvider = Provider.of<CourtProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final facilityProvider = Provider.of<FacilityProvider>(context);

    final courts = courtProvider.courts.where((c) => c.facilityId == widget.facility.id).toList();
    final bookings = bookingProvider.bookings.where((b) => b.deleted == false).toList();
    final transactions = [...facilityProvider.facilityWalletTransactions]
      ..sort((a, b) => b.id.compareTo(a.id));

    final bool isLoading = (_selectedSection == _AdminSection.courts && courtProvider.isLoading) ||
        (_selectedSection == _AdminSection.bookings && bookingProvider.loading) ||
        (_selectedSection == _AdminSection.wallet && facilityProvider.isLoading);

    final String? sectionError = _selectedSection == _AdminSection.courts
        ? courtProvider.errorMessage
        : _selectedSection == _AdminSection.bookings
            ? bookingProvider.errorMessage
            : facilityProvider.errorMessage;

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
      floatingActionButton: _selectedSection == _AdminSection.courts
          ? FloatingActionButton(
              onPressed: _openCreateCourtScreen,
              backgroundColor: const Color(0xFFC4AD55),
              child: const Icon(Icons.add),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _refreshCurrentSection,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _sectionButton('Pistas', _AdminSection.courts)),
                  const SizedBox(width: 8),
                  Expanded(child: _sectionButton('Reservas', _AdminSection.bookings)),
                  const SizedBox(width: 8),
                  Expanded(child: _sectionButton('Wallet', _AdminSection.wallet)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (sectionError != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  sectionError,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else ..._buildSectionContent(courts, bookings, facilityProvider.facilityWallet?.amount, transactions),
          ],
        ),
      ),
    );
  }

  Widget _sectionButton(String label, _AdminSection section) {
    final isSelected = _selectedSection == section;
    return ElevatedButton(
      onPressed: () => _changeSection(section),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFC4AD55) : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        side: const BorderSide(color: Color(0xFFC4AD55)),
        elevation: isSelected ? 2 : 0,
      ),
      child: Text(label),
    );
  }

  List<Widget> _buildSectionContent(
    List<Court> courts,
    List<Booking> bookings,
    double? walletAmount,
    List<WalletTransaction> transactions,
  ) {
    if (_selectedSection == _AdminSection.courts) {
      if (courts.isEmpty) {
        return const [Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No hay pistas')))];
      }
      return courts
          .map(
            (court) => Dismissible(
              key: ValueKey('court-${court.id}'),
              direction: DismissDirection.horizontal,
              background: _swipeBackground(
                icon: court.activated ? Icons.toggle_off : Icons.toggle_on,
                label: court.activated ? 'Desactivar' : 'Activar',
                color: court.activated ? Colors.red : Colors.green,
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
                  await _toggleCourtActivation(court);
                } else {
                  await _openEditCourtScreen(court);
                }
                return false;
              },
              child: CourtCard(court: court, onTap: () {}),
            ),
          )
          .toList();
    }

    if (_selectedSection == _AdminSection.bookings) {
      if (bookings.isEmpty) {
        return const [Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No hay reservas')))];
      }
      return bookings.map(_bookingTile).toList();
    }

    return [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFC4AD55), Color(0xFF8B6F2C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saldo actual', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(
              '${(walletAmount ?? 0).toStringAsFixed(2)} EUR',
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('Transacciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 8),
      if (transactions.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('No hay transacciones'),
        ),
      ...transactions.map(_transactionTile),
    ];
  }

  Widget _bookingTile(Booking booking) {
    final date = booking.courtDateTimeBooking;
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTime =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.calendar_month),
        title: Text('Pista ID ${booking.courtId}'),
        subtitle: Text('$formattedDate  $formattedTime'),
        trailing: Text('${booking.courtPrice.toStringAsFixed(2)} EUR'),
      ),
    );
  }

  Widget _transactionTile(WalletTransaction tx) {
    final delta = tx.balanceAfter - tx.balanceBefore;
    final isPositive = delta > 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          color: isPositive ? Colors.green : Colors.red,
        ),
        title: Text(tx.description),
        subtitle: Text('Saldo: ${tx.balanceAfter.toStringAsFixed(2)} EUR'),
        trailing: Text(
          '${isPositive ? '+' : '-'}${delta.abs().toStringAsFixed(2)} EUR',
          style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
