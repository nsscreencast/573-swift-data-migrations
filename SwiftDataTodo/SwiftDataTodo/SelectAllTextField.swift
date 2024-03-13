import AppKit
import SwiftUI

struct SelectAllTextField: NSViewRepresentable {
    @Binding var value: String
    var onSubmit: () -> Void = {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> _SelectAllNSTextField {
        let textField = _SelectAllNSTextField()
        textField.stringValue = value
        textField.delegate = context.coordinator
        return textField
    }

    func updateNSView(_ textField: _SelectAllNSTextField, context: Context) {
        textField.stringValue = value
        if textField.currentEditor() == nil {
            textField.window?.firstResponder?.resignFirstResponder()
//            DispatchQueue.main.async {
//                textField.becomeFirstResponder()
//                textField.selectAll()
//            }
        }
    }

    private func onSubmit(_ block: @escaping () -> Void) {
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: SelectAllTextField

        init(parent: SelectAllTextField) {
            self.parent = parent
        }

        func controlTextDidEndEditing(_ obj: Notification) {
            parent.onSubmit()
        }

        func controlTextDidChange(_ obj: Notification) {
            parent.value = (obj.object as! NSTextField).stringValue
        }
    }
}

class _SelectAllNSTextField: NSTextField {
    func selectAll() {
        currentEditor()?.selectAll(self)
    }

    override func mouseDown(with event: NSEvent) {
        selectAll()
    }
}
