import 'package:flutter/material.dart';

class InterestItem {
  final String label;
  bool selected;

  InterestItem({
    required this.label,
    this.selected = false,
  });
}

class OnboardingWizardScreen extends StatefulWidget {
  const OnboardingWizardScreen({super.key});

  @override
  State<OnboardingWizardScreen> createState() => _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState extends State<OnboardingWizardScreen> {
  static const int _totalSteps = 5;
  static const int _currentStep = 3;

  final List<InterestItem> _interests = [
    InterestItem(label: 'Technology'),
    InterestItem(label: 'Entrepreneurship'),
    InterestItem(label: 'Arts & Culture'),
    InterestItem(label: 'Leadership'),
    InterestItem(label: 'Sports'),
    InterestItem(label: 'Community Service'),
    InterestItem(label: 'Academic Research'),
    InterestItem(label: 'Career & Internships'),
  ];

  int get _selectedCount => _interests.where((i) => i.selected).length;

  void _toggle(int index) {
    setState(() {
      _interests[index].selected = !_interests[index].selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1F3C), Color(0xFF071020)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProgressBar(),
                const SizedBox(height: 32),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3A6B),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1565C0).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.interests_rounded, color: Colors.white, size: 36),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'What are you into?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your interests so ANDRO can surface the\nright events and communities for you.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.1,
                        ),
                    itemCount: _interests.length,
                    itemBuilder: (context, index) {
                      final item = _interests[index];
                      return GestureDetector(
                        onTap: () => _toggle(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: item.selected
                                ? const Color(0xFF0D2E5E)
                                : const Color(0xFF0F1F3A),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: item.selected
                                  ? const Color(0xFF2979FF)
                                  : const Color(0xFF1E3459),
                              width: item.selected ? 1.5 : 1.0,
                            ),
                            boxShadow: item.selected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2979FF,
                                      ).withOpacity(0.2),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: item.selected
                                        ? const Color(0xFF4FA3FF)
                                        : Colors.white.withOpacity(0.75),
                                    fontSize: 13,
                                    fontWeight: item.selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedCount == 0
                      ? 'Select at least 1 to continue'
                      : '$_selectedCount selected · Select at least 1 to continue',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                _buildContinueButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(_totalSteps, (index) {
        Color color;
        if (index < _currentStep) {
          color = const Color(0xFF2979FF);
        } else if (index == _currentStep) {
          color = const Color(0xFFFFC107);
        } else {
          color = Colors.white.withOpacity(0.2);
        }
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContinueButton() {
    final enabled = _selectedCount > 0;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF2979FF)],
                )
              : null,
          color: enabled ? null : const Color(0xFF1A2A44),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled
                ? () {
                    // TODO: navigate to next step
                  }
                : null,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: enabled
                          ? Colors.white
                          : Colors.white.withOpacity(0.35),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: enabled
                        ? Colors.white
                        : Colors.white.withOpacity(0.35),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
