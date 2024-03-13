import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    enum Route: Hashable {
        case tasks
    }
    @State private var route: Route = .tasks

    var body: some View {
        NavigationSplitView {
            List(selection: $route) {
                NavigationLink(value: Route.tasks) {
                    Label("Tasks", systemImage: "pencil.and.list.clipboard")
                }
            }
        } detail: {
            switch route {
                case .tasks: TaskList()
            }
        }
    }
}

struct TaskView: View {
    @Bindable var task: Task
    @Binding var editingTask: Task?
    @FocusState var focus: Task?

    @Binding var isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                .font(.title)
                .onTapGesture {
                    task.completedAt = task.isCompleted ? nil : .now
                }

            if editingTask == task {
                SelectAllTextField(value: $task.text, onSubmit: {
                    editingTask = nil
                    isSelected = true
                })
                .offset(x: -4, y: -1)
            } else {
                Text(task.text)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                    .onTapGesture {
                        if isSelected {
                            editingTask = task
                            focus = task
                        } else {
                            isSelected = true
                        }
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 3)
            }
        }
    }
}

struct TaskList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        .init(\Task.completedAt),
        .init(\Task.createdAt)
    ], animation: .default) private var tasks: [Task]

    @State private var editingTask: Task?
    @State private var selectedTask: Task?

    private func selectionBinding(for task: Task) -> Binding<Bool> {
        .init(
            get: { selectedTask == task },
            set: { selected in selectedTask = selected ? task : nil }
        )
    }

    var body: some View {
        List(selection: $selectedTask) {
            ForEach(tasks, id: \.self) { task in
                TaskView(task: task, editingTask: $editingTask, isSelected: selectionBinding(for: task))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .contextMenu(ContextMenu(menuItems: {
                        Button(role: .destructive) {
                            modelContext.delete(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }))
            }
            .onDelete(perform: deleteItems)
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        var tasksToDelete: Set<Task> = []
        for index in offsets {
            tasksToDelete.insert(tasks[index])
        }

        withAnimation {
            for task in tasksToDelete {
                modelContext.delete(task)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let task = Task(text: "New Item")
            modelContext.insert(task)
            selectedTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                editingTask = task
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(.preview())
}
