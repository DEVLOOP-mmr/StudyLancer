import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/cubit/student_application_cubit.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/variables.dart';

class ApplicationStatus extends StatefulWidget {
  const ApplicationStatus({
    Key? key,
    required this.application,
  }) : super(key: key);
  final Application application;

  @override
  State<ApplicationStatus> createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends State<ApplicationStatus> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentApplicationCubit, Application>(
      builder: (context, state) {
        return Container(
          key: UniqueKey(),
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white.withOpacity(0.04)),
          child: DropdownButton(
              dropdownColor: Variables.backgroundColor,
              underline: Container(),
              iconSize: 20,
              value: widget.application.progress ?? 0,
              items: [0, 1, 2, 3, 4, 5]
                  .map((progressValue) => DropdownMenuItem<int>(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            ' ' +
                                (StudentApplicationCubit
                                        .parseProgressTitleFromValue(
                                      progressValue,
                                    ) ??
                                    ''),
                            style: const TextStyle(
                              color: Variables.accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        value: progressValue,
                      ))
                  .toList(),
              onChanged: (val) {
                BlocProvider.of<StudentApplicationCubit>(context)
                    .changeApplicationProgress(
                  val as int,
                );

                BlocProvider.of<HomeBloc>(context).getHome();
              }),
        );
      },
    );
  }
}
