class Place {
  String place_id;
  int array;
  String address;
  String business_name;
  String business_name1;
  String business_name2;
  String business_name3;
  String business_name_english;
  String day;
  String detail;
  String email;
  String facebook;
  String instagram;
  String line;
  double latitude;
  double longitude;
  String map;
  String open;
  String photo1;
  String photo2;
  String photo3;
  String photo4;
  String photo5;
  String photo6;
  String photo7;
  String photo8;
  String photo9;
  String photo10;
  String price;
  double rating;
  String status;
  String tel;
  String time;
  String type;
  String user_id;
  String website;

  Place(
      this.place_id,
      this.array,
      this.address,
      this.business_name,
      this.business_name1,
      this.business_name2,
      this.business_name3,
      this.business_name_english,
      this.day,
      this.detail,
      this.email,
      this.facebook,
      this.instagram,
      this.line,
      this.latitude,
      this.longitude,
      this.map,
      this.open,
      this.photo1,
      this.photo2,
      this.photo3,
      this.photo4,
      this.photo5,
      this.photo6,
      this.photo7,
      this.photo8,
      this.photo9,
      this.photo10,
      this.price,
      this.rating,
      this.status,
      this.tel,
      this.time,
      this.type,
      this.user_id,
      this.website);

  /* Location.map(dynamic obj) {
    this._location_id = obj['location_id'];
    this._photo = obj['photo'];
    this._date = obj['date'];
    this._time = obj['time'];
    this._status = obj['status'];
    this._user_id = obj['user_id'];
  } */

  // String get location_id => _location_id;
  // String get photo => _photo;
  // String get date => _date;
  // String get time => _time;
  // String get status => _status;
  // String get user_id => _user_id;

  /* Location.fromSnapshot(DataSnapshot snapshot) {
    _location_id = snapshot.value['location_id'];
    _photo = snapshot.value['photo'];
    _date = snapshot.value['date'];
    _time = snapshot.value['time'];
    _status = snapshot.value['status'];
    _user_id = snapshot.value['user_id'];
  } */
}
