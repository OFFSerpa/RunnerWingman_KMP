//
//  TrackCard.swift
//  RunnerWingmanKMP
//

import SwiftUI
import CoreLocation

struct TrackCard: View {

    // MARK: - Properties

    let viewData: ViewData

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {

            RouteMapThumbnail(
                coordinates: viewData.coordinates,
                size: CGSize(width: 82, height: 82),
                lineWidth: 4
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {

                Text(viewData.title)
                    .font(.title)
                    .fontWeight(.semibold)

                HStack(spacing: 6) {

                    Text("Melhor Tempo")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(viewData.bestTime)
                        .font(.subheadline)
                }
            }.padding(.vertical)

            Spacer(minLength: 0)

            Text("\(viewData.distance)m")
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())

        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background)
                .shadow(radius: 2, y: 1)
        )
    }
}

// MARK: - ViewData

extension TrackCard {
    struct ViewData: Identifiable {
        let id = UUID()
        let title: String
        let bestTime: String
        let distance: Int
        let coordinates: [CLLocationCoordinate2D]
    }
}
