import 'package:elite_counsel/bloc/country_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test to get list of countries', () async {
    // ignore: non_constant_identifier_names
    final countryList = await CountryBloc.getCountries();

    expect(countryList, isNotEmpty);
  });
}
