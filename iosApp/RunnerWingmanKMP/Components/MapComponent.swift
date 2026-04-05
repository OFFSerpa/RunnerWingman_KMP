//
//  MapComponent.swift
//  RunnerWingmanKMP
//

import SwiftUI
import MapKit

struct MapComponent: UIViewRepresentable {

    // MARK: - Properties

    let polyline: MKPolyline?
    var isFollowingUser: Bool = true

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)

        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.isZoomEnabled = true

        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll

        let config = MKStandardMapConfiguration(elevationStyle: .realistic)
        config.emphasisStyle = .muted
        mapView.preferredConfiguration = config

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.updateOverlay(on: mapView, polyline: polyline)

        let desired: MKUserTrackingMode = isFollowingUser ? .followWithHeading : .none
        if mapView.userTrackingMode != desired {
            mapView.setUserTrackingMode(desired, animated: false)

            if desired == .followWithHeading {
                context.coordinator.applyWazeCameraStyle(to: mapView, animated: false)
            }
        }

        if !isFollowingUser, let polyline {
            let rect = polyline.boundingMapRect
            let insets = UIEdgeInsets(top: 80, left: 40, bottom: 160, right: 40)
            mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, MKMapViewDelegate {
        private var currentOverlay: MKPolyline?

        func updateOverlay(on mapView: MKMapView, polyline: MKPolyline?) {
            if let currentOverlay {
                mapView.removeOverlay(currentOverlay)
                self.currentOverlay = nil
            }

            guard let polyline else { return }
            mapView.addOverlay(polyline)
            currentOverlay = polyline
        }

        func applyWazeCameraStyle(to mapView: MKMapView, animated: Bool) {
            let current = mapView.camera
            let camera = MKMapCamera(
                lookingAtCenter: current.centerCoordinate,
                fromDistance: 450,
                pitch: 55,
                heading: current.heading
            )
            mapView.setCamera(camera, animated: animated)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .orange
                renderer.lineWidth = 5
                renderer.lineCap = .round
                renderer.lineJoin = .round
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        }
    }
}
