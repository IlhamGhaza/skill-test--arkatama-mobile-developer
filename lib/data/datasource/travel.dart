class Travel {
  final int? id;
  final String namaTravel;
  final String rute;
  final DateTime? tanggalKeberangkatan;
  final String? waktuKeberangkatan;
  final double? harga;
  final int? kapasitas;

  Travel({
    this.id,
    required this.namaTravel,
    required this.rute,
    this.tanggalKeberangkatan,
    this.waktuKeberangkatan,
    this.harga,
    this.kapasitas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_travel': namaTravel,
      'rute': rute,
      'tanggal_keberangkatan': tanggalKeberangkatan?.toIso8601String(),
      'waktu_keberangkatan': waktuKeberangkatan,
      'harga': harga,
      'kapasitas': kapasitas,
    };
  }

  factory Travel.fromMap(Map<String, dynamic> map) {
    return Travel(
      id: map['id'],
      namaTravel: map['nama_travel'],
      rute: map['rute'],
      tanggalKeberangkatan: map['tanggal_keberangkatan'] != null
          ? DateTime.parse(map['tanggal_keberangkatan'])
          : null,
      waktuKeberangkatan: map['waktu_keberangkatan'],
      harga: map['harga']?.toDouble(), // Convert int to double
      kapasitas: map['kapasitas'],
    );
  }

}
