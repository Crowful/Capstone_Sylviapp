import 'package:flutter_test/flutter_test.dart';
import 'package:sylviapp_project/models/user_account.dart';

void main() {
  test('Title of test', () {});

  test('retrieve Exact username value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setUserName('SomeUsername');
    expect(useraacount.getUserName, 'SomeUsername');
  });
  test('retrieve Exact email value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setEmail('UserPassword');
    expect(useraacount.getEmail, 'UserPassword');
  });
  test('retrieve Exact password value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setPassword('password123123');
    expect(useraacount.getPassword, 'password123123');
  });
  test('retrieve Exact fullname value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setFullname('Somefullname');
    expect(useraacount.getFullname, 'Somefullname');
  });
  test('retrieve Exact gender value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setGender('Male');
    expect(useraacount.getGender, 'Male');
  });
  test('retrieve Exact address value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setAddress('address testing words');
    expect(useraacount.getAddress, 'address testing words');
  });
  test('retrieve Exact contact value in setters and getters .', () {
    var useraacount = UserAccount();
    useraacount.setContact('0116223890');
    expect(useraacount.getContact, '0116223890');
  });
}
