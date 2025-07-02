//
//  PieceCardView.swift
//  PieceOfHappiness
//
//  Created by Jungchul on 7/2/25.
//

import SwiftUI

struct PieceCardView: View {
    
    @State var title: String = ""
    @State var imageName: String = ""
    @State var contents: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text("당신을 위한 행복조각들")
                .padding(.top, 10)
                .padding(.bottom, 10)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                VStack{
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                    Text(contents)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .rotationEffect(Angle(degrees: Double.random(in: -5...5)))
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.bottom, 20)
    }
}

#Preview {
    PieceCardView(title: "dummy text", imageName: "dummy_image", contents: "dummy contents")
}
