class Passenger {
  final int? id;
  final String nama;
  final String? email;
  final String? noTelepon;
  final String? alamat;
  final int? travelId;

  Passenger({
    this.id,
    required this.nama,
    this.email,
    this.noTelepon,
    this.alamat,
    this.travelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'no_telepon': noTelepon,
      'alamat': alamat,
      'travel_id': travelId,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      id: map['id'],
      nama: map['nama'],
      email: map['email'],
      noTelepon: map['no_telepon'],
      alamat: map['alamat'],
      travelId: map['travel_id'],
    );
  }
}
