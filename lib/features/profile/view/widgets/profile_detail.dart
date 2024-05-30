import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse_pro/features/profile/cubit/profile_cubit.dart';

class ProfileDetail extends StatefulWidget {
  final String label;
  final String value;
  final Function() onEdit;

  const ProfileDetail({
    super.key,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 130),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status != ProfileStatus.loaded &&
            state.status != ProfileStatus.initial) {
          _controller.repeat(reverse: true);
          return;
        }
        _controller.stop();
      },
      builder: (context, state) {
        return Expanded(
          child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _controller.isAnimating ? _controller.value * 0.03 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade300.withOpacity(0.175),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.label,
                                style: TextStyle(
                                  color: Colors.deepPurple.shade100
                                      .withOpacity(0.4),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (state.status != ProfileStatus.loaded &&
                                  state.status != ProfileStatus.initial)
                                const Spacer(),
                              if (state.status != ProfileStatus.loaded &&
                                  state.status != ProfileStatus.initial)
                                GestureDetector(
                                  onTap: widget.onEdit,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple.shade400,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        size: 15,
                                        Icons.edit,
                                        color: Colors.deepPurple.shade100,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Transform.translate(
                            offset: const Offset(3, 0),
                            child: Transform(
                              transform: Matrix4.skewX(-0.15),
                              child: Text(
                                widget.value,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.deepPurple.shade100,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
