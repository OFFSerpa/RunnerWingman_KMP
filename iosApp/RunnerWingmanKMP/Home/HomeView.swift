//
//  HomeView.swift
//  RunnerWingmanKMP
//

import SwiftUI
import SwiftData
import CoreLocation
import Shared

struct HomeView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RouteModel.createdAt, order: .reverse) private var routes: [RouteModel]
    @State private var routeToRename: RouteModel?
    @State private var renameText: String = ""

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(routes) { route in

                        let coords = route.points.map {
                            CLLocationCoordinate2D(
                                latitude: $0.latitude,
                                longitude: $0.longitude
                            )
                        }

                        NavigationLink {
                            RunningMapView(route: route)
                        } label: {
                            TrackCard(
                                viewData: .init(
                                    title: route.name,
                                    bestTime: TimeFormattersHelper.mmss(route.bestLapSeconds),
                                    distance: Int(route.distanceMeters),
                                    coordinates: coords
                                )
                            )
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                routeToRename = route
                                renameText = route.name
                            } label: {
                                Label("Renomear", systemImage: "pencil")
                            }

                            Button(role: .destructive) {
                                delete(route)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.top, 12)
            }

            NavigationLink {
                RecordingMapView()
            } label: {
                FixedButton(viewData: .init(title: "Nova Rota"))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 30)
            .padding(.bottom, 12)
        }
        .navigationTitle("Trajetos")
        .alert("Renomear pista", isPresented: Binding(
            get: { routeToRename != nil },
            set: { if !$0 { routeToRename = nil } }
        )) {
            TextField("Nome", text: $renameText)

            Button("Cancelar", role: .cancel) {
                routeToRename = nil
            }

            Button("Salvar") {
                renameCurrentRoute()
            }
        }
    }

    // MARK: - Methods

    private func renameCurrentRoute() {
        guard let route = routeToRename else { return }

        let repo = RouteRepository(context: modelContext)
        do {
            try repo.rename(route, to: renameText)
        } catch {
            print(error)
        }

        routeToRename = nil
    }

    private func delete(_ route: RouteModel) {
        let repo = RouteRepository(context: modelContext)
        do {
            try repo.delete(route)
        } catch {
            print(error)
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .modelContainer(for: [RouteModel.self, RoutePointModel.self], inMemory: true)
}
