import SwiftData

extension Task {
    static func mock(count: Int) -> [Task] {
        let possibleTasks = [
            "Get milk",
            "Fix tire",
            "Vaccuum",
            "Laundry",
            "Read for 20m",
            "Mow the lawn",
            "Do the dishes"
        ]

        return possibleTasks.prefix(count).map({ Task(text: $0) })
    }
}

extension ModelContainer {
    static func preview(_ taskCount: Int = 3) -> ModelContainer {
        let container = try! ModelContainer(for: Task.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = ModelContext(container)

        for task in Task.mock(count: taskCount) {
            context.insert(task)
        }
        
        return container
    }
}
