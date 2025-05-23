//
//  TextEditorView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct TextEditorView: View {
    @ObservedObject var textVM: TextElementsViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var fontSize: CGFloat
    @State private var selectedColor: Color
    @State private var selectedFont: String
    @State private var inputText: String
    @State private var fontFamilies: [String] = []
    
    init(textVM: TextElementsViewModel) {
        self.textVM = textVM
        let element = textVM.selectedTextElement
        _inputText = State(initialValue: element?.text ?? textVM.newText)
        _fontSize = State(initialValue: element?.fontSize ?? 24)
        _selectedColor = State(initialValue: element?.color ?? .black)
        _selectedFont = State(initialValue: element?.fontName ?? "Helvetica Neue")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("Введите текст", text: $inputText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .submitLabel(.done)
                    
                    fontSelector
                    fontSizeControl
                    colorPicker
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Редактор текста")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        saveText()
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadFonts()
            }
            .onReceive(textVM.$selectedTextElement) { element in
                guard let element = element else { return }
                updateFields(with: element)
            }
        }
    }
    
    private func loadFonts() {
        DispatchQueue.global(qos: .userInitiated).async {
            let families = UIFont.familyNames.sorted()
            DispatchQueue.main.async {
                self.fontFamilies = families
            }
        }
    }
    
    private func updateFields(with element: TextElement) {
        inputText = element.text
        fontSize = element.fontSize
        selectedColor = element.color
        selectedFont = element.fontName
    }
    
    private func saveText() {
        guard !inputText.isEmpty else { return }
        
        textVM.newText = inputText
        
        if let selected = textVM.selectedTextElement {
            textVM.updateElement(
                id: selected.id,
                text: inputText,
                fontSize: fontSize,
                color: selectedColor,
                fontName: selectedFont
            )
        } else {
            textVM.addText(
                inputText,
                fontSize: fontSize,
                color: selectedColor,
                fontName: selectedFont
            )
        }
    }
    
    private var fontSelector: some View {
        Picker("Шрифт", selection: $selectedFont) {
            ForEach(UIFont.familyNames.sorted(), id: \.self) { family in
                Text(family).tag(family)
            }
        }
    }
    
    private var fontSizeControl: some View {
        HStack {
            Text("Размер: \(Int(fontSize))")
            Slider(value: $fontSize, in: 12...72, step: 1)
        }
    }
    
    private var colorPicker: some View {
        ColorPicker("Цвет текста", selection: $selectedColor)
    }
}
