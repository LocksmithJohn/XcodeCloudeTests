//
//  XcodeCloudeTestsApp.swift
//  XcodeCloudeTests
//
//  Created by Jan Slusarz on 26/10/2021.
//

import SwiftUI

@main
struct XcodeCloudeTestsApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        CreateAccountView(model: AccountManager.shared.createAccountModel)
      }
    }
  }
}
