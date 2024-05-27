import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse_pro/features/home/view/widgets/dock/dock_controller.dart';
import 'package:pulse_pro/features/home/view/widgets/dock/measure_size.dart';

class Dock extends StatefulWidget {
  final DockController? controller;
  final int currentIndex;
  final List<DockItem> items;
  final EdgeInsets initialPadding;
  final ValueChanged<int> onTap;

  const Dock({
    super.key,
    this.controller,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    required this.initialPadding,
  });

  @override
  State<Dock> createState() => DockState();
}

class DockState extends State<Dock> with TickerProviderStateMixin {
  int currentIndexAbs = 0;
  int currentIndexAbsDelayed = 0;
  int lastIndexAbs = 0;
  List<int> indexes = <int>[];
  List<int> indexesAbs = <int>[];

  List<Widget> tiles = [];
  List<double> tileWidths = [];
  late double tilesWidth;
  final List<double> _tileWidthsPreScale = [];
  GlobalKey dockContentGlobalKey = GlobalKey();

  @override
  void initState() {
    widget.controller?.addListener(() {
      if (widget.controller!.setCurrentIndex) {
        setIndex(indexes[widget.controller!.currentIndex],
            indexesAbs[widget.controller!.currentIndex]);
      }
      if (widget.controller!.setCurrentSliderIndex) {
        setSliderIndex(indexes[widget.controller!.currentSliderIndex],
            indexesAbs[widget.controller!.currentSliderIndex]);
      }
    });

    currentIndexAbs = widget.currentIndex;
    currentIndexAbsDelayed = widget.currentIndex;
    lastIndexAbs = widget.currentIndex;
    super.initState();
  }

  void getTileWidths() {
    if (_tileWidthsPreScale.isEmpty || tileWidths.isNotEmpty) return;
    late double widthMultiplier;

    widthMultiplier = dockContentGlobalKey.currentContext!.size!.width /
        _tileWidthsPreScale.reduce((value, element) => value + element);
    tileWidths.addAll(_tileWidthsPreScale.map((e) => e * widthMultiplier));
    tilesWidth = dockContentGlobalKey.currentContext!.size!.width;

    setState(() {});
  }

  void setIndex(int index, indexAbs) {
    widget.onTap.call(index);
    setDelayedIndex();
    currentIndexAbs = indexAbs;
    //widget.controller?.currentIndex = indexAbs;
  }

  void setSliderIndex(int index, indexAbs) {
    setState(() {
      setDelayedIndex();
      currentIndexAbs = indexAbs;
      widget.controller?.currentIndex = indexAbs;
    });
  }

  void setDelayedIndex() {
    var timer = Future.delayed(const Duration(milliseconds: 35));
    timer.whenComplete(() {
      setState(() {
        currentIndexAbsDelayed = currentIndexAbs;
        lastIndexAbs = currentIndexAbs;
      });
    });
  }

