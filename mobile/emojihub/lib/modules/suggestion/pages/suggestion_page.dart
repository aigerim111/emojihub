import 'package:emojihub/modules/suggestion/bloc/suggestion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestPage extends StatelessWidget {
  const SuggestPage({super.key});

  String _todayKey() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d'; // YYYY-MM-DD
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SuggestBloc>();
    final today = _todayKey();

    return Scaffold(
      appBar: AppBar(title: const Text('Prediction of the day')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<SuggestBloc, SuggestState>(
          builder: (context, s) {
            final isLoading = s.status == SuggestStatus.loading;
            final data = s.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Today: $today',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => bloc.add(SuggestRequested(today)),
                  child: Text(isLoading ? 'Loading...' : 'Get prediction'),
                ),

                const SizedBox(height: 12),

                if (s.error != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
                    child: Text(s.error!),
                  ),

                if (data == null && s.error == null) ...[
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Press the button to get your prediction of the day.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],

                if (data != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: data.emojis
                        .take(3)
                        .map(
                          (e) => Text(e, style: const TextStyle(fontSize: 56)),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Tip: this result is cached on the server for 24 hours.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
