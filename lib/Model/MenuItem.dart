import 'package:flutter/material.dart';

class MenuItemModel {
  final String titulo;
  final String? imagem;      // caminho da imagem (assets ou URL)
  final VoidCallback onTap;

  const MenuItemModel({
    required this.titulo,
    this.imagem,
    required this.onTap,
  });
}

