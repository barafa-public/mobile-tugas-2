import 'dart:io';

void main() {
  // 1. DATA KELOMPOK & LOGIN
  List<Map<String, String>> groupData = [
    {"username": "Robi", "password": "1242400"},
    {"username": "Angga", "password": "124240065"},
    {"username": "Krisna", "password": "124240154"},
    {"username": "Faris", "password": "124240139"},
  ];

  bool isLoggedIn = false;
  String? loggedInUser;

  print("=========================================");
  print("           APLIKASI DART - LOGIN          ");
  print("=========================================");

  for (int attempt = 1; attempt <= 3 && !isLoggedIn; attempt++) {
    stdout.write('Username: ');
    String username = stdin.readLineSync() ?? '';

    stdout.write('Password: ');
    String password = stdin.readLineSync() ?? '';

    if (username.isEmpty || password.isEmpty) {
      print('Username atau password tidak boleh kosong.\n');
      continue;
    }

    bool isValid = groupData.any(
      (user) => user['username'] == username && user['password'] == password,
    );

    if (isValid) {
      isLoggedIn = true;
      loggedInUser = username;
      print('\nLogin berhasil! Selamat datang, $username.\n');
    } else {
      print('Username atau password salah. Percobaan ke-$attempt dari 3.\n');
    }
  }

  if (!isLoggedIn) {
    print('Gagal login setelah 3 percobaan. Program dihentikan.');
    return;
  }

  // 2. MENU UTAMA
  bool running = true;

  while (running) {
    print("=========================================");
    print("               MENU UTAMA                 ");
    print("=========================================");
    print("Login sebagai: $loggedInUser");
    print("1. Lihat Data Kelompok");
    print("2. Penjumlahan dan Pengurangan Angka");
    print("3. Perkalian dan Pembagian Angka");
    print("4. Cek Bilangan Ganjil / Genap");
    print("5. Jumlah Total Angka dalam Suatu Input");
    print("6. Keluar");
    stdout.write("Pilih menu (1-6): ");

    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        tampilkanDataKelompok(groupData);
        pause();
        break;
      case '2':
        hitungTambahKurang();
        pause();
        break;
      case '3':
        hitungKaliBagi();
        pause();
        break;
      case '4':
      cekGanjilGenap();
        pause();
        break;
      case '5':
        tampilkanSumHimpunanAngka();
        pause();
        break;
      case '6':
        running = false;
        print('Terima kasih, program selesai.');
        break;
      default:
        print('Pilihan tidak valid, silakan coba lagi.\n');
    }
  }
}

// FUNGSI 1: Menampilkan Data Kelompok
// =========================================================
void tampilkanDataKelompok(List<Map<String, String>> groupData) {
  print("\n----- DATA KELOMPOK -----");
  for (int i = 0; i < groupData.length; i++) {
    var user = groupData[i];
    print('${i + 1}. Username: ${user['username']}');
  }
  print("--------------------------\n");
}

void tampilkanSumHimpunanAngka() {
  print("\n----- SUM HIMPUNAN ANGKA -----");

  print("\n");

  stdout.write("tuliskan himpunan angka dipisah dengan koma: ");
  String? raw = stdin.readLineSync();

  if (raw == null || raw == "") {
    print("input tidak boleh kosong!\n\n");
    tampilkanSumHimpunanAngka();
    return;
  }

  if (raw.split("").any((c) => c == " ")) {
    print("input tidak boleh mengandung spasi!");
    tampilkanSumHimpunanAngka();

    return;
  }

  try {
    var sum = raw
        .split(",")
        .map((String s) => int.parse(s))
        .reduce((value, element) => value + element);

    print("hasil penjumlahan adalah: $sum");
  } catch (_) {
    print("input tidak boleh mengandung huruf");
  }
}

// ===== KELAS BANTU: BigDecimal (angka besar + desimal, presisi penuh) =====
class BigDecimal {
  final BigInt unscaled; // digit-digit angka (tanpa titik), termasuk tanda
  final int scale;       // jumlah digit di belakang koma

  BigDecimal(this.unscaled, this.scale);

