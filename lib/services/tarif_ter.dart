import 'package:dummy_perhitungan/models/tarif_ter_model.dart';
import 'package:supabase/supabase.dart';

class TarifTerService {
  final SupabaseClient supabase;

  TarifTerService(this.supabase);

  Future<TarifTerModel> getTarifTer(double gajiPokok, String ptkp) async {
    final sanitizedPtkp = ptkp.trim().toUpperCase();

    try {
      final response = await supabase
          .schema('master_data')
          .rpc('get_tarif_ter', params: {
        'p_bruto': gajiPokok,
        'p_ptkp': sanitizedPtkp,
      });

      if (response != null && response['success'] == true && response['data'] != null) {
        return TarifTerModel.fromJson(
          response['data'],
          sumber: 'Database Supabase',
        );
      }
    } catch (_) {
      // Supabase tidak dapat dijangkau / error, gunakan fallback PP 58/2023
    }

    // Fallback otomatis ke katalog resmi regulasi PP 58/2023
    return _hitungFallbackPp58(gajiPokok, sanitizedPtkp);
  }

  static TarifTerModel _hitungFallbackPp58(double bruto, String ptkp) {
    final kategori = _getKategoriTer(ptkp);
    final tarifDesimal = _getTarifDesimal(kategori, bruto);

    return TarifTerModel(
      id: 'local_pp58',
      terType: kategori,
      percent: tarifDesimal,
      bruto: bruto,
      ptkp: ptkp,
      sumber: 'Regulasi PP 58/2023 (Fallback Lokal)',
    );
  }

  static String _getKategoriTer(String ptkp) {
    switch (ptkp) {
      case 'TK/0':
      case 'TK/1':
      case 'K/0':
        return 'A';
      case 'TK/2':
      case 'TK/3':
      case 'K/1':
      case 'K/2':
        return 'B';
      case 'K/3':
        return 'C';
      default:
        return 'A';
    }
  }

  static double _getTarifDesimal(String kategori, double bruto) {
    if (kategori == 'A') {
      return _getTarifTerA(bruto);
    } else if (kategori == 'B') {
      return _getTarifTerB(bruto);
    } else {
      return _getTarifTerC(bruto);
    }
  }

  static double _getTarifTerA(double b) {
    if (b <= 5400000) return 0.0000;
    if (b <= 5650000) return 0.0025;
    if (b <= 5950000) return 0.0050;
    if (b <= 6300000) return 0.0075;
    if (b <= 6750000) return 0.0100;
    if (b <= 7500000) return 0.0125;
    if (b <= 8550000) return 0.0150;
    if (b <= 9650000) return 0.0175;
    if (b <= 10050000) return 0.0200;
    if (b <= 10350000) return 0.0225;
    if (b <= 10700000) return 0.0250;
    if (b <= 11050000) return 0.0300;
    if (b <= 11600000) return 0.0350;
    if (b <= 12500000) return 0.0400;
    if (b <= 13750000) return 0.0500;
    if (b <= 15100000) return 0.0600;
    if (b <= 16950000) return 0.0700;
    if (b <= 19750000) return 0.0800;
    if (b <= 24150000) return 0.0900;
    if (b <= 26450000) return 0.1000;
    if (b <= 28000000) return 0.1100;
    if (b <= 30050000) return 0.1200;
    if (b <= 32400000) return 0.1300;
    if (b <= 35400000) return 0.1400;
    if (b <= 39100000) return 0.1500;
    if (b <= 43850000) return 0.1600;
    if (b <= 47800000) return 0.1700;
    if (b <= 51400000) return 0.1800;
    if (b <= 56300000) return 0.1900;
    if (b <= 62200000) return 0.2000;
    if (b <= 68600000) return 0.2100;
    if (b <= 77500000) return 0.2200;
    if (b <= 89000000) return 0.2300;
    if (b <= 103000000) return 0.2400;
    if (b <= 125000000) return 0.2500;
    if (b <= 157000000) return 0.2600;
    if (b <= 206000000) return 0.2700;
    if (b <= 337000000) return 0.2800;
    if (b <= 454000000) return 0.2900;
    if (b <= 550000000) return 0.3000;
    if (b <= 695000000) return 0.3100;
    if (b <= 910000000) return 0.3200;
    if (b <= 1400000000) return 0.3300;
    return 0.3400;
  }

