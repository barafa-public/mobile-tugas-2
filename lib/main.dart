import 'dart:io';

void main() {
  // 1. DATA KELOMPOK & LOGIN
  List<Map<String, String>> groupData = [
    {"username": "Robi", "password": "1242400"},
    {"username": "Angga", "password": "124240065"},
    {"username": "Khrisna", "password": "1242400"},
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
        break;
      case '2':
        break;
      case '3':
        break;
      case '4':
        break;
      case '5':
        tampilkanSumHimpunanAngka();
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
