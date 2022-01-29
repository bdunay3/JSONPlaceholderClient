//
//  LogoutIcon.swift
//  JSONPlaceholder
//
//  Created by Bill Dunay on 2/16/22.
//  Copyright © 2022 Bill Dunay. All rights reserved.
//

import SwiftUI

struct LogoutIcon: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: "person.fill")
                .foregroundColor(.gray)
                .frame(alignment: .center)
            
            Image(systemName: "arrow.right.square.fill")
                .resizable()
                .renderingMode(.original)
                .foregroundColor(.red)
                .background(Color.white)
                .frame(width: 8, height: 8, alignment: .bottomTrailing)
        }
        .frame(width: 25, height: 25)
    }
}

struct LogoutIcon_Previews: PreviewProvider {
    static var previews: some View {
        LogoutIcon()
    }
}
