import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class SkeletonMovieCard extends StatelessWidget {
  const SkeletonMovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonContainer(
            width: double.infinity,
            height: 180,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          const SizedBox(height: 10),
          SkeletonContainer(width: 150, height: 16),
        ],
      ),
    );
  }
}

class SkeletonHorizontalList extends StatelessWidget {
  const SkeletonHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const SkeletonMovieCard();
      },
    );
  }
}

class SkeletonDetailScreen extends StatelessWidget {
  const SkeletonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image
          const SkeletonContainer(
            width: double.infinity,
            height: 400,
            borderRadius: BorderRadius.zero,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title place
                SkeletonContainer(width: 200, height: 24),
                const SizedBox(height: 10),
                SkeletonContainer(width: 150, height: 16),
                const SizedBox(height: 30),
                // Chips
                Row(
                  children: [
                    SkeletonContainer(
                      width: 80,
                      height: 32,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    const SizedBox(width: 10),
                    SkeletonContainer(
                      width: 80,
                      height: 32,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    const SizedBox(width: 10),
                    SkeletonContainer(
                      width: 80,
                      height: 32,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Overview Text
                SkeletonContainer(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                SkeletonContainer(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                SkeletonContainer(width: 250, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonMediaLibraryItem extends StatelessWidget {
  const SkeletonMediaLibraryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          const SkeletonContainer(
            width: 100,
            height: 120,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonContainer(width: 60, height: 10),
                  const SizedBox(height: 8),
                  SkeletonContainer(width: 150, height: 16),
                  const SizedBox(height: 8),
                  SkeletonContainer(width: 100, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonMediaLibraryList extends StatelessWidget {
  const SkeletonMediaLibraryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) => const SkeletonMediaLibraryItem(),
    );
  }
}

class SkeletonTicketBooking extends StatelessWidget {
  const SkeletonTicketBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SkeletonContainer(width: 100, height: 20),
          const SizedBox(height: 20),
          // Dates
          Row(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SkeletonContainer(
                  width: 70,
                  height: 40,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Showtimes
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    SkeletonContainer(width: 250, height: 20),
                    const SizedBox(height: 10),
                    SkeletonContainer(
                      width: 250,
                      height: 180,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonSeatSelection extends StatelessWidget {
  const SkeletonSeatSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Screen
          SkeletonContainer(
            width: 300,
            height: 40,
            borderRadius: BorderRadius.circular(100),
          ), // Curve-ish
          const SizedBox(height: 40),
          // Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: 80,
              itemBuilder: (_, __) => const SkeletonContainer(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonSearchResultItem extends StatelessWidget {
  const SkeletonSearchResultItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Movie Image
          const SkeletonContainer(
            width: 130,
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          const SizedBox(width: 20),
          // Movie Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonContainer(width: 120, height: 16),
                const SizedBox(height: 8),
                SkeletonContainer(width: 80, height: 12),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // More Icon placeholder
          SkeletonContainer(
            width: 20,
            height: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }
}

class SkeletonSearchResultList extends StatelessWidget {
  const SkeletonSearchResultList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) => const SkeletonSearchResultItem(),
    );
  }
}
