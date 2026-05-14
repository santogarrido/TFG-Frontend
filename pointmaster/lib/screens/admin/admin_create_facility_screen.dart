import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pointmaster/providers/facility_provider.dart';
import 'package:pointmaster/widgets/screens/textfield_passwordfield.dart';
import 'package:provider/provider.dart';

class AdminCreateFacilityScreen extends StatefulWidget {
  const AdminCreateFacilityScreen({super.key});

  @override
  State<AdminCreateFacilityScreen> createState() => _AdminCreateFacilityScreenState();
}

class _AdminCreateFacilityScreenState extends State<AdminCreateFacilityScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController openTimeController = TextEditingController();
  final TextEditingController closeTimeController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    openTimeController.dispose();
    closeTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final facilityProvider = context.watch<FacilityProvider>();
    final fieldWidth = size.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.white,
        title: const Text('Crea tu instalación'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.07,
          vertical: size.height * 0.08,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: fieldWidth,
              child: FieldWidget(
                hintText: 'Nombre',
                prefixIcon: const Icon(Icons.abc),
                controller: nameController,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: fieldWidth,
              child: FieldWidget(
                hintText: 'Ubicación',
                prefixIcon: const Icon(Icons.location_city),
                controller: locationController,
              ),
            ),
            const SizedBox(height: 20),
            _buildTimeField(
              label: 'Hora de apertura',
              controller: openTimeController,
              width: fieldWidth,
            ),
            const SizedBox(height: 20),
            _buildTimeField(
              label: 'Hora de cierre',
              controller: closeTimeController,
              width: fieldWidth,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: fieldWidth,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final picked = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 90,
                  );
                  if (picked == null) return;
                  setState(() {
                    _selectedImage = File(picked.path);
                  });
                },
                icon: const Icon(Icons.image),
                label: Text(
                  _selectedImage == null
                      ? 'Seleccionar imagen'
                      : 'Cambiar imagen',
                ),
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  width: fieldWidth,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: facilityProvider.isLoading
                    ? null
                    : () async {
                        if (nameController.text.isEmpty ||
                            locationController.text.isEmpty ||
                            openTimeController.text.isEmpty ||
                            closeTimeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Todos los campos son obligatorios'),
                            ),
                          );
                          return;
                        }
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Debes seleccionar una imagen'),
                            ),
                          );
                          return;
                        }

                        await facilityProvider.addFacility(
                          nameController.text.trim(),
                          openTimeController.text.trim(),
                          closeTimeController.text.trim(),
                          locationController.text.trim(),
                          _selectedImage!,
                        );

                        if (!mounted) return;

                        if (facilityProvider.errorMessage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Instalación creada correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(facilityProvider.errorMessage!),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: facilityProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Crear',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    required double width,
  }) {
    TimeOfDay? currentTime;
    if (controller.text.isNotEmpty) {
      final parts = controller.text.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          currentTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    }

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: currentTime ?? const TimeOfDay(hour: 12, minute: 0),
          );
          if (!mounted || time == null) return;

          final hourStr = time.hour.toString().padLeft(2, '0');
          final minuteStr = time.minute.toString().padLeft(2, '0');
          controller.text = '$hourStr:$minuteStr';
          setState(() {});
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.access_time, color: Colors.black),
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
            ),
          ),
        ),
      ),
    );
  }
}
