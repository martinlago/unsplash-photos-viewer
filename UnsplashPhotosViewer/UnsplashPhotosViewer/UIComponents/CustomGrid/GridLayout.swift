//
//  GridLayout.swift
//  UnsplashPhotosViewer
//
//  Created by Martin Lago on 17/10/24.
//

import SwiftUI

struct CustomGridLayout<Content>: View where Content: View {
    
    var content: (() -> Content)
    var columns: Int
    var size: CGSize
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    
    var defaultIndex: Int = 0
    var lineSize: CGFloat {
        let currentSize = size.width
        let currentSpacing = horizontalSpacing
        return max((currentSize - (currentSpacing * CGFloat(columns - 1))) / CGFloat(columns), 0)
    }
    
    var body: some View {
        var alignments = Array(repeating: CGFloat.zero, count: columns)
        var currentIndex = defaultIndex
        var currentLineSpan = 1
        var top: CGFloat = 0
        
        ZStack(alignment: .topLeading) {
            content()
                .frame(width: lineSize, height: nil)
                .fixedSize(horizontal: false, vertical: true)
                .alignmentGuide(.leading) { dimensions in
                    func updateCurrentLineSpan() {
                        currentLineSpan = Int(round((dimensions.width + horizontalSpacing) / (lineSize + horizontalSpacing)))
                    }
                    
                    currentIndex = alignments
                        .enumerated()
                        .map { enumerated -> (element: CGFloat, offset: Int) in
                            let element = (0..<currentLineSpan).reduce(enumerated.element) { alignment, span in
                                guard alignments.indices.contains(enumerated.offset + span)
                                else { return -.infinity }
                                return min(alignment, alignments[enumerated.offset + span])
                            }
                            return (element, enumerated.offset)
                        }
                        .sorted { $0.element > $1.element }
                        .first!
                        .offset
                    
                    
                    top = alignments[currentIndex..<min(currentIndex + currentLineSpan, columns)].min()!
                    for index in currentIndex..<min(currentIndex + currentLineSpan, columns) {
                        alignments[index] = top - dimensions.height - verticalSpacing
                    }
                    return CGFloat(-currentIndex) * (lineSize + horizontalSpacing)
                    
                }
                .alignmentGuide(.top) { _ in
                    top
                }
            
            Color.clear
                .frame(width: 1, height: 1)
                .hidden()
                .alignmentGuide(.leading) { _ in
                    alignments = Array(repeating: .zero, count: columns)
                    currentIndex = defaultIndex
                    currentLineSpan = 1
                    top = 0
                    return 0
                }
        }
    }
}
