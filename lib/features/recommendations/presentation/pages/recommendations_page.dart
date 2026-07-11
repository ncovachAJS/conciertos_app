import 'package:conciertos_app/features/recommendations/presentation/pages/data/models/recommended_event_model.dart';
import 'package:conciertos_app/features/recommendations/presentation/pages/data/services/recommendations_api_service.dart';
import 'package:conciertos_app/features/recommendations/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';

import '../../../concerts/data/repositories/concert_repository_impl.dart';

import '../../../../core/constants/countries.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final api = RecommendationsApiService();

  final concertRepository = ConcertRepositoryImpl();

  List<RecommendedEventModel> events = [];

  String selectedCountry = '';

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      loading = true;
    });

    try {
      final likedArtists = await concertRepository.getLikedArtists();

      events = await api.getRecommendations(
        artists: likedArtists,
        countryCode: selectedCountry,
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recomendados')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: DropdownButtonFormField<String>(
              value: selectedCountry,

              decoration: const InputDecoration(
                labelText: 'País',
                border: OutlineInputBorder(),
              ),

              items: countries.entries.map((country) {
                return DropdownMenuItem(
                  value: country.value,

                  child: Text(country.key),
                );
              }).toList(),

              onChanged: (value) async {
                selectedCountry = value ?? '';

                await _loadRecommendations();
              },
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : events.isEmpty
                ? const Center(
                    child: Text('No se han encontrado recomendaciones.'),
                  )
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (_, index) {
                      final event = events[index];

                      return RecommendationCard(event: event);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
