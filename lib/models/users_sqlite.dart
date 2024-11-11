
class Users {
    final int? usrId;
    final String? usrAvarta;
    final String?usrFullname;
    final String? usrPhonenumber;
    final String? usrDate;
    final String usrEmail;
    final String usrPassword;

    Users({
        this.usrId,
        this.usrAvarta,
        this.usrFullname,
        this.usrPhonenumber,
        this.usrDate,
        required this.usrEmail,
        required this.usrPassword,
    });

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        usrAvarta: json["usrAvarta"],
        usrFullname: json["usrFullname"],
        usrPhonenumber: json["usrPhonenumber"],
        usrDate: json["usrDate"],
        usrEmail: json["usrEmail"],
        usrPassword: json["usrPassword"],
    );

    Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrAvarta": usrAvarta,
        "usrFullname": usrFullname,
        "usrPhonenumber": usrPhonenumber,
        "usrDate": usrDate,
        "usrEmail": usrEmail,
        "usrPassword": usrPassword,
    };
}
