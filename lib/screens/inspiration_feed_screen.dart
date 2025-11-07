import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/media_item.dart';
import '../widgets/media_card.dart';
import '../widgets/parallax_background.dart';
import '../widgets/glow_button.dart';
import '../theme/app_theme.dart';

class InspirationFeedScreen extends StatefulWidget {
  const InspirationFeedScreen({super.key});

  @override
  State<InspirationFeedScreen> createState() => _InspirationFeedScreenState();
}

class _InspirationFeedScreenState extends State<InspirationFeedScreen> {
  List<MediaItem> _inspirationItems = [];

  @override
  void initState() {
    super.initState();
    _loadInspirationItems();
  }

  void _loadInspirationItems() {
    // Mock data for demonstration
    setState(() {
      _inspirationItems = List.generate(
        20,
        (index) => MediaItem(
          id: 'inspiration_$index',
          imageUrl: '',
          prompt: 'A stunning ${_getRandomPrompt(index)} with vibrant colors and dramatic lighting',
          name: 'Creation ${index + 1}',
          createdAt: DateTime.now().subtract(Duration(days: index)),
          type: MediaType.image,
        ),
      );
    });
  }

  String _getRandomPrompt(int index) {
    final prompts = [
      'sunset over mountains',
      'futuristic city',
      'mystical forest',
      'underwater scene',
      'abstract art',
      'space galaxy',
      'ancient temple',
      'cyberpunk street',
    ];
    return prompts[index % prompts.length];
  }

  void _showPromptDetail(MediaItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prompt',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              item.prompt,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            GlowButton(
              text: 'Use Prompt',
              icon: Icons.auto_awesome,
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to generator with this prompt
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Prompt copied: ${item.prompt}'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParallaxBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.backgroundLight.withOpacity(0.9),
              title: const Text('Inspiration'),
              actions: [
                IconButton(
                  onPressed: _loadInspirationItems,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FadeInUp(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      child: MediaCard(
                        item: _inspirationItems[index],
                        onTap: () => _showPromptDetail(_inspirationItems[index]),
                      ),
                    );
                  },
                  childCount: _inspirationItems.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