  BigDecimal _rescale(int newScale) {
    if (newScale == scale) return this;
    final diff = newScale - scale;
    return BigDecimal(unscaled * BigInt.from(10).pow(diff), newScale);
  }

  BigDecimal operator +(BigDecimal other) {
    final maxScale = scale > other.scale ? scale : other.scale;
    final a = _rescale(maxScale);
    final b = other._rescale(maxScale);
    return BigDecimal(a.unscaled + b.unscaled, maxScale);
  }

  BigDecimal operator -(BigDecimal other) {
    final maxScale = scale > other.scale ? scale : other.scale;
    final a = _rescale(maxScale);
    final b = other._rescale(maxScale);
    return BigDecimal(a.unscaled - b.unscaled, maxScale);
  }

    // Perkalian: unscaled dikalikan langsung, scale dijumlahkan
  BigDecimal operator *(BigDecimal other) {
    return BigDecimal(unscaled * other.unscaled, scale + other.scale);
  }

  @override
  String toString() {
    String sign = unscaled.isNegative ? '-' : '';
    String s = unscaled.abs().toString();

    if (scale == 0) return '$sign$s';

    while (s.length <= scale) {
      s = '0$s';
    }

    String intPart = s.substring(0, s.length - scale);
    String fracPart = s.substring(s.length - scale);
    fracPart = fracPart.replaceAll(RegExp(r'0+$'), ''); // buang nol trailing

    return fracPart.isEmpty ? '$sign$intPart' : '$sign$intPart.$fracPart';
  }
}

// ===== FUNGSI PARSING INPUT =====
BigDecimal? parseInputAngka(String raw, {required String label}) {
  String trimmed = raw.trim();

  if (trimmed.isEmpty) {
    print("$label tidak boleh kosong!");
    return null;
  }

  if (trimmed.contains(' ')) {
    print("$label tidak boleh mengandung spasi!");
    return null;
  }

  // format: tanda opsional, digit wajib, lalu opsional (titik/koma + digit)
  final match = RegExp(r'^([+-]?)(\d+)([.,](\d+))?$').firstMatch(trimmed);

  if (match == null) {
    print("$label tidak valid! Format yang diterima: bilangan bulat atau desimal, "
        "boleh diawali + atau -, contoh: 123, -45, 3.14, 7,25. "
        "(Pastikan hanya ada satu tanda titik/koma sebagai pemisah desimal.)");
    return null;
  }

  String signStr = match.group(1) ?? '';
  String intPart = match.group(2)!;
  String fracPart = match.group(4) ?? '';

  BigInt unscaled = BigInt.parse(intPart + fracPart);
  if (signStr == '-') unscaled = -unscaled;

  return BigDecimal(unscaled, fracPart.length);
}

// ===== FUNGSI PEMBAGIAN DENGAN PRESISI (long division manual pakai BigInt) =====
// Dibuat terpisah dari operator BigDecimal karena hasil bagi bisa tidak
// berhenti (misal 1/3), jadi kita batasi jumlah digit desimal (presisi).
String bagiDenganPresisi(BigDecimal a, BigDecimal b, {int presisi = 10}) {
  if (b.unscaled == BigInt.zero) {
    throw Exception('Pembagian dengan nol tidak diperbolehkan');
  }

  BigInt numerator = a.unscaled * BigInt.from(10).pow(b.scale);
  BigInt denominator = b.unscaled * BigInt.from(10).pow(a.scale);

  bool negatif = numerator.isNegative != denominator.isNegative;
  numerator = numerator.abs();
  denominator = denominator.abs();

  BigInt bagianBulat = numerator ~/ denominator;
  BigInt sisa = numerator % denominator;

  StringBuffer desimal = StringBuffer();
  for (int i = 0; i < presisi && sisa != BigInt.zero; i++) {
    sisa *= BigInt.from(10);
    desimal.write((sisa ~/ denominator).toString());
    sisa = sisa % denominator;
  }

  bool masihAdaSisa = sisa != BigInt.zero;
  String hasil = bagianBulat.toString();
  if (desimal.isNotEmpty) {
    hasil += '.${desimal.toString()}';
  }
  if (masihAdaSisa) {
    hasil += '...'; // menandakan hasil dipotong, bukan pas
  }

  bool hasilNolMurni = bagianBulat == BigInt.zero &&
      desimal.toString().replaceAll('0', '').isEmpty;

  return (negatif && !hasilNolMurni) ? '-$hasil' : hasil;
}

