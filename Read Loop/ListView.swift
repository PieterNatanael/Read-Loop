//
//  ListView.swift
//  Read Loop
//
//  Created by Pieter Yoshua Natanael on 21/03/25.
//



import SwiftUI

struct TextEntry: Identifiable, Codable {
    let id: UUID
    var text: String
    var previewText: String
    var dateCreated: Date
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        let lines = text.components(separatedBy: .newlines)
        self.previewText = lines.prefix(3).joined(separator: "\n")
        self.dateCreated = Date()
    }
}

struct ListView: View {
    @State private var savedTexts: [TextEntry] = []
    @State private var newText: String = ""
    @State private var showCopyConfirmation: Bool = false
    
    var body: some View {
        VStack {
            // Text Input Section
            VStack {
                TextEditor(text: $newText)
                    .frame(height: 150)
                    .border(Color.gray.opacity(0.3), width: 1)
                    .padding()
                
                HStack {
                    Button(action: saveText) {
                        Text("Save Text")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(newText.isEmpty)
                    
                    // Paste Button for macOS
                    Button(action: {
                        if let clipboardText = NSPasteboard.general.string(forType: .string) {
                            newText = clipboardText
                        }
                    }) {
                        Image(systemName: "doc.on.clipboard.fill")
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        newText = ""
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.purple)
                    }
                }
            }
            
            // Saved Texts List
            List {
                ForEach(savedTexts) { entry in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.previewText)
                                .font(.caption)
                                .lineLimit(3)
                            
                            Text(entry.dateCreated, style: .date)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        // Copy to Clipboard Button
                                   Button(action: {
                                       let pasteboard = NSPasteboard.general
                                       pasteboard.clearContents()
                                       pasteboard.setString(entry.text, forType: .string)
                                       showCopyConfirmation = true
                                   }) {
                                       Image(systemName: "doc.on.clipboard")
                                           .foregroundColor(.blue)
                                   }
                                   
                                   // 🗑 Delete Button
                                   Button(action: {
                                       deleteEntry(entry)
                                   }) {
                                       Image(systemName: "trash")
                                           .foregroundColor(.red)
                                   }
                                   .padding(.leading, 5)
                               }
                           }
                           .onDelete(perform: deleteEntries)
                       
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures it takes up available space
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fixes cut-off issue
        .padding()
        .alert(isPresented: $showCopyConfirmation) {
            Alert(
                title: Text("Text Copied"),
                message: Text("The text has been copied to clipboard."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onTapGesture {
            NSApp.keyWindow?.makeFirstResponder(nil) // Dismiss keyboard
        }
    }
    
    func deleteEntry(_ entry: TextEntry) {
        savedTexts.removeAll { $0.id == entry.id }
        saveToUserDefaults()
    }
    
    func saveText() {
        guard !newText.isEmpty else { return }
        
        let newEntry = TextEntry(text: newText)
        savedTexts.append(newEntry)
        newText = ""
        saveToUserDefaults()
    }
    
    func deleteEntries(at offsets: IndexSet) {
        savedTexts.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedTexts) {
            UserDefaults.standard.set(encoded, forKey: "savedTexts")
        }
    }
    
    init() {
        if let savedTextsData = UserDefaults.standard.object(forKey: "savedTexts") as? Data {
            let decoder = JSONDecoder()
            if let loadedTexts = try? decoder.decode([TextEntry].self, from: savedTextsData) {
                _savedTexts = State(initialValue: loadedTexts)
            }
        }
    }
}

// Preview for SwiftUI
struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

//import SwiftUI
//
//struct ListView : View {
//    var body: some View {
//        VStack{
//            
//        }
//    }
//}
//
//#Preview{
//    ListView()
//}
