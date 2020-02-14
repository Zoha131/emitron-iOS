/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

private struct SizeKey: PreferenceKey {
  static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    value = value ?? nextValue()
  }
}

struct ContinueButtonView: View {
  @State var size: CGSize?
  var body: some View {
    HStack { // This container is a hack to centre it on a navigation link
      Spacer()
      HStack {
        Image.materialIconPlay
          .resizable()
          .frame(width: 40, height: 40)
          .foregroundColor(.white)
        Text("Continue")
          .foregroundColor(.white)
          .font(.uiButtonLabel)
          .fixedSize()
      }
        .padding([.vertical, .leading], 10)
        .padding([.trailing], 18) // Since the play image has its own padding
        .background(GeometryReader { proxy in
          Color.clear.preference(key: SizeKey.self, value: proxy.size)
        })
        .frame(width: size?.width, height: size?.height)
        .background(
          RoundedRectangle(cornerRadius: 9)
            .fill(Color.appBlack)
          .overlay(
            RoundedRectangle(cornerRadius: 9)
              .stroke(Color.white, lineWidth: 5)
          )
        )
        .onPreferenceChange(SizeKey.self) { size in
          self.size = size
        }
      Spacer()
    }
  }
}

struct ContinueButtonView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      ContinueButtonView().colorScheme(.dark)
      ContinueButtonView().colorScheme(.light)
    }
    .padding(20)
    .background(Color.blue)
  }
}