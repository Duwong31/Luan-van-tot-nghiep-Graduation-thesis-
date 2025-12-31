import 'package:Celes/data/cubits/favorite/favorite_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatefulWidget {
  final int movieId;
  final bool isFavorited;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onToggle;

  const FavoriteButton({
    super.key,
    required this.movieId,
    required this.isFavorited,
    this.iconColor,
    this.iconSize = 24,
    this.onToggle,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorited = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isFavorited;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorited != widget.isFavorited) {
      setState(() {
        _isFavorited = widget.isFavorited;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Animate
    await _animationController.forward();
    await _animationController.reverse();

    // Toggle state optimistically
    setState(() {
      _isFavorited = !_isFavorited;
    });

    // Call API
    context.read<FavoriteCubit>().toggleFavorite(widget.movieId, !_isFavorited);

    // Call callback
    widget.onToggle?.call();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteActionError) {
          // Revert state on error
          setState(() {
            _isFavorited = !_isFavorited;
          });
        }
      },
      child: GestureDetector(
        onTap: _isLoading ? null : _toggleFavorite,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: _isLoading
                ? SizedBox(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited
                        ? Colors.red
                        : (widget.iconColor ?? Colors.white),
                    size: widget.iconSize,
                  ),
          ),
        ),
      ),
    );
  }
}
