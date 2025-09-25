import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article.dart';
import '../controllers/news_controller.dart';
import '../pages/detail_page.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final bool showFavoriteButton;
  final NewsController controller = Get.find<NewsController>();

  NewsCard({required this.article, this.showFavoriteButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(
            () => DetailPage(article: article),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 300),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                SizedBox(width: 16),
                _buildContentSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Hero(
      tag: 'news_image_${article.url}',
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: article.urlToImage.isNotEmpty
              ? Image.network(
                  article.urlToImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildImagePlaceholder();
                  },
                )
              : _buildImagePlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Icon(Icons.image_rounded, size: 32, color: Colors.grey[400]),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildSourceAndTimeInfo(), SizedBox(height: 8)],
                ),
              ),
              if (showFavoriteButton) _buildFavoriteButton(),
            ],
          ),
          _buildTitle(),
          SizedBox(height: 8),
          _buildTimeAgo(),
        ],
      ),
    );
  }

  Widget _buildSourceAndTimeInfo() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            article.source,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.orange[600],
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '12 min reads',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      article.title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: Colors.black,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTimeAgo() {
    return Text(
      _formatDate(article.publishedAt),
      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
    );
  }

  Widget _buildFavoriteButton() {
    return Obx(
      () => Container(
        width: 24,
        height: 24,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.toggleFavorite(article),
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              controller.isFavorite(article)
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 18,
              color: controller.isFavorite(article)
                  ? Colors.red[600]
                  : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} min ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} min ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min ago';
      } else {
        return '1 min ago';
      }
    } catch (e) {
      return '1 min ago';
    }
  }
}
