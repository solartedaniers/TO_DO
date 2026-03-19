import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:task_pro_supabase/theme/app_colors.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime; // Nueva variable para la hora
  File? _selectedFile;
  String _selectedCategory = "More";

  // 1. Selector de Fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // 2. Selector de Hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // 3. Selector de Archivo
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bro, te falta la fecha o la hora'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
      
      // Aquí mandas todo a la DB
      print("Guardando: ${_titleController.text}");
      print("Hora: ${_selectedTime!.format(context)}");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Adding Task", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Task Title", _titleController, "Escribe el título..."),
              const SizedBox(height: 15),
              _buildTextField("Description", _descriptionController, "(Not Required)", maxLines: 3),
              
              const SizedBox(height: 25),

              // BOTÓN FECHA
              _buildActionButton(
                icon: Icons.calendar_today_outlined,
                text: _selectedDate == null ? "Select Date In Calendar" : DateFormat('dd MMMM, yyyy').format(_selectedDate!),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: 15),

              // BOTÓN ARCHIVOS
              _buildActionButton(
                icon: Icons.add_box_rounded,
                text: _selectedFile == null ? "Additional Files" : "Archivo listo ✓",
                onTap: _pickFile,
                isSecondary: true,
              ),

              const SizedBox(height: 15),

              // BOTÓN HORA (NUEVO - Debajo de archivos)
              _buildActionButton(
                icon: Icons.access_time_rounded,
                text: _selectedTime == null ? "Select Task Time" : "Time: ${_selectedTime!.format(context)}",
                onTap: () => _selectTime(context),
                isSecondary: true,
              ),

              const SizedBox(height: 30),
              const Text("Choose Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Chips de Categorías
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ["Healthy", "Design", "Job", "Education", "Sport", "More"].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? AppColors.primary : Colors.grey, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300)
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _submitTask,
                child: const Text("Confirm Adding", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
          validator: (value) => (label == "Task Title" && (value == null || value.isEmpty)) ? "Ponle nombre, bro" : null,
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String text, required VoidCallback onTap, bool isSecondary = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: isSecondary ? Border.all(color: AppColors.primary.withOpacity(0.2)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 15),
            Text(text, style: TextStyle(color: isSecondary ? AppColors.primary : Colors.grey.shade700, fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: isSecondary ? AppColors.primary : Colors.grey),
          ],
        ),
      ),
    );
  }
}