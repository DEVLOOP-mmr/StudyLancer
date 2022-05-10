import 'package:bloc/bloc.dart';

import 'package:elite_counsel/models/student.dart';
import 'package:equatable/equatable.dart';

class StudentApplicationCubit extends Cubit<Student> {
  StudentApplicationCubit(Student student) : super(student);
  
  void changeApplicationProgress(int index, int newProgress) {
    var applications = state.applications;
    if (applications == null) {
      return;
    }
    if (index <= (applications.length) - 1) {
      applications[index].progress = newProgress;
    }
    emit(state.copyWith(applications: applications));
  }
}
