import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../models/media_item.dart';
import '../widgets/media_card.dart';
import '../widgets/parallax_background.dart';
import '../widgets/glow_button.dart';
import '../theme/app_theme.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<MediaItem> _galleryItems = [];

  @override
  void initState() {
    super.initState();
    _loadGalleryItems();
  }

  void _loadGalleryItems() {
    // Mock data for demonstration
    setState(() {
      _galleryItems = List.generate(
        15,
        (index) => MediaItem(
          id: 'gallery_$index',
          imageUrl: '',
          prompt: 'My amazing creation ${index + 1}',
          name: 'Artwork ${index + 1}',
          createdAt: DateTime.now().subtract(Duration(days: index)),
          type: index % 3 == 0 ? MediaType.video : MediaType.image,
        ),
      );
    });
  }

  void _showDetailView(MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _DetailScreen(item: item, onDelete: () {
          setState(() {
            _galleryItems.removeWhere((i) => i.id == item.id);
          });
          Navigator.pop(context);
        }),
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
              title: const Text('My Gallery'),
              actions: [
                IconButton(
                  onPressed: _loadGalleryItems,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            if (_galleryItems.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No creations yet',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start generating to see your work here',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
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
                          item: _galleryItems[index],
                          onTap: () => _showDetailView(_galleryItems[index]),
                        ),
                      );
                    },
                    childCount: _galleryItems.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailScreen extends StatefulWidget {
  final MediaItem item;
  final VoidCallback onDelete;

  const _DetailScreen({
    required this.item,
    required this.onDelete,
  });

  @override
  State<_DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<_DetailScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _download() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started...'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _delete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Creation'),
        content: const Text('Are you sure you want to delete this creation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
            color: Colors.redAccent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: widget.item.id,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    widget.item.type == MediaType.image
                        ? Icons.image
                        : Icons.video_library,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Date',
              DateFormat('MMM dd, yyyy').format(widget.item.createdAt),
              Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Type',
              widget.item.type == MediaType.image ? 'Image' : 'Video',
              Icons.category,
            ),
            const SizedBox(height: 24),
            Text(
              'Prompt Used',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.item.prompt,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 32),
            GlowButton(
              text: 'Download',
              icon: Icons.download,
              onPressed: _download,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
