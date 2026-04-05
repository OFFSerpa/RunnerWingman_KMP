//
//  RouteMapThumbnail.swift
//  RunnerWingmanKMP
//

import SwiftUI
import MapKit

struct RouteMapThumbnail: View {

    // MARK: - Properties

    let coordinates: [CLLocationCoordinate2D]
    let size: CGSize
    let lineWidth: CGFloat

    @State private var image: UIImage?

    // MARK: - Body

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.tertiary)
                    .overlay {
                        ProgressView().scaleEffect(0.8)
                    }
            }
        }
        .frame(width: size.width, height: size.height)
        .clipped()
        .task(id: coordinates.count) {
            await makeSnapshot()
        }
    }

    // MARK: - Methods

    private func makeSnapshot() async {
        guard coordinates.count >= 2 else {
            image = nil
            return
        }

        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)

        let options = MKMapSnapshotter.Options()
        options.size = size
        options.scale = UIScreen.main.scale
        options.mapType = .mutedStandard

        let rect = polyline.boundingMapRect
        let padded = rect.insetBy(
            dx: -rect.size.width * 0.25,
            dy: -rect.size.height * 0.25
        )
        options.region = MKCoordinateRegion(padded)

        do {
            let snapshot = try await MKMapSnapshotter(options: options).start()
            let baseImage = snapshot.image

            let renderer = UIGraphicsImageRenderer(size: baseImage.size)
            let final = renderer.image { ctx in
                baseImage.draw(at: .zero)

                let path = UIBezierPath()
                var isFirst = true

                for coord in coordinates {
                    let pt = snapshot.point(for: coord)
                    if isFirst {
                        path.move(to: pt)
                        isFirst = false
                    } else {
                        path.addLine(to: pt)
                    }
                }

                UIColor.orange.setStroke()
                path.lineWidth = lineWidth
                path.lineCapStyle = .round
                path.lineJoinStyle = .round
                path.stroke()
            }

            image = final
        } catch {
            image = nil
        }
    }
}
