//
//  BottomView.swift
//  basketball-frontend
//
//  Created by Jeffrey Igims on 11/9/20.
//  Copyright © 2020 Matthew Cruz. All rights reserved.
//

import SwiftUI

struct BottomView<Content: View>: View {
  @Binding var isOpen: Bool
  @GestureState private var slide: CGFloat = 0
  
  private var offset: CGFloat {
    isOpen ? 0 : maxHeight - minHeight
  }
  let content: Content
  let maxHeight: CGFloat
  let minHeight: CGFloat
  
  private var indicator: some View {
    RoundedRectangle(cornerRadius: 16)
      .fill(Color.white)
      .frame(
        width: 60,
        height: 6
      ).onTapGesture {
        self.isOpen.toggle()
      }
  }
  
  // @ViewBuilder allows for the content of the view to be a closur. This is used by VStack, HStack, and ZStack
  init(isOpen: Binding<Bool>, maxHeight : CGFloat, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.maxHeight = maxHeight
    self.minHeight = maxHeight * 0.3
    self._isOpen = isOpen
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        self.indicator.padding()
        self.content
      }.frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
      .background(Color("tabBarIconColor"))
      .cornerRadius(16)
      .frame(height: geometry.size.height, alignment: .bottom)
      .offset(y: max(self.offset + self.slide, 0))
      .animation(.interactiveSpring())
      .gesture(
        DragGesture().updating(self.$slide) { value, state, _ in
          state = value.translation.height
        }.onEnded { value in
          let snapDistance = self.maxHeight * 0.25
          guard abs(value.translation.height) > snapDistance else {
            return
          }
          self.isOpen = value.translation.height < 0
        }
      )
    }
  }
}

struct BottomView_Previews: PreviewProvider {
  static var previews: some View {
    BottomView(isOpen: .constant(false), maxHeight: 600) {
      Rectangle().fill(Color.blue)
    }.edgesIgnoringSafeArea(.all)
  }
}

