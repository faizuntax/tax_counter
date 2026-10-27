class HasilHitungModel {
  final double bruto;
  final double pajak;
  final double netto;
  final double percent;
  final String? kategoriTer;
  final String? ptkp;
  final String? sumber;

  HasilHitungModel({
    required this.bruto,
    required this.pajak,
    required this.netto,
    required this.percent,
    this.kategoriTer,
    this.ptkp,
    this.sumber,
  });

  factory HasilHitungModel.fromJson(Map<String, dynamic> json) {
    return HasilHitungModel(
      bruto: (json['bruto'] as num).toDouble(),
      pajak: (json['pajak'] as num?)?.toDouble() ?? 0.0,
      netto: (json['netto'] as num).toDouble(),
      percent: (json['percent'] as num).toDouble(),
      kategoriTer: json['kategori_ter']?.toString(),
      ptkp: json['ptkp']?.toString(),
      sumber: json['sumber']?.toString(),
    );
  }
}
