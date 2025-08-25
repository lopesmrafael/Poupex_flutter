import 'package:flutter/material.dart';
import '../Model/MenuItem.dart';
import '../Widget/MenuCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<MenuItemModel> _getMenuItems(BuildContext context) {
    return [
      MenuItemModel(
        titulo: "Dashboard Financeiro",
        imagem: "assets/icons/dashboard.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Histórico de Atividades",
        imagem: "assets/icons/alarm.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Dicas de Finanças",
        imagem: "assets/icons/money.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Calendário Financeiro",
        imagem: "assets/icons/calendar.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Meus Pontos",
        imagem: "assets/icons/star.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Metas Financeiras",
        imagem: "assets/icons/medal.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Orçamento Mensal",
        imagem: "assets/icons/cauculator.png",
        onTap: () {},
      ),
      MenuItemModel(
        titulo: "Relatório",
        imagem: "assets/icons/table.png",
        onTap: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems(context);

    return Scaffold(
      backgroundColor: const Color(0xFF54A781),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace),
          onPressed: () {},
        ),
        title: Image.asset(
          "assets/titulo.jpg",
          height: 40,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF327355),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          const SizedBox(width: 12),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return MenuCard(item: menuItems[index]);
        },
      ),
    );
  }
}
