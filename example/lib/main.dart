import 'package:flutter/material.dart';
import 'package:shimmerize/shimmerize.dart';

void main() {
  runApp(const ShimmerizeExampleApp());
}

class ShimmerizeExampleApp extends StatelessWidget {
  const ShimmerizeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shimmerize example',
      theme: ThemeData(
        useMaterial3: true,
        extensions: const [
          ShimmerizeConfigData(
            containersColor: Color(0xFFDADAE3),
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        extensions: const [
          ShimmerizeConfigData.dark(),
        ],
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  bool _isLoading = true;
  PaintingEffect _effect = const ShimmerEffect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('shimmerize example'),
        actions: [
          Row(
            children: [
              const Text('Loading'),
              Switch(
                value: _isLoading,
                onChanged: (v) => setState(() => _isLoading = v),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _EffectPicker(
            value: _effect,
            onChanged: (v) => setState(() => _effect = v),
          ),
          const SizedBox(height: 16),
          _SectionTitle('1) Auto skeleton (wrap any widget tree)'),
          const SizedBox(height: 12),
          Shimmerize(
            isLoading: _isLoading,
            effect: _effect,
            enableSwitchAnimation: true,
            child: const _AutoCard(),
          ),
          const SizedBox(height: 24),
          _SectionTitle('2) Custom mode (Bones only)'),
          const SizedBox(height: 12),
          Shimmerize.custom(
            isLoading: _isLoading,
            effect: _effect,
            child: const _CustomBonesCard(),
          ),
          const SizedBox(height: 24),
          _SectionTitle('3) ShimmerizeList.builder'),
          const SizedBox(height: 12),
          SizedBox(
            height: 340,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ShimmerizeList.builder(
                isLoading: _isLoading,
                items: _demoItems,
                loadingItemCount: 6,
                itemBuilder: (context, item, index, isLoading) {
                  if (isLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Bone.circle(size: 44),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Bone.text(words: 5),
                                SizedBox(height: 8),
                                Bone.text(words: 9),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListTile(
                    title: Text(item ?? '-'),
                    subtitle: const Text('Tap loading switch to see skeleton'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EffectPicker extends StatelessWidget {
  const _EffectPicker({
    required this.value,
    required this.onChanged,
  });

  final PaintingEffect value;
  final ValueChanged<PaintingEffect> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PaintingEffect>(
      segments: const [
        ButtonSegment<PaintingEffect>(
          value: ShimmerEffect(),
          label: Text('Shimmer'),
        ),
        ButtonSegment<PaintingEffect>(
          value: PulseEffect(),
          label: Text('Pulse'),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _AutoCard extends StatelessWidget {
  const _AutoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.network(
                  'https://picsum.photos/seed/shimmerize/800/400',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Membership Plan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'A fun, high-energy workout with a clear CTA section.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose your class',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Book now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomBonesCard extends StatelessWidget {
  const _CustomBonesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Bone(
              height: 140,
              width: double.infinity,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            SizedBox(height: 12),
            Bone.text(words: 5),
            SizedBox(height: 6),
            Bone.multiText(lines: 3),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Bone.button(height: 44)),
                SizedBox(width: 12),
                Bone.iconButton(size: 44),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const _demoItems = <String>[
  'Monthly',
  'Quarterly',
  'Yearly',
  'VIP',
];
