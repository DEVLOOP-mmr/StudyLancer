import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/cubit/student_application_cubit.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/student_detail_page.dart';
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
    return BlocBuilder<StudentApplicationCubit, Student>(
      builder: (context, state) {
        return Container(
          key: UniqueKey(),
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.04)),
          child: DropdownButton(
              dropdownColor: Variables.backgroundColor,
              underline: Container(),
              iconSize: 0,
              value: widget.application.progress ?? 0,
              items: [0, 1, 2, 3, 4, 5]
                  .map((e) => DropdownMenuItem<int>(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                              StudentApplicationCubit
                                      .parseProgressTitleFromValue(e) ??
                                  '',
                              style: const TextStyle(
                                  color: Variables.accentColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                        value: e,
                      ))
                  .toList(),
              onChanged: (val) {
                BlocProvider.of<StudentApplicationCubit>(context)
                    .changeApplicationProgress(
                  widget.application.applicationID!,
                  val as int,
                );
              
                BlocProvider.of<HomeBloc>(context).getHome();
              }),
        );
      },
    );
  }
}
