// admin guy data
class AdminData {
  static String adminName = 'John Doe'; // Replace with the admin's name
  static String dateOfBirth =
      '01/01/1990'; // Replace with the admin's date of birth
  static String adminPhone =
      '(098) 765-4321'; // Replace with the admin's phone number
  static String adminEmail =
      'admin@techsolutions.com'; // Replace with the admin's email address
  static String gender = 'Male'; // Replace with the admin's gender
  static String adminAddress =
      '456 Admin Lane, Silicon Valley, CA 94043'; // Replace with the admin's address

  String getAdminName() {
    return adminName;
  }

  String getDateOfBirth() {
    return dateOfBirth;
  }

  String getAdminPhone() {
    return adminPhone;
  }

  String getAdminEmail() {
    return adminEmail;
  }

  String getGender() {
    return gender;
  }

  String getAdminAddress() {
    return adminAddress;
  }

  void setAdminName(String name) {
    adminName = name;
  }

  void setDateOfBirth(String dob) {
    dateOfBirth = dob;
  }

  void setAdminPhone(String phone) {
    adminPhone = phone;
  }

  void setAdminEmail(String email) {
    adminEmail = email;
  }

  void setGender(String gen) {
    gender = gen;
  }

  void setAdminAddress(String address) {
    adminAddress = address;
  }

  void clearAdminData() {
    adminName = '';
    dateOfBirth = '';
    adminPhone = '';
    adminEmail = '';
    gender = '';
    adminAddress = '';
  }
}
