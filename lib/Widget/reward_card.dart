import 'package:flutter/material.dart';
import 'package:projeto_pity/Model/reward.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final int userPoints;

  const RewardCard({super.key, required this.reward, required this.userPoints});

  @override
  Widget build(BuildContext context) {
    final bool canRedeem = userPoints >= reward.pontos;

    return Card(
      color: const Color(0xFF4F9977),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              reward.imagem,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          reward.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          reward.descricao,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${reward.pontos} pontos",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: canRedeem ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canRedeem
                          ? Colors.green
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("ESCOLHER"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
