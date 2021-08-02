class User {
  // Wishlist({
  //   this.id,
  //   this.modified,
  //   this.productId,
  //   this.userId
  // });

  // final String id;
  // final String modified;
  // final String productId;
  // final String userId;

  // Wishlist.fromMap(json)
  //   : id = json['id'].toString(),
  //     modified = json['modified'].toString(),
  //     productId = json['productId'].toString(),
  //     userId = json['userId'].toString();

  final String user_id;
  final String email;
  final String password;
  final String photo;
  final String username;
  final String tel;

  User(this.user_id, this.email, this.password, this.photo, this.username,
      this.tel);

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'email': email,
        'password': password,
        'photo': photo,
        'username': username,
        'tel': tel
      };

  /* String FirstName;
  String LastName;
  String Address;
  String Birthday;
  String EmployeeID;
  String Phone;
  String Position;
  String Sex;
  String email;

  Users(this.FirstName, this.LastName, this.EmployeeID,
        this.Address, this.Birthday, this.Phone,
        this.Position, this.Sex, this.EmployeeID,
        this.FirstName, this.LastName, this.email); */

  /* Users.fromSnapshot(DataSnapshot snapshot) :
        //Key = snapshot.key,
        FirstName = snapshot.value["FirstName"],
        LastName = snapshot.value["LastName"],
        Address = snapshot.value["Address"],
        Birthday = snapshot.value["Birthday"],
        EmployeeID = snapshot.value["EmployeeID"],
        Phone = snapshot.value["Phone"],
        Position = snapshot.value["Position"],
        Sex = snapshot.value["Sex"],
        email = snapshot.value["email"];

  toJson() {
    return {
      "FirstName": FirstName,
      "LastName": LastName,
      "Address": Address,
      "Birthday": Birthday,
      "EmployeeID": EmployeeID,
      "Phone": Phone,
      "Position": Position,
      "Sex": Sex,
      "email": email,
    };
  } */
}
