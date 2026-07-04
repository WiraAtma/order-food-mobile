import 'package:flutter/material.dart';
import 'package:order_food_mobile/core/configs/app_config.dart';
import 'package:order_food_mobile/core/constants/app_colors.dart';
import 'package:order_food_mobile/core/utilities/format_currency.dart';
import 'package:order_food_mobile/services/menu_services.dart';
import 'package:order_food_mobile/views/widgets/form_menu_widget.dart';

class AdminMenuCard extends StatefulWidget {
  final int? id;
  final String? name;
  final String? image;
  final int? price;
  final VoidCallback? onUpdated;

  const AdminMenuCard({
    super.key,
    this.id,
    this.name,
    this.price,
    this.image,
    this.onUpdated,
  });

  @override
  State<AdminMenuCard> createState() => _AdminMenuCardState();
}

class _AdminMenuCardState extends State<AdminMenuCard> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightBlueColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                "${AppConfig.storageUrl}${widget.image}",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name ?? "-",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                  Text(FormatCurrency.toRupiah(widget.price ?? 0)),
                ],
              ),
            ),
            isDeleting
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (widget.id == null) return;

                      switch (value) {
                        case 'update':
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) =>
                                FormMenuWidget(menuId: widget.id),
                          );

                          if (result == true) {
                            widget.onUpdated?.call();
                          }
                          break;
                        case 'delete':
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Menu"),
                              content: Text(
                                "Yakin ingin menghapus \"${widget.name}\"?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Batal"),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            setState(() => isDeleting = true);
                            try {
                              await MenuServices().deleteMenu(widget.id!);
                              widget.onUpdated?.call();
                            } catch (e) {
                              if (mounted) {
                                setState(() => isDeleting = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'update',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 5),
                            Text("Update"),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 5),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
