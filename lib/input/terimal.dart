import 'dart:io';
import 'package:dummy_perhitungan/controller/pph21_ter.dart';
import 'package:supabase/supabase.dart';

class TerimalInput {
  final SupabaseClient supabase;
  TerimalInput(this.supabase);

  Future<void> start() async {
    print('''
==================================================
        SIMULASI PPh 21 TER (PP 58/2023)
==================================================''');

    while (true) {
      // 1. Input PTKP
      stdout.write(
        '\nMasukkan Jenis PTKP (TK/0, TK/1, K/0, K/1, K/2, K/3, atau "q" keluar): ',
      );
      final ptkpRaw = stdin.readLineSync();
      if (ptkpRaw == null ||
          ptkpRaw.trim().toLowerCase() == 'q' ||
          ptkpRaw.trim().toLowerCase() == 'exit') {
        print(
          '\nTerima kasih telah menggunakan aplikasi kalkulator PPh 21 TER.\n',
        );
        break;
      }

      final ptkp = ptkpRaw.trim().toUpperCase();
      if (!_isValidPtkp(ptkp)) {
        print(
          '⚠️  Status PTKP tidak valid! Contoh yang valid: TK/0, TK/1, K/0, K/1, K/2, K/3',
        );
        continue;
      }

      // 2. Input Bruto
      stdout.write(
        'Masukkan Penghasilan Bruto (contoh: 6.000.000 atau 6000000): ',
      );
      final brutoRaw = stdin.readLineSync();
      if (brutoRaw == null) break;

      final bruto = _parseBruto(brutoRaw);
      if (bruto == null || bruto < 0) {
        print(
          '⚠️  Nominal bruto tidak valid! Harap masukkan angka yang benar.',
        );
        continue;
      }

      print('\n⏳ Sedang memproses penghitungan...');

      try {
        final controller = Pph21Ter();
        final value = await controller.perhitungan(bruto, ptkp, supabase);

        print('''
--------------------------------------------------
HASIL PENGHITUNGAN PPh 21 TER:
--------------------------------------------------
Status PTKP       : ${value.ptkp}
Kategori TER      : TER ${value.kategoriTer ?? '-'}
Penghasilan Bruto : ${_formatRupiah(value.bruto)}
Tarif Efektif     : ${value.percent.toStringAsFixed(2)}%

==================================================
Pajak Terutang    : ${_formatRupiah(value.pajak)}
Penghasilan Netto : ${_formatRupiah(value.netto)}
==================================================
Sumber Tarif      : ${value.sumber ?? '-'}
--------------------------------------------------''');
      } catch (e) {
        print('❌ Terjadi kesalahan saat menghitung: $e');
      }

      stdout.write('\nHitung lagi? (y/n): ');
      final lagi = stdin.readLineSync();
      if (lagi != null && lagi.trim().toLowerCase() != 'y') {
        print(
          '\nTerima kasih telah menggunakan aplikasi kalkulator PPh 21 TER.\n',
        );
        break;
      }
    }
  }

  bool _isValidPtkp(String p) {
    const valid = ['TK/0', 'TK/1', 'TK/2', 'TK/3', 'K/0', 'K/1', 'K/2', 'K/3'];
    return valid.contains(p);
  }

  double? _parseBruto(String input) {
    var cleaned = input
        .replaceAll('Rp', '')
        .replaceAll('rp', '')
        .replaceAll(' ', '')
        .trim();
    // Jika format Indonesia 10.000.000,00 atau 10.000.000
    if (cleaned.contains('.') && cleaned.contains(',')) {
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    } else if (cleaned.contains('.')) {
      cleaned = cleaned.replaceAll('.', '');
    } else if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '.');
    }
    return double.tryParse(cleaned);
  }

  String _formatRupiah(num number) {
    final isNegative = number < 0;
    final abs = number.abs().round();
    final s = abs.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(s[i]);
    }
    return '${isNegative ? "-Rp " : "Rp "}$buffer';
  }
}
