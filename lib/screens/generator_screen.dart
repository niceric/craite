import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/media_item.dart';
import '../widgets/parallax_background.dart';
import '../widgets/glow_button.dart';
import '../theme/app_theme.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  MediaType _selectedType = MediaType.image;
  bool _isGenerating = false;

  final List<String> _surpriseMePrompts = [
    'A majestic dragon soaring through a stormy sky with lightning in the background',
    'A futuristic cityscape at sunset with flying cars and holographic billboards',
    'An enchanted forest with glowing mushrooms and fairy lights',
    'A cyberpunk street market with neon signs and diverse characters',
    'An underwater civilization with crystal domes and bioluminescent creatures',
    'A steampunk airship floating above a Victorian-era city',
    'A mystical library filled with floating books and magical artifacts',
    'A serene Japanese garden with cherry blossoms and a koi pond at twilight',
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _surpriseMe() {
    final randomPrompt = (_surpriseMePrompts..shuffle()).first;
    _promptController.text = randomPrompt;
    setState(() {});
  }

  Future<void> _generate() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a prompt'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    // Simulate generation
    await Future.delayed(const Duration(seconds: 3));

    setState(() => _isGenerating = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedType == MediaType.image ? 'Image' : 'Video'} generated successfully!'),
          backgroundColor: AppTheme.primaryBlue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParallaxBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInDown(
                  child: Text(
                    'Create with AI',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Transform your imagination into reality',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: _buildMediaTypeSelector(),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: _buildPromptInput(),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: OutlinedButton.icon(
                    onPressed: _surpriseMe,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Surprise Me!'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      side: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: GlowButton(
                    text: 'Generate',
                    icon: Icons.auto_awesome,
                    onPressed: _generate,
                    isLoading: _isGenerating,
                  ),
                ),
                const SizedBox(height: 32),
                if (_isGenerating)
                  FadeIn(
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Creating your masterpiece...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              MediaType.image,
              Icons.image,
              'Image',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTypeButton(
              MediaType.video,
              Icons.video_library,
              'Video',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(MediaType type, IconData icon, String label) {
    final isSelected = _selectedType == type;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptInput() {
    return TextField(
      controller: _promptController,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: 'Describe what you want to create...',
        labelText: 'Your Prompt',
      ),
    );
  }
}
