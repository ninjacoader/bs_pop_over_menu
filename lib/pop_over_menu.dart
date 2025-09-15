import 'package:flutter/material.dart';

class MenuItemModel {
  final Widget icon; // Icon, Image, etc.
  final String title;
  final VoidCallback onTap;

  MenuItemModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class PopoverMenu {
  static OverlayEntry? _entry;

  static void show({
    required BuildContext context,
    required List<MenuItemModel> items,
    double width = 220,
    double itemHeight = 50,
  }) {
    if (_entry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final buttonOffset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final buttonSize = renderBox.size;
    final screenSize = overlay.size;

    // total popover height
    final popHeight = items.length * itemHeight + 16;

    // decide if we show above or below button
    double top = buttonOffset.dy - popHeight;
    if (top < 0) {
      top = buttonOffset.dy + buttonSize.height; // flip below
    }

    // clamp left to stay on screen
    double left = buttonOffset.dx;
    if (left + width > screenSize.width) {
      left = screenSize.width - width - 8; // 8px padding
    }
    if (left < 8) left = 8;

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // dismiss area
            Positioned.fill(
              child: GestureDetector(
                onTap: hide,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),

            // popover card
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((e) {
                      return InkWell(
                        onTap: () {
                          hide();
                          e.onTap();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 36, height: 36, child: e.icon),
                              const SizedBox(width: 12),
                              Text(
                                e.title,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
