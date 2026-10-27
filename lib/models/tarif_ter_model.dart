class TarifTerModel {
  final String id;
  final String terType;
  final double percent;
  final double bruto;
  final String ptkp;
  final String sumber;

  TarifTerModel({
    required this.id,
    required this.terType,
    required this.percent,
    required this.bruto,
    required this.ptkp,
    this.sumber = 'Database Supabase',
  });

  factory TarifTerModel.fromJson(Map<String, dynamic> json, {String sumber = 'Database Supabase'}) {
    return TarifTerModel(
      id: json['id']?.toString() ?? '',
      terType: json['kategori_ter']?.toString() ?? '',
      percent: (json['tarif_persen'] as num?)?.toDouble() ?? 0.0,
      bruto: (json['bruto'] as num?)?.toDouble() ?? 0.0,
      ptkp: json['ptkp']?.toString() ?? '',
      sumber: sumber,
    );
  }
}
