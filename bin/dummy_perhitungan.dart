import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:dummy_perhitungan/input/terimal.dart';
import 'package:supabase/supabase.dart';

Future<void> main() async {
  // Cek file .env baik saat dijalankan dari root maupun dari folder bin
  final envFile = File('.env').existsSync()
      ? '.env'
      : (File('../.env').existsSync() ? '../.env' : '.env');

  var dotenv = DotEnv(includePlatformEnvironment: true)..load([envFile]);
  final supaUrl = dotenv['SUPABASE_URL'];
  final supaKey = dotenv['SUPABASE_ANON_KEY'];

  if (supaUrl == null || supaKey == null || supaUrl.isEmpty || supaKey.isEmpty) {
    stderr.writeln('⚠️  Catatan: SUPABASE_URL / SUPABASE_ANON_KEY tidak terdeteksi di .env.');
    stderr.writeln('Aplikasi akan berjalan dalam mode offline (Regulasi PP 58/2023).\n');
  }

  final supabase = SupabaseClient(
    supaUrl ?? 'https://localhost',
    supaKey ?? 'dummy_key',
  );

  await TerimalInput(supabase).start();
}
