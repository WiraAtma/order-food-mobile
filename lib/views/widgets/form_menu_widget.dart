import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_food_mobile/core/configs/app_config.dart';
import 'package:order_food_mobile/core/types/category_type.dart';
import 'package:order_food_mobile/services/menu_services.dart';

class FormMenuWidget extends StatefulWidget {
  final int? menuId;

  const FormMenuWidget({super.key, this.menuId});

  @override
  State<FormMenuWidget> createState() => _FormMenuWidgetState();
}

class _FormMenuWidgetState extends State<FormMenuWidget> {
  final _formKey = GlobalKey<FormState>();
  final menuService = MenuServices();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  CategoryType? selectedCategory;
  File? pickedImage;
  String? existingImage;

  bool get isEditMode => widget.menuId != null;

  bool isLoadingDetail = false;
  bool isSubmitting = false;
  String? loadErrorMessage;
  String? submitErrorMessage;

  @override
  void initState() {
    super.initState();
    if (isEditMode) fetchDetail();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> fetchDetail() async {
    setState(() {
      isLoadingDetail = true;
      loadErrorMessage = null;
    });

    try {
      final menu = await menuService.getDetailMenu(widget.menuId!);
      if (!mounted) return;

      setState(() {
        nameController.text = menu.name;
        descriptionController.text = menu.description;
        priceController.text = menu.price.toString();
        existingImage = menu.image;
        selectedCategory = CategoryType.values.firstWhere(
          (c) => c.apiValue == menu.category,
          orElse: () => CategoryType.all,
        );
        isLoadingDetail = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loadErrorMessage = e.toString();
        isLoadingDetail = false;
      });
    }
  }

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => pickedImage = File(file.path));
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isEditMode && pickedImage == null) {
      setState(() => submitErrorMessage = "Gambar wajib diisi");
      return;
    }

    setState(() {
      isSubmitting = true;
      submitErrorMessage = null;
    });

    try {
      if (isEditMode) {
        await menuService.updateMenu(
          id: widget.menuId!,
          name: nameController.text,
          description: descriptionController.text,
          price: int.parse(priceController.text),
          category: selectedCategory!.apiValue!,
          image: pickedImage,
        );
      } else {
        await menuService.createMenu(
          name: nameController.text,
          description: descriptionController.text,
          price: int.parse(priceController.text),
          category: selectedCategory!.apiValue!,
          image: pickedImage!,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        submitErrorMessage = e.toString();
        isSubmitting = false;
      });
    }
  }

  InputDecoration _decoration(String label, {String? prefixText}) {
    return InputDecoration(
      labelText: label,
      prefixText: prefixText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoadingDetail) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Memuat data menu..."),
          ],
        ),
      );
    }

    if (loadErrorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 12),
          Text(loadErrorMessage!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: fetchDetail, child: const Text("Coba Lagi")),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "Update Menu" : "Tambah Menu",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildImagePicker(),
            const SizedBox(height: 16),

            TextFormField(
              controller: nameController,
              decoration: _decoration("Nama Menu"),
              validator: (v) => (v == null || v.isEmpty) ? "Nama wajib diisi" : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: descriptionController,
              decoration: _decoration("Deskripsi"),
              maxLines: 3,
              validator: (v) => (v == null || v.isEmpty) ? "Deskripsi wajib diisi" : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: priceController,
              decoration: _decoration("Harga", prefixText: "Rp "),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.isEmpty) ? "Harga wajib diisi" : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<CategoryType>(
              initialValue: selectedCategory,
              decoration: _decoration("Kategori"),
              items: CategoryType.values
                  .where((c) => c.apiValue != null)
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (value) => setState(() => selectedCategory = value),
              validator: (v) => v == null ? "Kategori wajib dipilih" : null,
            ),

            if (submitErrorMessage != null) ...[
              const SizedBox(height: 12),
              Text(submitErrorMessage!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.of(context).pop(false),
                  child: const Text("Batal"),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: isSubmitting ? null : submit,
                  child: isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditMode ? "Update" : "Simpan"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: pickedImage != null
              ? Image.file(pickedImage!, fit: BoxFit.cover, width: double.infinity)
              : (existingImage != null)
                  ? Image.network(
                      "${AppConfig.storageUrl}$existingImage",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Center(
                      child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                    ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 3,
            child: IconButton(
              onPressed: pickImage,
              icon: const Icon(Icons.camera_alt, color: Colors.black87),
              tooltip: "Pilih Gambar",
            ),
          ),
        ),
      ],
    );
  }
}