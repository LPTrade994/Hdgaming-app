import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'checkout_page.dart';

class ProductDetailPage extends StatefulWidget {
  final List<String> imageUrls;
  final String description;
  final List<String> faq;

  const ProductDetailPage({
    Key? key,
    required this.imageUrls,
    required this.description,
    required this.faq,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  void _openCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Descrizione'),
            Tab(text: 'FAQ'),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                final url = widget.imageUrls[index];
                return CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.description),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: widget.faq.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('• ${widget.faq[index]}'),
                    );
                  },
                ),
              ],
            ),
          ),
          _AnimatedAddToCartButton(onPressed: _openCheckout),
        ],
      ),
    );
  }
}

class _AnimatedAddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AnimatedAddToCartButton({required this.onPressed});

  @override
  State<_AnimatedAddToCartButton> createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<_AnimatedAddToCartButton> {
  bool _added = false;

  void _handleTap() {
    setState(() {
      _added = !_added;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 48,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                _added ? 'Added' : 'Add to Cart',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
