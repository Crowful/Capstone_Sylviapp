import 'package:flutter_test/flutter_test.dart';
import 'package:sylviapp_project/Domain/radiusCampaign.dart';

void main() {
  test('Make sure that the radius assigning process works properly', () {
    var mapbackend = MapBackend();
    var radiusAssigned = 2.4;
    mapbackend.RadiusAssign(radiusAssigned);
    expect(mapbackend.valueRadius, radiusAssigned);
  });

  test('volunteer required is relative to the radius', () {
    var mapbackend = MapBackend();
    var radiusAssigned = 30.4;
    mapbackend.checkVolunteersNeeded(radiusAssigned);
    expect(mapbackend.volunteersRequired, 60);
  });
}
