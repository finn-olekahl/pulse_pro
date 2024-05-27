import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pulse_pro/shared/models/muscle_group.dart';
import 'package:xml/xml.dart' as xml;

class MuscleIndicator extends StatefulWidget {
  final List<MuscleGroup> muscleGroups;
  final Color silhouetteColor;
  final Color muscleBaseColor;
  final Color muscleHighlightColor;

  const MuscleIndicator(
      {super.key,
      required this.muscleGroups,
      required this.silhouetteColor,
      required this.muscleBaseColor,
      required this.muscleHighlightColor});

  @override
  MuscleIndicatorState createState() => MuscleIndicatorState();
}

class MuscleIndicatorState extends State<MuscleIndicator> {
  String _frontSvgString = '';
  String _backSvgString = '';
  SvgPicture? _frontSvgPicture;
  SvgPicture? _backSvgPicture;

  @override
  void initState() {
    super.initState();
    _loadSvgAssets();
  }

  Future<void> _loadSvgAssets() async {
    final frontSvgString =
        await rootBundle.loadString('assets/images/body_front.svg');
    final backSvgString =
        await rootBundle.loadString('assets/images/body_back.svg');

    setState(() {
      _frontSvgString = frontSvgString;
      _backSvgString = backSvgString;
      _frontSvgPicture = SvgPicture.string(
        _updateSvgOpacityAndColor(
            _frontSvgString, _getHighlightIds(widget.muscleGroups)),
        fit: BoxFit.contain,
      );
      _backSvgPicture = SvgPicture.string(
        _updateSvgOpacityAndColor(
            _backSvgString, _getHighlightIds(widget.muscleGroups)),
        fit: BoxFit.contain,
      );
    });
  }

  Map<MuscleGroup, List<String>> _muscleGroupToIdsMap() {
    return {
      MuscleGroup.abs: ['abs'],
      MuscleGroup.abductors: ['abductors'],
      MuscleGroup.adductors: ['adductors'],
      MuscleGroup.arms: ['biceps', 'triceps', 'forearms'],
      MuscleGroup.back: ['lats', 'traps', 'lowerBack'],
      MuscleGroup.biceps: ['biceps'],
      MuscleGroup.calves: ['calves'],
      MuscleGroup.chest: ['chest'],
      MuscleGroup.core: ['abs', 'obliques'],
      MuscleGroup.forearms: ['forearms'],
      MuscleGroup.fullBody: [
        'abs',
        'abductors',
        'adductors',
        'biceps',
        'triceps',
        'forearms',
        'lats',
        'traps',
        'lowerBack',
        'chest',
        'calves',
        'glutes',
        'hamstrings',
        'quads',
        'shoulders',
        'obliques'
      ],
      MuscleGroup.glutes: ['glutes'],
      MuscleGroup.hamstrings: ['hamstrings'],
      MuscleGroup.legs: [
        'adductors',
        'abductors',
        'hamstrings',
        'quads',
        'calves',
        'glutes'
      ],
      MuscleGroup.lowerBack: ['lowerBack'],
      MuscleGroup.lowerBody: [
        'adductors',
        'abductors',
        'hamstrings',
        'quads',
        'calves',
        'glutes',
        'lowerBack',
        'obliques',
        'abs'
      ],
      MuscleGroup.obliques: ['obliques'],
      MuscleGroup.quads: ['quads'],
      MuscleGroup.shoulders: ['shoulders'],
      MuscleGroup.traps: ['traps'],
      MuscleGroup.triceps: ['triceps'],
      MuscleGroup.upperBack: ['lats', 'traps'],
      MuscleGroup.upperBody: [
        'traps',
        'forearms',
        'lats',
        'biceps',
        'triceps',
        'shoulders',
        'chest'
      ],
    };
  }

  List<String> _getHighlightIds(List<MuscleGroup> muscleGroups) {
    final muscleGroupToIds = _muscleGroupToIdsMap();
    final highlightIds = <String>{};

    for (final muscleGroup in muscleGroups) {
      if (muscleGroupToIds.containsKey(muscleGroup)) {
        highlightIds.addAll(muscleGroupToIds[muscleGroup]!);
      }
    }

    return highlightIds.toList();
  }

  String _updateSvgOpacityAndColor(
      String svgString, List<String> highlightIds) {
    final document = xml.XmlDocument.parse(svgString);
    final idsToHighlight = highlightIds.toSet();

    final silhouetteColorHex =
        '#${widget.silhouetteColor.value.toRadixString(16).substring(2)}';
    final silhouetteOpacity = widget.silhouetteColor.opacity.toString();

    final muscleHighlightColorHex =
        '#${widget.muscleHighlightColor.value.toRadixString(16).substring(2)}';
    final muscleHighlightOpacity =
        widget.muscleHighlightColor.opacity.toString();

    final muscleBaseColorHex =
        '#${widget.muscleBaseColor.value.toRadixString(16).substring(2)}';
    final muscleBaseOpacity = widget.muscleBaseColor.opacity.toString();

    void setAttributesForElementAndParents(
        xml.XmlElement element, String opacity, String color) {
      element.setAttribute('opacity', opacity);
      element.setAttribute('style', 'fill: $color; stroke-width: 0px;');
      final parent = element.parentElement;
      if (parent != null &&
          parent.getAttribute('id') != 'silhouette' &&
          parent.getAttribute('id') != 'silhouette-2') {
        setAttributesForElementAndParents(parent, opacity, color);
      }
    }

    for (final element in document.findAllElements('*')) {
      final elementId = element.getAttribute('id');
      if (elementId != null) {
        if (elementId == 'silhouette' || elementId == 'silhouette-2') {
          element.setAttribute('opacity', silhouetteOpacity);
          element.setAttribute(
              'style', 'fill: $silhouetteColorHex; stroke-width: 0px;');
        } else {
          bool shouldHighlight = false;
          for (final id in idsToHighlight) {
            if (elementId.contains(id)) {
              shouldHighlight = true;
              break;
            }
          }
          if (shouldHighlight) {
            setAttributesForElementAndParents(
                element, muscleHighlightOpacity, muscleHighlightColorHex);
          } else {
            element.setAttribute('opacity',
                muscleBaseOpacity);
            element.setAttribute(
                'style', 'fill: $muscleBaseColorHex; stroke-width: 0px;');
          }
        }
      }
    }

    return document.toXmlString(pretty: true, indent: '\t');
  }

  @override
  Widget build(BuildContext context) {
    if (_frontSvgPicture != null && _backSvgPicture != null) {
      return FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IntrinsicWidth(child: IntrinsicHeight(child: _frontSvgPicture!)),
            IntrinsicWidth(child: IntrinsicHeight(child: _backSvgPicture!))
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
