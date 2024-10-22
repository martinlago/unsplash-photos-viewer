//
//  CustomGrid.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import SwiftUI

struct CustomGrid<Content>: View where Content: View {
    
    @State private var contentSize = CGSize.zero
    
    var columns: Int
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    var content: (() -> Content)
    
    init(columns: Int,
         horizontalSpacing: CGFloat = 24,
         verticalSpacing: CGFloat = 24,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.columns = columns
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }
    
    var body: some View {
        CustomGridLayout(
            content: content,
            columns: columns,
            size: contentSize,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        )
        .frame(minWidth: UIScreen.main.bounds.size.width, minHeight: contentSize.height)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.size) { (_, newValue) in
                        DispatchQueue.main.async {
                            contentSize = CGSize(
                                width: newValue.width - (columns == 4 ? 132 : 24),
//                                height: columns == 4 ? (newValue.height / 2) : newValue.height
                                height: newValue.height / 2
                            )
                        }
                    }
            }
        )
    }
}