  bool getTabDirection() {
    if (currentIndexAbs > lastIndexAbs || currentIndexAbs == lastIndexAbs) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getTileWidths();
    });
    MediaQuery.of(context).size.width -
        widget.initialPadding.left -
        widget.initialPadding.right;
    tiles = createTiles();
    widget.controller?.indexes = indexes;

    return Padding(
      padding: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: MediaQuery.of(context).padding.bottom + 10),
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                width: 2,
                color: Colors.deepPurple.shade300.withOpacity(0.15),
                strokeAlign: BorderSide.strokeAlignOutside),
          ),
          child: SizedBox(
            height: 50,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                if (tileWidths.isNotEmpty)
                  AnimatedPositioned(
                    top: 0,
                    bottom: 0,
                    left: (getTabDirection()
                        ? tileWidths
                                .take(currentIndexAbsDelayed + 1)
                                .reduce((value, element) => value + element) -
                            tileWidths.elementAt(currentIndexAbsDelayed)
                        : tileWidths
                                .take(currentIndexAbs + 1)
                                .reduce((value, element) => value + element) -
                            tileWidths.elementAt(currentIndexAbs)),
                    right: tilesWidth -
                        (getTabDirection()
                            ? tileWidths
                                .take(currentIndexAbs + 1)
                                .reduce((value, element) => value + element)
                            : tileWidths
                                .take(currentIndexAbsDelayed + 1)
                                .reduce((value, element) => value + element)),
                    duration: const Duration(milliseconds: 300),
                    curve: const Cubic(0, 0, 0, 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Center(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: FittedBox(
                    key: dockContentGlobalKey,
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: tiles,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  List<DockTile> createTiles() {
    List<DockTile> tabTiles = <DockTile>[];
    int currIndex = 0;

    widget.items.asMap().forEach((i, item) {
      indexesAbs.add(i);
      indexes.add(currIndex);
      switch (item.runtimeType) {
        case const (DockTabItem):
          final _DockTabTile tile = _DockTabTile(
            onBuildGetWidth: (width) {
              _tileWidthsPreScale.add(width);
              setState(() {});
            },
            minWidth: (MediaQuery.of(context).size.width -
                    (widget.initialPadding.left +
                        widget.initialPadding.right)) /
                widget.items.length,
            text: item.text,
            callback: () {
              setIndex(indexes[i], indexesAbs[i]);
              widget.controller?.currentIndex = indexesAbs[1];
              HapticFeedback.lightImpact();
            },
            child: (item as DockTabItem).child,
          );
          tabTiles.add(tile);
          currIndex++;
          break;
        case const (DockFunctionItem):
          _DockFunctionTile tile = _DockFunctionTile(
            onBuildGetWidth: (width) {
              _tileWidthsPreScale.add(width);
              setState(() {});
            },
            minWidth: (MediaQuery.of(context).size.width -
                    (widget.initialPadding.left +
                        widget.initialPadding.right)) /
                widget.items.length,
            icon: item.icon,
            backgroundColor: (item as DockFunctionItem).iconColor,
            function: item.function,
            child: (item).child,
          );
          tabTiles.add(tile);
          break;
      }
    });

    widget.controller?.size = tabTiles.length;
    return tabTiles;
  }
}

abstract class DockTile extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final double minWidth;
  final Function(double)? onBuildGetWidth;

  const DockTile({
    super.key,
    this.text,
    this.icon,
    required this.minWidth,
    this.onBuildGetWidth,
  });
}

class _DockTabTile extends DockTile {
  final void Function() callback;
  final Widget? child;
  const _DockTabTile(
      {required super.text,
      required super.minWidth,
      required this.callback,
      this.child,
      super.onBuildGetWidth});

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
        onChange: (size) => {onBuildGetWidth?.call(size.width)},
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: callback,
          child: Container(
            constraints: BoxConstraints(minWidth: minWidth, minHeight: 55),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: child ??
                    Text(
                      text ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple.shade200,
                      ),
                    ),
              ),
            ),
          ),
        ));
  }
}

class _DockFunctionTile extends DockTile {
  final void Function() function;
  final Color? backgroundColor;
  final Widget? child;
  final IconData? icon;
  final String? text;
  const _DockFunctionTile(
      {required this.function,
      required super.minWidth,
      this.icon,
      this.text,
      this.backgroundColor,
      super.onBuildGetWidth,
      this.child});

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (size) => {onBuildGetWidth?.call(size.width)},
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: function,
        child: Container(
            constraints: BoxConstraints(minWidth: minWidth),
            color: Colors.transparent,
            child: Center(
              child: text != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        text!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : child ??
                      Icon(
                        icon,
                        color: backgroundColor,
                      ),
            )),
      ),
    );
  }
}

class DockItem {
  final String? text;
  final IconData? icon;

  DockItem({this.text, this.icon});
}

class DockTabItem extends DockItem {
  Widget? child;

  DockTabItem({required super.text, this.child});
}

class DockFunctionItem extends DockItem {
  final void Function() function;
  Color? iconColor = Colors.grey;
  Widget? child = Container();

  DockFunctionItem(
      {super.icon, required this.function, this.iconColor, this.child});
}
