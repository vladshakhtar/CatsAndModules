//
//  ContentView.swift
//  CatsListView
//
//  Created by Vladislav Stolyarov on 29.05.2023.
//

import SwiftUI
import Networking
import FirebasePerformance
import FirebaseCrashlytics


private enum ConfigConst {
    static let API_CONFIG = "List Configuration"
}


// MARK: Main View with list of cats and dogs
struct CatsListView: View {
    @StateObject private var animalViewModel = AnimalViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button("Fetch Cats/Dogs") {
                        fetchAnimals()
                    }
                    Spacer()
                    Button("Just Fatal Error") {
                        logFatalError()
                    }
                    Spacer()
                }
                List(animalViewModel.animals) { animal in
                    NavigationLink(destination: CatDetailView(animal: animal)) {
                        VStack {
                            AsyncImage(url: URL(string: animal.url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                case .failure:
                                    Image(systemName: "wifi.slash")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            Text(animal.id)
                        }
                        .onAppear {
                            logScreenAvailability()
                        }
                    }
                }
            }
            .navigationBarTitle("Animal List")
        }
    }
    
    func fetchAnimals() {
        Task {
            do {
                try await animalViewModel.fetchAnimals()
            } catch {
                print("Failed to fetch animals: \(error)")
            }
        }
    }
    
    func logFatalError() {
        CrashManager.shared.setValue(value: "true", key: "fatalError Button tapped")
        Crashlytics.crashlytics().log("Button 'Just Fatal Error' tapped")
        fatalError("This is a fatal crash")
    }
    
    func logScreenAvailability() {
        CrashManager.shared.setValue(value: "Screen is visible", key: "screen_availability")
    }
}

struct CatsListView_Previews: PreviewProvider {
    static var previews: some View {
        CatsListView()
    }
}

// MARK: Full Screen Cat Photo View
struct CatDetailView: View {
    let animal: Animal
    
    var body: some View {
        VStack {
            Spacer()
            AsyncImage(url: URL(string: animal.url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            
            Spacer()
        }
        .navigationBarTitle(Text(animal.id), displayMode: .inline)
    }
}


struct CatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CatDetailView(animal: Animal(id: "p5", url: "https://cdn2.thecatapi.com/images/p5.jpg"))
    }
}

// MARK: Model class that is connected with Networking Module
class AnimalViewModel: ObservableObject {
    @Published var animals: [Animal] = []
    private let networkingService = Networking()
    
    func fetchAnimals() async throws {
        let config = getConfigFromInfoPlist()
        
        switch config {
        case .CATS:
            let cats = try await networkingService.getCats()
            DispatchQueue.main.async {
                self.animals = cats.map { Animal(id: $0.id, url: $0.url) }
            }
        case .DOGS:
            let dogs = try await networkingService.getDogs()
            DispatchQueue.main.async {
                self.animals = dogs.map { Animal(id: $0.id, url: $0.url) }
            }
        }
    }
    
    private func getConfigFromInfoPlist() -> ConfigType {
        let mainBundle = Bundle.main
        let infoPlist = mainBundle.infoDictionary
        
        guard let config = infoPlist?[ConfigConst.API_CONFIG] as? String else {
            fatalError("App has no config")
        }
        
        return ConfigType(rawValue: config) ?? .CATS
    }
}

// MARK: CrashManager class to make custom logs and keys in Crashlytics
final class CrashManager {
    static let shared = CrashManager()
    private init() {}
    
    func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
}

// MARK: ConfigType to represent the configuration options
enum ConfigType: String {
    case CATS
    case DOGS
}
