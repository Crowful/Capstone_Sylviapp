import 'package:flutter/material.dart';

class CampaignReforestation extends ChangeNotifier {
  late String title;
  late String description;
  late String campaignID;
  late String dateCreated;
  late String dateStart;
  late String dateEnded;
  late String address;
  late String city;
  late String time;
  late String userUID;
  late String userName;
  late double latitude;
  late double longitude;
  late int numSeeds;
  late double currentDonations;
  late double maxDonations;
  late int currentVolunteers;
  late int numberVolunteers;

  setTitle(title1) {
    title = title1;
    notifyListeners();
  }

  setDescription(description1) {
    description = description1;
    notifyListeners();
  }

  setCampaignID(campaignID1) {
    campaignID = campaignID1;
    notifyListeners();
  }

  setDateStarted(dateStarted1) {
    dateCreated = dateStarted1;
    notifyListeners();
  }

  setDateEnded(dateEnded1) {
    dateStart = dateEnded1;
    notifyListeners();
  }

  setAddress(address1) {
    address = address1;
    notifyListeners();
  }

  setCity(city1) {
    city = city1;
    notifyListeners();
  }

  setTime(time1) {
    time = time1;
    notifyListeners();
  }

  setUserID(userID1) {
    userUID = userID1;
    notifyListeners();
  }

  setUserName(username1) {
    userName = username1;
    notifyListeners();
  }

  setLatitude(latitude1) {
    latitude = latitude1;
    notifyListeners();
  }

  setLongitude(longitude1) {
    longitude = longitude1;
    notifyListeners();
  }

  setNumSeeds(numseeds1) {
    numSeeds = numseeds1;
    notifyListeners();
  }

  setCurrentDonations(currentDonations1) {
    currentDonations = currentDonations1;
    notifyListeners();
  }

  setMaxDonations(maxDonation1) {
    maxDonations = maxDonation1;
    notifyListeners();
  }

  setCurrentVolunteers(currentVolunteer1) {
    currentVolunteers = currentVolunteer1;
    notifyListeners();
  }

  setNumberVolunteers(numberVolunteer1) {
    numberVolunteers = numberVolunteer1;
    notifyListeners();
  }
}
