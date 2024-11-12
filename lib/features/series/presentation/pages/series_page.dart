import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/series_bloc.dart';
import '../bloc/series_event.dart';
import '../bloc/series_state.dart';

class SeriesPage extends StatelessWidget {
  const SeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final bloc = context.read<SeriesBloc>();

    bloc.add(GetAllSeriesEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Search Series',
                floatingLabelStyle: TextStyle(
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
                    return ListView.builder(
                      itemCount: state.seriesList.length,
                      itemBuilder: (context, index) {
                        final series = state.seriesList[index];
                        return ListTile(
                          title: Text(series.name),
                          leading: series.imageUrl != null
                              ? Image.network(series.imageUrl!)
                              : null,
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
    );
  }
}
