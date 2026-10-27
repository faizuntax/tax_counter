import 'package:dummy_perhitungan/models/hasil_hitung_model.dart';
import 'package:dummy_perhitungan/services/tarif_ter.dart';
import 'package:supabase/supabase.dart';

class Pph21Ter {
  Future<HasilHitungModel> perhitungan(
    double gajiPokok,
    String ptkp,
    SupabaseClient supabase,
  ) async {
    final service = TarifTerService(supabase);
    final response = await service.getTarifTer(gajiPokok, ptkp);

    double rateDecimal;
    double ratePercent;

    // Menangani baik format desimal (0.0025) maupun persen langsung (0.25)
    if (response.percent <= 1.0 && response.percent > 0) {
      rateDecimal = response.percent;
      ratePercent = response.percent * 100;
    } else if (response.percent > 1.0) {
      ratePercent = response.percent;
      rateDecimal = response.percent / 100;
    } else {
      rateDecimal = 0.0;
      ratePercent = 0.0;
    }

    final bruto = gajiPokok;
    final pajak = bruto * rateDecimal;
    final netto = bruto - pajak;

    return HasilHitungModel(
      bruto: bruto,
      pajak: pajak,
      netto: netto,
      percent: ratePercent,
      kategoriTer: response.terType,
      ptkp: ptkp,
      sumber: response.sumber,
    );
  }
}
