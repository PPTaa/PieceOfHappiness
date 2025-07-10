//
//  BaseHeaderView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/10/25.
//

import SwiftUI

struct BaseHeaderView: View {
    let title: String
    var leftButtonImage: Image?
    var rightButtonImage: Image?
    var onLeftButtonTapped: (() -> Void)? = nil
    var onRightButtonTapped: (() -> Void)? = nil
    
    public init(title: String,
                leftButtonImage: Image? = nil,
                rightButtonImage: Image? = nil,
                onLeftButtonTapped: (() -> Void)? = nil,
                onRightButtonTapped: (() -> Void)? = nil
    ) {
        self.title = title
        self.leftButtonImage = leftButtonImage
        self.rightButtonImage = rightButtonImage
        self.onLeftButtonTapped = onLeftButtonTapped
        self.onRightButtonTapped = onRightButtonTapped
    }
    
    var body: some View {
        HStack {
            if let image = leftButtonImage,
               let action = onLeftButtonTapped {
                Button(action: action) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: DesignConstant.headerButtonSize, height: DesignConstant.headerButtonSize)
                }
                .background(.green)
            } else {
                Spacer().frame(width: DesignConstant.headerButtonSize)
            }
            Text(title)
                .appFont(.headlineH1)
                .frame(alignment: .center)
                .frame(maxWidth: .infinity)
            Spacer()
            if let image = rightButtonImage,
               let action = onRightButtonTapped {
                Button(action: action) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: DesignConstant.headerButtonSize, height: DesignConstant.headerButtonSize)
                }
            } else {
                Spacer().frame(width: DesignConstant.headerButtonSize)
            }
        }
        .frame(height: DesignConstant.headerHeight)
        .padding(.horizontal, DesignConstant.basicPadding)
        .background(.red)
    }
}

#Preview {
    BaseHeaderView(title: "BaseHeaderView",
                   leftButtonImage: Image(systemName: "arrow.left"),
                   rightButtonImage: Image(systemName: "heart"),
                   onLeftButtonTapped: { print("left button tapped") },
                   onRightButtonTapped: { print("right button tapped") })
}
