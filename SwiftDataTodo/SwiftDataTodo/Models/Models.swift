import Foundation
import SwiftData

typealias Task = Models_v2.Task

enum Models_v1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }

    static var versionIdentifier: Schema.Version = .init(1, 0, 0)

    @Model
    final class Task: Identifiable {
        var text: String
        var isCompleted: Bool

        init(text: String, isCompleted: Bool = false) {
            self.text = text
            self.isCompleted = isCompleted
        }
    }
}

enum Models_v1_5: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }

    static var versionIdentifier: Schema.Version = .init(1, 5, 0)

    @Model
    final class Task: Identifiable {
        var text: String
        var isCompleted: Bool
        var completedAt: Date?
        var createdAt: Date?

        init(text: String, isCompleted: Bool = false) {
            self.text = text
            self.isCompleted = isCompleted
        }
    }
}

enum Models_v2: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }

    static var versionIdentifier: Schema.Version = .init(2, 0, 0)

    @Model
    final class Task: Identifiable {
        var text: String

        var createdAt: Date
        var completedAt: Date?

        var isCompleted: Bool {
            completedAt != nil
        }

        init(text: String, createdAt: Date = .now, completedAt: Date? = nil) {
            self.text = text
            self.createdAt = createdAt
            self.completedAt = completedAt
        }
    }
}