  static double _getTarifTerB(double b) {
    if (b <= 6200000) return 0.0000;
    if (b <= 6500000) return 0.0025;
    if (b <= 6850000) return 0.0050;
    if (b <= 7300000) return 0.0075;
    if (b <= 9200000) return 0.0100;
    if (b <= 10750000) return 0.0150;
    if (b <= 11250000) return 0.0200;
    if (b <= 11600000) return 0.0250;
    if (b <= 12600000) return 0.0300;
    if (b <= 13600000) return 0.0400;
    if (b <= 14950000) return 0.0500;
    if (b <= 16400000) return 0.0600;
    if (b <= 18450000) return 0.0700;
    if (b <= 21850000) return 0.0800;
    if (b <= 26000000) return 0.0900;
    if (b <= 27700000) return 0.1000;
    if (b <= 29350000) return 0.1100;
    if (b <= 31450000) return 0.1200;
    if (b <= 33950000) return 0.1300;
    if (b <= 37100000) return 0.1400;
    if (b <= 41100000) return 0.1500;
    if (b <= 45800000) return 0.1600;
    if (b <= 49500000) return 0.1700;
    if (b <= 53800000) return 0.1800;
    if (b <= 58500000) return 0.1900;
    if (b <= 64000000) return 0.2000;
    if (b <= 71000000) return 0.2100;
    if (b <= 80000000) return 0.2200;
    if (b <= 93000000) return 0.2300;
    if (b <= 109000000) return 0.2400;
    if (b <= 129000000) return 0.2500;
    if (b <= 163000000) return 0.2600;
    if (b <= 211000000) return 0.2700;
    if (b <= 374000000) return 0.2800;
    if (b <= 459000000) return 0.2900;
    if (b <= 555000000) return 0.3000;
    if (b <= 704000000) return 0.3100;
    if (b <= 957000000) return 0.3200;
    if (b <= 1405000000) return 0.3300;
    return 0.3400;
  }

  static double _getTarifTerC(double b) {
    if (b <= 6600000) return 0.0000;
    if (b <= 6950000) return 0.0025;
    if (b <= 7350000) return 0.0050;
    if (b <= 7800000) return 0.0075;
    if (b <= 8850000) return 0.0100;
    if (b <= 10700000) return 0.0150;
    if (b <= 11250000) return 0.0200;
    if (b <= 11600000) return 0.0250;
    if (b <= 12600000) return 0.0300;
    if (b <= 13600000) return 0.0400;
    if (b <= 14950000) return 0.0500;
    if (b <= 16400000) return 0.0600;
    if (b <= 18450000) return 0.0700;
    if (b <= 21850000) return 0.0800;
    if (b <= 26000000) return 0.0900;
    if (b <= 27700000) return 0.1000;
    if (b <= 29350000) return 0.1100;
    if (b <= 31450000) return 0.1200;
    if (b <= 33950000) return 0.1300;
    if (b <= 37100000) return 0.1400;
    if (b <= 41100000) return 0.1500;
    if (b <= 45800000) return 0.1600;
    if (b <= 49500000) return 0.1700;
    if (b <= 53800000) return 0.1800;
    if (b <= 58500000) return 0.1900;
    if (b <= 64000000) return 0.2000;
    if (b <= 71000000) return 0.2100;
    if (b <= 80000000) return 0.2200;
    if (b <= 93000000) return 0.2300;
    if (b <= 109000000) return 0.2400;
    if (b <= 129000000) return 0.2500;
    if (b <= 163000000) return 0.2600;
    if (b <= 211000000) return 0.2700;
    if (b <= 374000000) return 0.2800;
    if (b <= 459000000) return 0.2900;
    if (b <= 555000000) return 0.3000;
    if (b <= 704000000) return 0.3100;
    if (b <= 957000000) return 0.3200;
    if (b <= 1405000000) return 0.3300;
    return 0.3400;
  }
}
