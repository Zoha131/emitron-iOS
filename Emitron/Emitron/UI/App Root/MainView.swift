/// Copyright (c) 2019 Razeware LLC
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

struct MainView: View {
  @EnvironmentObject var sessionController: SessionController
  @EnvironmentObject var dataManager: DataManager
  
  var body: some View {
    return contentView
      .background(Color.backgroundColor)
  }
  
  private var contentView: AnyView {
    /* One could be excused for thinking that one could, or
       maybe even should, use guard let to unwrap the user
       here. However, this currently does not seem to work with
       an @Published variable with an optional type. So that's
       nice isn't it? Defo didn't spend many hours discovering
       this. Not irritated in the slightest.
     */
    
    if !sessionController.isLoggedIn {
      return AnyView(LoginView())
    }
    
    switch sessionController.state {
    case .failed:
      return AnyView(LoginView())
    case .initial, .loading, .loadingAdditional:
      sessionController.fetchPermissionsIfNeeded()
      return tabBarView()
    case .hasData:
      // This is a mess—see above.
      if sessionController.hasPermissionToUseApp {
        return tabBarView()
      } else {
        return AnyView(LogoutView())
      }
    }
  }
  
  private func tabBarView() -> AnyView {
    let libraryView = LibraryView(
      filters: dataManager.filters,
      libraryRepository: dataManager.libraryRepository
    )
    
    let myTutorialsView = MyTutorialView(
      state: .inProgress,
      inProgressRepository: dataManager.inProgressRepository,
      completedRepository: dataManager.completedRepository,
      bookmarkRepository: dataManager.bookmarkRepository,
      domainRepository: dataManager.domainRepository
    )
    
    let downloadsView = DownloadsView(
      contentScreen: .downloads,
      downloadRepository: dataManager.downloadRepository
    )
    
    return AnyView(
      TabNavView(libraryView: AnyView(libraryView),
                 myTutorialsView: AnyView(myTutorialsView),
                 downloadsView: AnyView(downloadsView))
    )
  }
}