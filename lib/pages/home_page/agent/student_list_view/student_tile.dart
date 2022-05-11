import 'package:auto_size_text/auto_size_text.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:elite_counsel/bloc/cubit/student_application_cubit.dart';
import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/pages/student_detail_page.dart';
import 'package:elite_counsel/variables.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({
    Key? key,
    this.trackApplicationID,
  }) : super(key: key);

  final String? trackApplicationID;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentApplicationCubit, Student>(
      builder: (context, student) {
        String courseName = '';
        Application? applicationToTrack;
        int? indexWhere = student.applications?.indexWhere(
          (element) => element.applicationID == trackApplicationID,
        );
        if (indexWhere != null && indexWhere != -1) {
          applicationToTrack = student.applications![indexWhere];

          courseName = applicationToTrack.courseName!;
        }

        return Padding(
          key: student.applyingFor!.isNotEmpty
              ? ValueKey(student.applyingFor)
              : null,
          padding: const EdgeInsets.all(8.0),
          child: Neumorphic(
            style: NeumorphicStyle(
              shadowLightColor: Colors.white.withOpacity(0.6),
              depth: -1,
              lightSource: LightSource.topLeft.copyWith(dx: -2, dy: -2),
              shadowDarkColor: Colors.black,
              color: Variables.backgroundColor,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return StudentDetailPage(
                    student: student,
                  );
                }));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.all(8),
                    leading: Container(
                      height: 70,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(student.photo ??
                              "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Container(
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 5),
                      child: AutoSizeText(
                        (student.name ?? "") != ""
                            ? (student.name!.trim())
                            : "No name",
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: applicationToTrack != null
                        ? ApplicationStatus(
                            application: applicationToTrack,
                          )
                        : null,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          student.course! + " . " + student.year!,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white.withOpacity(0.04)),
                          child: Text(
                            courseName!.isEmpty
                                ? "Verified"
                                : "Applying for " + courseName!,
                            style: const TextStyle(
                                color: Variables.accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (student.marksheet != null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: student.marksheet!.length * 2,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: student.marksheet!.length,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (context, index) {
                          var markData =
                              student.marksheet!.keys.toList(growable: true);
                          for (var element in student.marksheet!.values) {
                            markData.add(element.toString());
                          }

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Variables.accentColor.withOpacity(0.2)),
                            ),
                            child: Center(
                              child: Text(
                                markData[index],
                                style: const TextStyle(
                                    color: Variables.accentColor),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

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
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.04)),
          child: DropdownButton(
              dropdownColor: Variables.backgroundColor,
              underline: Container(),
              iconSize: 0,
              value: state.timeline ?? 0,
              items: [0, 1, 2, 3, 4, 5]
                  .map((e) => DropdownMenuItem<int>(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                setState(() {});
                BlocProvider.of<HomeBloc>(context).getHome();
              }),
        );
      },
    );
  }
}
