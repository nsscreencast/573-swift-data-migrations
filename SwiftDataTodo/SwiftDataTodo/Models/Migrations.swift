import SwiftData

enum Migrations: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
        Models_v1.self,
        Models_v1_5.self,
        Models_v2.self
    ]

    static var stages: [MigrationStage] {
        [
            migrateV1toV1_5,
            migrateV1toV2
        ]
    }
}

extension Migrations {
    static var migrateV1toV1_5: MigrationStage {
        .lightweight(fromVersion: Models_v1.self, toVersion: Models_v1_5.self)
    }

    static var migrateV1toV2: MigrationStage {
        .custom(
            fromVersion: Models_v1_5.self,
            toVersion: Models_v2.self,
            willMigrate: { context in
                let v1Tasks = try context.fetch(FetchDescriptor<Models_v1_5.Task>())
                for task in v1Tasks {
                    task.createdAt = task.createdAt ?? .now
                    task.completedAt = task.isCompleted ? .now : nil
                }
                try context.save()
            },
            didMigrate: { context in }
        )
    }
}
