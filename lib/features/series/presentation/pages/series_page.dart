import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/series_bloc.dart';
import '../bloc/series_event.dart';
import '../bloc/series_state.dart';
import 'serie_detail_page.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  late SeriesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<SeriesBloc>();
    bloc.add(GetAllSeriesEvent());
  }

  Future<void> _refreshData() async {
    bloc = context.read<SeriesBloc>();
    bloc.add(GetAllSeriesEvent());
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final bloc = context.read<SeriesBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Series')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Search for series.',
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      bloc.add(
                        SearchSeriesQuery(_controller.text.trim()),
                      );
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                onChanged: (query) {
                  bloc.add(
                    SearchSeriesQuery(query.trim()),
                  );
                },
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  bloc.add(
                    SearchSeriesQuery(query.trim()),
                  );
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<SeriesBloc, SeriesState>(
                  builder: (context, state) {
                    if (state is SeriesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SeriesLoaded) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.seriesList.length,
                        itemBuilder: (context, index) {
                          final series = state.seriesList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SerieDetailPage(serie: series),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 160,
                                  child: series.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Image.network(
                                            series.imageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        series.name,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        series.summary != null
                                            ? "${series.summary?.replaceAll(RegExp(r'<[^>]*>'), '')}"
                                            : "Explanation not available.",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        series.genres.isNotEmpty
                                            ? series.genres.join(', ')
                                            : "No species information available.",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is SeriesError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(
                        child: Text("Enter a term to search for a serie."));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
