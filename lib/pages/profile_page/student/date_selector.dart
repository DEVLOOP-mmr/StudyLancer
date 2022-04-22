import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/models/student.dart';

import 'package:elite_counsel/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    Key key,
  }) : super(key: key);
  Future<Student> _selectDate(Student user, BuildContext context) async {
    DateTime currentDate =
        DateTime.now().subtract(const Duration(days: 365 * 18));
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1947),
        lastDate: DateTime(2022));

    if (pickedDate != null && pickedDate != currentDate) {
      currentDate = pickedDate;
      user.dob = (Variables.dateFormat).format(currentDate);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        var student = (state as StudentHomeState).student;

        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 30.0, bottom: 8.0, right: 30),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () async {
                var changedUser = await _selectDate(student, context);

                BlocProvider.of<HomeBloc>(context, listen: false)
                    .emitNewStudent(changedUser);
              },
              child: Text(
                student.dob == null
                    ? ''
                    : DateTime.tryParse(student.dob) == null
                        ? (student.dob ?? '')
                        : Variables.dateFormat
                            .format(DateTime.parse(student.dob)),
                key: UniqueKey(),
                style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Roboto',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