// FUNGSI 2: Penjumlahan dan Pengurangan Angka
// =========================================================
void hitungTambahKurang() {
  print("\n----- PENJUMLAHAN DAN PENGURANGAN ANGKA -----");

  BigDecimal? angka1;
  while (angka1 == null) {
    stdout.write("Masukkan angka pertama: ");
    String? raw1 = stdin.readLineSync();
    if (raw1 == null) {
      print("Input tidak terbaca, coba lagi.");
      continue;
    }
    angka1 = parseInputAngka(raw1, label: "Angka pertama");
  }

  BigDecimal? angka2;
  while (angka2 == null) {
    stdout.write("Masukkan angka kedua: ");
    String? raw2 = stdin.readLineSync();
    if (raw2 == null) {
      print("Input tidak terbaca, coba lagi.");
      continue;
    }
    angka2 = parseInputAngka(raw2, label: "Angka kedua");
  }

  BigDecimal hasilTambah = angka1 + angka2;
  BigDecimal hasilKurang = angka1 - angka2;

  print("\nHasil penjumlahan: $angka1 + $angka2 = $hasilTambah");
  print("Hasil pengurangan: $angka1 - $angka2 = $hasilKurang");
  print("----------------------------------------\n");
}

// FUNGSI 3: Perkalian dan Pembagian Angka
// =========================================================
void hitungKaliBagi() {
  print("\n----- PERKALIAN DAN PEMBAGIAN ANGKA -----");

  BigDecimal? angka1;
  while (angka1 == null) {
    stdout.write("Masukkan angka pertama: ");
    String? raw1 = stdin.readLineSync();
    if (raw1 == null) {
      print("Input tidak terbaca, coba lagi.");
      continue;
    }
    angka1 = parseInputAngka(raw1, label: "Angka pertama");
  }

  BigDecimal? angka2;
  while (angka2 == null) {
    stdout.write("Masukkan angka kedua: ");
    String? raw2 = stdin.readLineSync();
    if (raw2 == null) {
      print("Input tidak terbaca, coba lagi.");
      continue;
    }
    angka2 = parseInputAngka(raw2, label: "Angka kedua");
  }

  BigDecimal hasilKali = angka1 * angka2;
  print("\nHasil perkalian: $angka1 x $angka2 = $hasilKali");

  try {
    String hasilBagi = bagiDenganPresisi(angka1, angka2);
    print("Hasil pembagian: $angka1 : $angka2 = $hasilBagi");
  } catch (e) {
    print("Hasil pembagian: tidak bisa dibagi nol (pembagi = 0).");
  }

  print("----------------------------------------\n");
}

// FUNGSI 4: Mengecek Input Bilangan Ganjil atau Genap
// =========================================================
void cekGanjilGenap() {
  print("\n----- CEK BILANGAN GANJIL / GENAP -----");

  stdout.write("Masukkan sebuah angka: ");
  String? raw = stdin.readLineSync();

  if (raw == null || raw.trim().isEmpty) {
    print("Input tidak boleh kosong!\n");
    cekGanjilGenap();
    return;
  }

  try {
    int angka = int.parse(raw.trim());

    if (angka % 2 == 0) {
      print("$angka adalah bilangan GENAP.");
    } else {
      print("$angka adalah bilangan GANJIL.");
    }
  } catch (_) {
    print("Input tidak valid! Harap masukkan angka bulat.");
  }

  print("----------------------------------------\n");
}
// FUNGSI Pause & Clean Terminal
// =========================================================
void pause() {
  stdout.write('\nTekan Enter untuk kembali ke menu...');
  stdin.readLineSync();
  clearScreen();
}

void clearScreen() {
  stdout.write('\x1B[2J\x1B[3J\x1B[H');
}
