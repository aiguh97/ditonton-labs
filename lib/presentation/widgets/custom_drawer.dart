import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final Widget content;
  final Widget drawerContent;

  const CustomDrawer({
    super.key,
    required this.content,
    required this.drawerContent,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      isDrawerOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxSlide = 250;

    return Scaffold(
      body: Stack(
        children: [
          // Drawer content (background)
          widget.drawerContent,

          // Main content with animation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double slide = maxSlide * _controller.value;
              double scale = 1 - (_controller.value * 0.3);
              double borderRadius = _controller.value * 30;

              return Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: isDrawerOpen ? toggleDrawer : null,
                  child: AbsorbPointer(
                    absorbing: isDrawerOpen,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          title: const Text(
                            'Ditonton',
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: toggleDrawer,
                          ),
                        ),
                        body: widget.content,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
