//  FilePicker Package
//
//  MIT License
//
//  Copyright (c) 2021 Mark Renaud
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI
import UniformTypeIdentifiers

public struct FilePickerUIRepresentable: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIDocumentPickerViewController
    public typealias PickedURLsCompletionHandler = (_ urls: [URL]) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    public let types: [UTType]
    public let allowMultiple: Bool
    public let pickedCompletionHandler: PickedURLsCompletionHandler
    
    public init(types: [UTType], allowMultiple: Bool, onPicked completionHandler: @escaping PickedURLsCompletionHandler) {
        self.types = types
        self.allowMultiple = allowMultiple
        self.pickedCompletionHandler = completionHandler
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = allowMultiple
        return picker
    }
    
    public func updateUIViewController(_ controller: UIDocumentPickerViewController, context: Context) {}
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerUIRepresentable
        
        init(parent: FilePickerUIRepresentable) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.pickedCompletionHandler(urls)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
