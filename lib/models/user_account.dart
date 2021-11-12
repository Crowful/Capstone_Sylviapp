class UserAccount {
  String username = "";
  String email = "";
  String password = "";
  String fullname = "";
  String gender = "";
  String address = "";
  String contact = "";

  setEmail(newEmail) {
    this.email = newEmail;
  }

  setUserName(newUsername) {
    this.username = newUsername;
  }

  setPassword(newPassword) {
    this.password = newPassword;
  }

  setFullname(newFullName) {
    this.fullname = newFullName;
  }

  setGender(newGender) {
    this.gender = newGender;
  }

  setAddress(newAddress) {
    this.address = newAddress;
  }

  setContact(newContact) {
    this.contact = newContact;
  }

  get getUserName => username;

  get getEmail => email;

  get getPassword => password;

  get getFullname => fullname;

  get getGender => gender;

  get getAddress => address;

  get getContact => contact;
}
