import 'package:flutter/material.dart';
import '../Model/MenuItem.dart';

class MenuCard extends StatelessWidget {
  final MenuItemModel item;

  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Card(
        color: const Color(0xFF4F9977),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.imagem != null) 
                Image.asset(
                  item.imagem!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 12),
              Text(
                item.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
