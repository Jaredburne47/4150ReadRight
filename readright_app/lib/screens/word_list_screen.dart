import 'package:flutter/material.dart';

//Word list on student end

class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Lists'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search words or lists',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Featured Lists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.list_alt, size: 20)),
                      title: const Text('Dolch Sight Words'),
                      subtitle: const Text('Common sight words for early readers'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.book, size: 20)),
                      title: const Text('Phonics Words'),
                      subtitle: const Text('Phonics sets for letter sounds'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.compare_arrows, size: 20)),
                      title: const Text('Minimal Pairs'),
                      subtitle: const Text('Pairs to practice similar sounds'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Center(
                child: Text('Tap a list to view words — this is a static placeholder for now',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
