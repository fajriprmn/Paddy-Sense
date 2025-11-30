import '../models/disease_model.dart';

class DiseaseDataSource {
  // Static disease database
  static final List<DiseaseModel> _diseases = [
    DiseaseModel(
      id: 'blast',
      nameId: 'Blas',
      nameLatin: 'Pyricularia oryzae',
      type: 'Jamur',
      description: 'Penyakit blas adalah penyakit jamur yang menyerang tanaman padi dan dapat menyebabkan kerusakan serius pada daun, batang, dan malai.',
      symptoms: 'Bercak berbentuk belah ketupat berwarna coklat keabu-abuan dengan tepi coklat tua pada daun. Pada serangan berat, daun mengering dan tanaman mati.',
      treatment: '1. Gunakan varietas tahan penyakit\n2. Aplikasi fungisida berbahan aktif trikiklazol atau isoprotiolan\n3. Atur jarak tanam untuk sirkulasi udara yang baik\n4. Pemupukan berimbang, hindari pemupukan nitrogen berlebihan',
      prevention: '1. Gunakan benih sehat dan bersertifikat\n2. Rotasi tanaman\n3. Pengairan berselang (tidak tergenang terus menerus)\n4. Sanitasi lahan dengan membersihkan sisa-sisa tanaman',
    ),
    DiseaseModel(
      id: 'bacterial_blight',
      nameId: 'Hawar Daun Bakteri',
      nameLatin: 'Xanthomonas campestris pv. oryzae',
      type: 'Bakteri',
      description: 'Hawar daun bakteri adalah penyakit yang disebabkan oleh bakteri Xanthomonas oryzae yang menyerang sistem pembuluh tanaman padi.',
      symptoms: 'Garis-garis memanjang berwarna kuning hingga putih pada daun yang dimulai dari ujung atau tepi daun. Daun mengering dan berwarna kecoklatan.',
      treatment: '1. Gunakan varietas tahan\n2. Aplikasi bakterisida berbahan tembaga\n3. Pemangkasan daun terinfeksi\n4. Pengaturan air irigasi yang baik',
      prevention: '1. Gunakan benih sehat\n2. Hindari luka pada tanaman saat pemeliharaan\n3. Jaga kebersihan alat pertanian\n4. Pengairan yang baik, hindari genangan berlebihan',
    ),
    DiseaseModel(
      id: 'tungro',
      nameId: 'Tungro',
      nameLatin: 'RTBV & RTSV',
      type: 'Virus',
      description: 'Penyakit tungro disebabkan oleh kombinasi dua virus (RTBV dan RTSV) yang ditularkan oleh wereng hijau.',
      symptoms: 'Daun menguning, pertumbuhan terhambat, tanaman kerdil, jumlah anakan berkurang, dan malai tidak keluar atau hampa.',
      treatment: '1. Cabut dan musnahkan tanaman terinfeksi\n2. Kendalikan populasi wereng hijau dengan insektisida\n3. Tidak ada pengobatan langsung untuk virus\n4. Fokus pada pencegahan penyebaran',
      prevention: '1. Gunakan varietas tahan tungro\n2. Tanam serentak dalam satu hamparan\n3. Pergiliran tanaman\n4. Kendalikan wereng hijau sejak dini\n5. Bersihkan gulma yang menjadi inang wereng',
    ),
    DiseaseModel(
      id: 'brown_spot',
      nameId: 'Bercak Coklat',
      nameLatin: 'Bipolaris oryzae',
      type: 'Jamur',
      description: 'Bercak coklat adalah penyakit jamur yang umum menyerang tanaman padi, terutama pada kondisi kekurangan hara.',
      symptoms: 'Bercak bulat atau oval berwarna coklat dengan bagian tengah berwarna abu-abu atau putih pada daun. Bercak dapat menyatu dan menyebabkan daun mengering.',
      treatment: '1. Aplikasi fungisida berbahan aktif mankozeb atau propineb\n2. Perbaiki pemupukan, terutama kalium\n3. Atur pengairan dengan baik\n4. Buang daun terinfeksi berat',
      prevention: '1. Gunakan benih sehat dan perlakuan benih dengan fungisida\n2. Pemupukan berimbang sesuai kebutuhan tanaman\n3. Pengairan yang baik\n4. Rotasi tanaman\n5. Sanitasi lahan',
    ),
    DiseaseModel(
      id: 'healthy',
      nameId: 'Sehat',
      nameLatin: 'Oryza sativa (Normal)',
      type: 'Normal',
      description: 'Tanaman padi dalam kondisi sehat tanpa gejala penyakit. Daun berwarna hijau segar dan pertumbuhan normal.',
      symptoms: 'Tidak ada gejala penyakit. Daun berwarna hijau segar, pertumbuhan normal, tidak ada bercak atau perubahan warna abnormal.',
      treatment: 'Tidak diperlukan pengobatan. Lanjutkan pemeliharaan rutin untuk menjaga kesehatan tanaman.',
      prevention: '1. Pemupukan berimbang\n2. Pengairan yang tepat\n3. Pengendalian hama dan penyakit secara preventif\n4. Sanitasi lahan yang baik\n5. Monitoring rutin kondisi tanaman',
    ),
  ];

  List<DiseaseModel> getAllDiseases() {
    return _diseases;
  }

  DiseaseModel? getDiseaseById(String id) {
    try {
      return _diseases.firstWhere((disease) => disease.id == id);
    } catch (e) {
      return null;
    }
  }

  DiseaseModel? getDiseaseByName(String name) {
    try {
      return _diseases.firstWhere(
        (disease) => disease.nameId.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  List<DiseaseModel> getDiseasesByType(String type) {
    return _diseases.where((disease) => disease.type == type).toList();
  }
}
