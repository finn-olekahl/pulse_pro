import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pulse_pro/features/trainings_plan/view/widgets/inverted_image.dart';
import 'package:pulse_pro/shared/helpers/capitalize.dart';
import 'package:pulse_pro/shared/models/exercise.dart';
import 'package:pulse_pro/shared/models/split_day.dart';

class ExerciseListItem extends StatefulWidget {
  const ExerciseListItem(
      {super.key,
      required this.index,
      required this.splitDay,
      required this.exercises,
      required this.openIndex,
      required this.setOpenIndex});

  final int index;
  final SplitDay splitDay;
  final Map<String, Exercise> exercises;
  final int? openIndex;
  final Function(int?, bool) setOpenIndex;

  @override
  State<ExerciseListItem> createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {
  void toggleDescription() {
    if (widget.openIndex == widget.index) {
      widget.setOpenIndex(null, true); // Close if already open
    } else {
      widget.setOpenIndex(widget.index, false); // Open this item
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.splitDay.exercises![widget.index];
    bool descriptionOpen = widget.openIndex == widget.index;
    return GestureDetector(
      onTap: toggleDescription,
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade100.withOpacity(0.075),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            capitalize(widget.exercises[exercise.id]!.name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          '${exercise.sets}x${exercise.reps} Reps',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color:
                                  Colors.deepPurple.shade100.withOpacity(0.6)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Transform.translate(
                      offset: const Offset(3, 0),
                      child: Transform(
                        transform: Matrix4.skewX(-0.15),
                        child: Row(
                          children: [
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              turns:
                                  widget.openIndex == widget.index ? 0.25 : 0,
                              child: Transform.translate(
                                offset: const Offset(0, 1),
                                child: FaIcon(
                                  FontAwesomeIcons.caretRight,
                                  size: 15,
                                  color: Colors.deepPurple.shade100
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepPurple.shade100
                                      .withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: descriptionOpen ? null : 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          widget.exercises[exercise.id]!.instructions.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.deepPurple.shade100
                                            .withOpacity(0.5)),
                                  ),
                                  Expanded(
                                    child: Text(
                                      capitalize(widget.exercises[exercise.id]!
                                          .instructions[index]),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.deepPurple.shade100
                                              .withOpacity(0.8)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )..addAll([
                            Padding(
                              padding: const EdgeInsets.all(40),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: InvertedImage(
                                  imageProvider:
                                      widget.exercises[exercise.id]!.gif,
                                ),
                              ),
                            ),
                          ]),
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
