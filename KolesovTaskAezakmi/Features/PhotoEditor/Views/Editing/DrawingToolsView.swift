//
//  DrawingToolsView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI
import PencilKit

struct DrawingToolsView: View {
    @Binding var selectedTool: PKInkingTool
    
    private let tools: [DrawingTool] = [
        DrawingTool(inkType: .pen, color: .black, width: 3),
        DrawingTool(inkType: .marker, color: .red, width: 10)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(tools, id: \.self) { tool in
                    Button {
                        withAnimation {
                            selectedTool = tool.pkTool
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: iconName(for: tool.inkType))
                                .font(.system(size: 20))
                            
                            Text(toolName(for: tool.inkType))
                                .font(.caption2)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            selectedTool.inkType == tool.inkType ?
                            Color.accentColor : Color(.secondarySystemFill)
                        )
                        .foregroundColor(
                            selectedTool.inkType == tool.inkType ?
                            .white : .primary
                        )
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
        }

        .background(Material.regularMaterial)
              .cornerRadius(12)
              .shadow(radius: 3)
              .padding()
    }
    
    private func iconName(for inkType: PKInkingTool.InkType) -> String {
        switch inkType {
        case .pen: "pencil"
        case .marker: "highlighter"
        default: "pencil.tip"
        }
    }
    
    private func toolName(for inkType: PKInkingTool.InkType) -> String {
        switch inkType {
        case .pen: "Карандаш"
        case .marker: "Маркер"
        default: "Инструмент"
        }
    }
}

