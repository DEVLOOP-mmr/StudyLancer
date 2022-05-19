import 'package:auto_size_text/auto_size_text.dart';
import 'package:elite_counsel/pages/home_page/agent/student_list_view/student_tile/application_progress_button.dart';
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentApplicationCubit, Application>(
      builder: (context, application) {
        String courseName = '';

        courseName =
            application.status == 1 ? '' : application.courseName ?? '';

        return Padding(
          key: ValueKey(application.applicationID ?? application.student!.id!),
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
                    student: application.student!,
                    application: application,
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
                          image: NetworkImage(application.student?.photo ??
                              "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Container(
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 5),
                      child: AutoSizeText(
                        (application.student?.name ?? "") != ""
                            ? (application.student!.name!.trim())
                            : "No name",
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    trailing: application.status == 3
                        ? ApplicationStatus(
                            application: application,
                          )
                        : null,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          application.student!.course! +
                              " . " +
                              application.student!.year!,
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
                            courseName.isEmpty
                                ? "Verified"
                                : "Applying for " + courseName,
                            style: const TextStyle(
                                color: Variables.accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (application.student!.marksheet != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: application.student!.marksheet!.length * 2,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              application.student!.marksheet!.length,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (context, index) {
                          var markData = application.student!.marksheet!.keys
                              .toList(growable: true);
                          for (var element
                              in application.student!.marksheet!.values) {
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
                  const SizedBox(
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
