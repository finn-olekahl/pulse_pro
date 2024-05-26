import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

enum MuscleGroup {
  abs,
  abductors,
  adductors,
  arms,
  back,
  biceps,
  calves,
  chest,
  core,
  forearms,
  fullBody,
  glutes,
  hamstrings,
  legs,
  lowerBack,
  lowerBody,
  obliques,
  quads,
  shoulders,
  traps,
  triceps,
  upperBack,
  upperBody
}

class MuscleHighlightWidget extends StatefulWidget {
  final List<MuscleGroup> muscleGroups;

  const MuscleHighlightWidget({Key? key, required this.muscleGroups})
      : super(key: key);

  @override
  _MuscleHighlightWidgetState createState() => _MuscleHighlightWidgetState();
}

class _MuscleHighlightWidgetState extends State<MuscleHighlightWidget> {
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
        _updateSvgOpacity(
            _frontSvgString, _getHighlightIds(widget.muscleGroups)),
      );
      _backSvgPicture = SvgPicture.string(
        _updateSvgOpacity(
            _backSvgString, _getHighlightIds(widget.muscleGroups)),
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

  String _updateSvgOpacity(String svgString, List<String> highlightIds) {
    final document = xml.XmlDocument.parse(svgString);

    final idsToHighlight = highlightIds.toSet();

    for (final element in document.findAllElements('*')) {
      if (element.getAttribute('id') != null &&
          idsToHighlight.contains(element.getAttribute('id'))) {
        element.setAttribute('opacity', '1.0');
      } else {
        element.setAttribute('opacity', '0.3');
      }

      for (final childElement in element.findAllElements('*')) {
        if (childElement.getAttribute('id') != null &&
            idsToHighlight.contains(childElement.getAttribute('id'))) {
          childElement.setAttribute('opacity', '1.0');
        } else {
          childElement.setAttribute('opacity', '0.3');
        }
      }
    }

    return document.toXmlString(pretty: true, indent: '\t');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double svgWidth = maxWidth / 2 - 5; // Split the available width

        return Column(
          children: [
            if (_frontSvgPicture != null && _backSvgPicture != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: svgWidth,
                    child: _frontSvgPicture!,
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: svgWidth,
                    child: _backSvgPicture!,
                  ),
                ],
              )
            else
              CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
