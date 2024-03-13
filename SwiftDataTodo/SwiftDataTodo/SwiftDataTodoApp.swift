import Foundation
import SwiftUI
import SwiftData

@main
struct SwiftDataTodoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Task.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let shouldReset = CommandLine.arguments.contains("-reset_db")
        if shouldReset {
            let dbURL = modelConfiguration.url
            if FileManager.default.fileExists(atPath: dbURL.path(percentEncoded: false)) {
                try? FileManager.default.removeItem(at: dbURL)
            }
        }

        do {
            let container = try ModelContainer(
                for: schema,
                migrationPlan: Migrations.self,
                configurations: [modelConfiguration]
            )

            if shouldReset {
                let context = ModelContext(container)
                Task.mock(count: 3).forEach { task in
                    context.insert(task)
                }
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
