//
//  FilterPaletteView.swift
//  KolesovTaskAezakmi
//
//  Created by Dima Kolesov on 25.04.2025.
//

import Foundation
import SwiftUI

struct FilterPaletteView: View {
    @ObservedObject var vm: ImageProcessingViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(PhotoFilter.allCases) { filter in
                    Button(action: {
                        vm.apply(filter: filter)
                    }) {
                        Text(filter.displayName)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(vm.selectedFilter == filter ? Color.accentColor : Color.secondary.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(8)
        }
        .background(Color(.systemGroupedBackground))
    }
}

