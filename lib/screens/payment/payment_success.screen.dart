import 'package:flutter/material.dart';
import 'dart:math';

import 'package:spresearchvia2/widgets/button.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  final List<ConfettiParticle> _confettiParticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );

    for (int i = 0; i < 50; i++) {
      _confettiParticles.add(
        ConfettiParticle(
          x: _random.nextDouble(),
          y: -0.1 - (_random.nextDouble() * 0.2),
          color: _getRandomColor(),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 4,
          size: _random.nextDouble() * 8 + 4,
          velocityX: (_random.nextDouble() - 0.5) * 0.3,
          velocityY: _random.nextDouble() * 0.5 + 0.5,
        ),
      );
    }

    _confettiController.forward();
  }

  Color _getRandomColor() {
    List<Color> colors = [
      Color(0xff2563EB),
      Color(0xff8DB4A0),
      Color(0xffF59E0B),
      Color(0xffEF4444),
      Color(0xff8B5CF6),
      Color(0xff10B981),
      Color(0xffEC4899),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: -10,
                        right: 40,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(0xff7C9CB6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: -10,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(0xff8DB4A0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 40,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color(0xff8DB4A0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xff8DB4A0),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 20,
                              color: Color(0xff8DB4A0).withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 60),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  Text(
                    'Payment\nSuccessful!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1F2937),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff6B7280),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Your subscription is valid until\n'),
                        TextSpan(
                          text: '25/08/2025',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        DetailRow(label: 'Plan', value: 'Premium Monthly'),
                        SizedBox(height: 16),
                        DetailRow(label: 'Amount', value: '\$29.99'),
                        SizedBox(height: 16),
                        DetailRow(label: 'Next billing', value: '25/09/2024'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Button(
                    title: 'Go To Dashboard',
                    buttonType: ButtonType.blue,
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  Button(
                    title: 'View Reciept',
                    buttonType: ButtonType.blue,
                    onTap: () {},
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff6B7280),
                          ),
                          children: [
                            TextSpan(text: 'Need help? '),
                            TextSpan(
                              text: 'Contact Support',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2563EB),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(
                  particles: _confettiParticles,
                  progress: _confettiController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  final Color color;
  double rotation;
  final double rotationSpeed;
  final double size;
  final double velocityX;
  final double velocityY;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    required this.velocityX,
    required this.velocityY,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      double currentY = particle.y + (particle.velocityY * progress);
      double currentX = particle.x + (particle.velocityX * progress * 0.5);
      double currentRotation =
          particle.rotation + (particle.rotationSpeed * progress * 2 * pi);

      double fadeStart = 0.85;
      double opacity = 1.0;

      if (progress > fadeStart) {
        opacity = 1.0 - ((progress - fadeStart) / (1.0 - fadeStart));
      }

      if (opacity < 0) opacity = 0;

      if (currentY <= 1.1 && opacity > 0) {
        double actualX = currentX * size.width;
        double actualY = currentY * size.height;

        canvas.save();
        canvas.translate(actualX, actualY);
        canvas.rotate(currentRotation);

        final paint = Paint()
          ..color = particle.color.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.size,
            height: particle.size * 1.5,
          ),
          paint,
        );

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}

class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff1F2937),
          ),
        ),
      ],
    );
  }
}
