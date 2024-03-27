abstract class Profile {
  int profileId;
  String firstName;
  String lastName;
  String? middleName;
  String? phoneNumber;
  DateTime? birthday;
  String? nationality;
  String? homeAddress;
  String? profilePicture;

  Profile({
    required this.profileId,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.birthday,
    this.phoneNumber,
    this.nationality,
    this.homeAddress,
    this.profilePicture,
  });

  String getFullName() {
    return firstName +
        ' ' +
        (middleName == null ? '' : middleName!) +
        (middleName == null ? '' : ' ') +
        lastName;
  }

  String getBirthday() {
    if (birthday != null) {
      return (birthday?.year).toString() +
          '/' +
          (birthday?.month).toString() +
          '/' +
          (birthday?.day).toString();
    }
    return '';
  }

  @override
  String toString() {
    return 'Profile ( \n'
        'profileId: $profileId \n'
        'firstName: $firstName, \n'
        'lastName: $lastName, \n'
        'middleName: $middleName, \n'
        'birthday: $birthday, \n'
        'phoneNumber: $phoneNumber, \n'
        'nationality: $nationality, \n'
        'homeAddress: $homeAddress, \n'
        'profilePicture: $profilePicture \n'
        ')';
  }
}
