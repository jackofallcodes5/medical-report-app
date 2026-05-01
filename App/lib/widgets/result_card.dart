import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultCard extends StatelessWidget {
  final String text;

  const ResultCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF162232), Color(0xFF1B2E3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF1DB954).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1DB954).withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DB954).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF1DB954),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'AI Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildCopyButton(context),
              ],
            ),
            const SizedBox(height: 16),

            // ── Divider ─────────────────────────────────
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1DB954).withOpacity(0.3),
                    const Color(0xFF1DB954).withOpacity(0.05),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── AI Response Text ────────────────────────
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFFCBD5E0),
                fontSize: 14.5,
                height: 1.7,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.copy_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text('Copied to clipboard'),
                ],
              ),
              backgroundColor: const Color(0xFF1B2838),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2D4059).withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, color: Color(0xFF8FA3B0), size: 14),
              SizedBox(width: 4),
              Text(
                'Copy',
                style: TextStyle(
                  color: Color(0xFF8FA3B0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
