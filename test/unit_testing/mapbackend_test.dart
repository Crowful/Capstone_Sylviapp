import 'package:flutter_test/flutter_test.dart';
import 'package:sylviapp_project/Domain/radiusCampaign.dart';

void main() {
  test('Make sure that the radius assigning process works properly', () {
    var mapbackend = MapBackend();
    var radiusAssigned = 2.4;
    mapbackend.RadiusAssign(radiusAssigned);
    expect(mapbackend.valueRadius, radiusAssigned);
  });

  test('volunteers required is relative to the radius', () {
    var mapbackend = MapBackend();
    var radiusAssigned = 30.4;
    mapbackend.checkVolunteersNeeded(radiusAssigned);
    expect(mapbackend.volunteersRequired, 60);
  });

  test('funds required is relative to the radius', () {
    var mapbackend = MapBackend();
    var radiusAssigned = 30.4;
    mapbackend.checkFundRequired(radiusAssigned);
    expect(mapbackend.fundRequired, 2000.0);
  });

  test('seeds required is relative to the radius', () {
    var mapbackend = MapBackend();
    var radiusAssigned = 30.4;
    mapbackend.checkseedsNeeded(radiusAssigned);
    expect(mapbackend.seedsRequired, 80);
  });
}
