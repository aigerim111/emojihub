import 'package:emojihub/repo/emoji_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    _scroll.addListener(() {
      final bloc = context.read<SearchBloc>();
      final state = bloc.state;
      if (!state.canLoadMore) return;
      if (state.status == SearchStatus.loadingMore ||
          state.status == SearchStatus.loading)
        return;

      final threshold = _scroll.position.maxScrollExtent - 300;
      if (_scroll.position.pixels >= threshold) {
        bloc.add(const SearchLoadMoreRequested());
      }
    });

    context.read<SearchBloc>().add(const SearchStarted());
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed('/suggest'),
            child: const Text('Get prediction for a day'),
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, s) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => bloc.add(SearchQueryChanged(v)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: s.selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All'),
                          ),
                          ...s.categories.map(
                            (c) => DropdownMenuItem<String?>(
                              value: c,
                              child: Text(c),
                            ),
                          ),
                        ],
                        onChanged: (v) => bloc.add(SearchCategoryChanged(v)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<SortMode>(
                        value: s.sort,
                        decoration: const InputDecoration(
                          labelText: 'Sort',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: SortMode.alpha,
                            child: Text('A–Z'),
                          ),
                          DropdownMenuItem(
                            value: SortMode.category,
                            child: Text('By category'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) bloc.add(SearchSortChanged(v));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: s.desc ? 'Descending' : 'Ascending',
                      onPressed: () => bloc.add(const SearchToggleOrder()),
                      icon: Icon(s.desc ? Icons.south : Icons.north),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (s.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
                    child: Text(s.error!),
                  ),

                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    itemCount: s.items.length + 1,
                    itemBuilder: (context, i) {
                      if (i == s.items.length) {
                        if (s.status == SearchStatus.loading ||
                            s.status == SearchStatus.loadingMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              s.canLoadMore
                                  ? 'Scroll to load more'
                                  : 'Done. Total: ${s.total}',
                            ),
                          ),
                        );
                      }

                      final item = s.items[i];
                      return Card(
                        child: ListTile(
                          leading: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(item.name),
                          subtitle: Text('${item.category} • ${item.group}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
