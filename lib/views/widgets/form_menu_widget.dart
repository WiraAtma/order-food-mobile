import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/types/category_type.dart';
import 'package:order_food_mobile/services/menu_services.dart';

class FormMenuWidget extends StatefulWidget {
  const FormMenuWidget({super.key});

  @override
  State<FormMenuWidget> createState() => _FormMenuWidgetState();
}

class _FormMenuWidgetState extends State<FormMenuWidget> {
  final menuService = MenuServices();

  final formKey = GlobalKey<FormState>();
  final menuController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  CategoryType selectedCategory = CategoryType.food;
  File? selectedImage;
  bool isSubmitting = false;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gambar wajib dipilih")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await menuService.createMenu(
        name: menuController.text.trim(),
        description: descriptionController.text.trim(),
        price: int.parse(priceController.text),
        category: selectedCategory.apiValue ?? selectedCategory.name,
        image: selectedImage!,
      );

      if (!mounted) return;
      Navigator.pop(context, true); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    menuController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add),
          SizedBox(width: 5),
          Text("Tambah Menu Baru"),
        ],
      ),
      titleTextStyle: TextStyle(fontSize: 20, color: AppColors.darkColor),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama Menu Wajib Diisi";
                  }
                  return null;
                },
                controller: menuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan Nama Menu",
                  label: Text("Menu*"),
                ),
              ),
              TextFormField(
                controller: priceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga wajib diisi";
                  }
          
                  if (int.tryParse(value) == null) {
                    return "Harga harus berupa angka";
                  }
          
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefix: Text("Rp "),
                  label: Text("Harga (Rp)*"),
                ),
              ),
              DropdownButtonFormField<CategoryType>(
                initialValue: selectedCategory,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: CategoryType.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
          
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Deskripsi (optional)",
                ),
              ),
              if (selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(selectedImage!, height: 150, fit: BoxFit.cover),
                ),
          
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: pickImage,
                icon: Icon(Icons.image),
                label: Text("Pilih Gambar"),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isSubmitting ? null : submitForm, 
                  child: isSubmitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
