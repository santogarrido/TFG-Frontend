import 'package:flutter/material.dart';
import 'package:pointmaster/models/court.dart';
import 'package:pointmaster/providers/court_provider.dart';
import 'package:provider/provider.dart';

class AdminCreateCourtScreen extends StatefulWidget {
  final int facilityId;
  final Court? courtToEdit;

  const AdminCreateCourtScreen({
    super.key,
    required this.facilityId,
    this.courtToEdit,
  });

  @override
  State<AdminCreateCourtScreen> createState() => _AdminCreateCourtScreenState();
}

class _AdminCreateCourtScreenState extends State<AdminCreateCourtScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String _selectedCategory = 'doble';

  bool get _isEditMode => widget.courtToEdit != null;

  @override
  void initState() {
    super.initState();
    final court = widget.courtToEdit;
    if (court != null) {
      _nameController.text = court.name;
      _priceController.text = court.price.toStringAsFixed(2);
      _durationController.text = court.bookingDuration.toString();
      _selectedCategory = court.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submitCourt() async {
    final courtProvider = context.read<CourtProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim().replaceAll(',', '.'));
    final duration = int.tryParse(_durationController.text.trim());

    if (name.isEmpty || price == null || price <= 0 || duration == null || duration <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Completa los campos correctamente')),
      );
      return;
    }

    if (_isEditMode) {
      await courtProvider.updateCourt(
        widget.courtToEdit!.id,
        name,
        _selectedCategory,
        price,
        duration,
        widget.facilityId,
      );
    } else {
      await courtProvider.addCourt(
        name,
        _selectedCategory,
        price,
        duration,
        widget.facilityId,
      );
    }

    if (!mounted) return;

    if (courtProvider.errorMessage == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? 'Pista actualizada' : 'Pista creada'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(courtProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final courtProvider = context.watch<CourtProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: Text(_isEditMode ? 'Editar pista' : 'Crear pista'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07,
          vertical: size.height * 0.06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: _inputDecoration('Nombre', Icons.sports_tennis),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              items: const [
                DropdownMenuItem(value: 'doble', child: Text('doble')),
                DropdownMenuItem(value: 'individual', child: Text('individual')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedCategory = value);
              },
              decoration: _inputDecoration('Categoria', Icons.category_outlined),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('Court Price', Icons.euro),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Duracion (min)', Icons.timer_outlined),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: courtProvider.isLoading ? null : _submitCourt,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: courtProvider.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isEditMode ? 'Guardar' : 'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
    );
  }
}
