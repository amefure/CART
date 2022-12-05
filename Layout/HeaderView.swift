//
//  HeaderView.swift
//  CART
//
//  Created by t&a on 2022/11/25.
//

import SwiftUI

struct HeaderView: View {
    
    let deviceWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(spacing:0){
            Image("CART-LOGO")
                .resizable()
                .frame(width: 100, height: 30)
        }.frame(width: deviceWidth,height: 60).background(Color("FoundationColor"))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
