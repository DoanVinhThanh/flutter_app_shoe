class Address {
  final int? addressId;
  final String? addressNameUser;
  final String? addressNumber;
  final String? addressStreet;
  final String? addressWard;
  final String? addressDistrict;
  final String? addressCity;
  final String? addressPhone;
  final bool? addressStatus; // Keep as bool for internal usage
  final String? addressEmailUser;

  Address({
    this.addressId,
    this.addressNameUser,
    this.addressNumber,
    this.addressStreet,
    this.addressWard,
    this.addressDistrict,
    this.addressCity,
    this.addressPhone,
    this.addressEmailUser,
    this.addressStatus,
  });

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    addressId: json["addressId"],
    addressNameUser: json["addressNameUser"],
    addressNumber: json["addressNumber"],
    addressStreet: json["addressStreet"],
    addressWard: json["addressWard"],
    addressDistrict: json["addressDistrict"],
    addressCity: json["addressCity"],
    addressPhone: json["addressPhone"],
    // Convert int to bool
    addressStatus: json["addressStatus"] == 1, // Assuming 1 means true and 0 means false
    addressEmailUser: json["addressEmailUser"],
  );

  Map<String, dynamic> toMap() => {
    "addressId": addressId,
    "addressNameUser": addressNameUser,
    "addressNumber": addressNumber,
    "addressStreet": addressStreet,
    "addressWard": addressWard,
    "addressDistrict": addressDistrict,
    "addressCity": addressCity,
    "addressPhone": addressPhone,
    "addressStatus": addressStatus == true ? 1 : 0, // Convert bool to int (1 or 0)
    "addressEmailUser": addressEmailUser,
  };
}
