import 'package:flutter/material.dart';
import '../models/crypto_model.dart';
import '../services/crypto_service.dart';
import 'crypto_detail_screen.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late Future<List<Crypto>> _futureCryptos;

  @override
  void initState() {
    super.initState();
    _futureCryptos = CryptoService.fetchTopCryptos();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureCryptos = CryptoService.fetchTopCryptos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Tracker'), centerTitle: true),
      body: FutureBuilder<List<Crypto>>(
        future: _futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          final cryptos = snapshot.data ?? [];
          if (cryptos.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: cryptos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = cryptos[index];
                final isUp = c.change >= 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(c.imageUrl),
                    backgroundColor: Colors.transparent,
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Text(c.name),
                  subtitle: Text('\$${c.price.toStringAsFixed(2)}'),
                  trailing: Text(
                    '${c.change.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isUp ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CryptoDetailScreen(crypto: c),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
