
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorit_cubit.dart';
import '../cubit/pengajuan_cubit.dart';
import '../navigation/app_routes.dart';

class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Warga',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kelola aktivitas dan layanan Anda sebagai warga.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 25),

          // Profil warga
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Colors.blue),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elvi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Pengguna Aplikasi',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Keranjang pengajuan
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Keranjang Pengajuan',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BlocBuilder<PengajuanCubit, List<String>>(
                builder: (context, keranjang) {
                  return Chip(
                    avatar: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 18,
                    ),
                    label: Text('${keranjang.length} layanan'),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          BlocBuilder<PengajuanCubit, List<String>>(
            builder: (context, keranjang) {
              if (keranjang.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 30,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Keranjang masih kosong. Pilih layanan dari menu Layanan untuk menambahkannya.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  ...keranjang.map(
                    (namaLayanan) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.description_outlined),
                        ),
                        title: Text(
                          namaLayanan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text('Menunggu pengajuan dikirim'),
                        trailing: IconButton(
                          tooltip: 'Hapus dari keranjang',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            context
                                .read<PengajuanCubit>()
                                .hapusPengajuan(namaLayanan);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final jumlah = keranjang.length;

                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Kirim Semua Pengajuan?'),
                            content: Text(
                              'Anda akan mengirim $jumlah layanan sekaligus. Lanjutkan?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<PengajuanCubit>()
                                      .kirimSemuaPengajuan();

                                  Navigator.pop(dialogContext);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '$jumlah layanan berhasil diajukan.',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Kirim'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim Semua Pengajuan'),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          const Text(
            'Aktivitas Warga',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // Riwayat laporan
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.history, color: Colors.blue, size: 30),
              title: const Text(
                'Riwayat Laporan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Lihat laporan dan pengaduan yang pernah Anda kirim.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.riwayatLaporan);
              },
            ),
          ),
          const SizedBox(height: 14),

          // Pengaduan warga
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.report_problem_outlined,
                color: Colors.orange,
                size: 30,
              ),
              title: const Text(
                'Pengaduan Warga',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Sampaikan permasalahan di lingkungan kota.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Fitur pengaduan warga akan segera tersedia.',
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Informasi warga
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.info_outline,
                color: Colors.green,
                size: 30,
              ),
              title: const Text(
                'Informasi Warga',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Informasi dan layanan yang tersedia untuk warga.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Informasi warga tersedia pada aplikasi Nusantara Cerdas.',
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // Layanan favorit
          const Text(
            'Layanan Favorit',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          BlocBuilder<FavoritCubit, Set<String>>(
            builder: (context, daftarFavorit) {
              final daftarLayanan = daftarFavorit.toList();

              if (daftarLayanan.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.star_border, color: Colors.grey, size: 30),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Belum ada layanan yang ditandai sebagai favorit.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: daftarLayanan.map((namaLayanan) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
                      title: Text(
                        namaLayanan,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Layanan yang Anda tandai sebagai favorit.',
                      ),
                      trailing: IconButton(
                        tooltip: 'Hapus dari favorit',
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context
                              .read<FavoritCubit>()
                              .batalTandai(namaLayanan);
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
