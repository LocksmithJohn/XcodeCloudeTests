//
//  Managers.swift
//  XcodeCloudeTests
//
//  Created by Jan Slusarz on 26/10/2021.
//

import Foundation

class AccountValidator {

  func validate(login: String) -> LoginValidatorState {
    login.count >= 8 ? .valid : .tooShort
  }
  func validateLength(password: String) -> Bool { password.count >= 8 }

  func validateStrong(password: String) -> Bool {
    let set: [CharacterSet] = [.lowercaseLetters, .uppercaseLetters, .decimalDigits]
    return !set.contains { element in password.rangeOfCharacter(from: element) == nil }
  }

  func validateMatch(password: String, confirmed: String) -> Bool {
    password == confirmed
  }

  func validatePassword(state: (length: Bool, strong: Bool, match: Bool)) -> Set<PasswordValidatorState> {
    var result = Set<PasswordValidatorState>()

    if ((state.length && state.strong && state.match) == true) {
      result.insert(.valid)
    } else {
      if (state.length == false) { result.insert(.invalidLength) }
      if (state.strong == false) { result.insert(.weakPassword) }
      if (state.match == false) { result.insert(.noMatch) }
    }

    return result
  }

  //MARK: Validatod Message
  func composeValidatorMessage(state: LoginValidatorState) -> String {
    var result: String
    switch state {
      case .tooShort : result = "Username must be at least 8 characters long"
      case .valid: result = ""
    }

    return result
  }

  func composeValidatorMessage(state: Set<PasswordValidatorState>) -> String {
    var result: String = ""
    func compose(text: String) {
      if result.isEmpty { result = text }
      else { result += "\n\(text)" }
    }

    for item in state.sorted(by: { (l, r) -> Bool in l.rawValue > r.rawValue }) {
      switch item {
        case .invalidLength: compose(text: "Password must be at least 8 characters long")
        case .noMatch: compose(text: "Passwords don't match")
        case .weakPassword: compose(text: "Password is too weak")
        case .valid: compose(text: "")
      }
    }

    return result
  }
}

class AccountManager {

  public static let shared = AccountManager()

  private var _createAccountModel = CreateAccountViewModel(validator: AccountValidator())

  public var createAccountModel: some CreateAccountViewModelProtocol { self._createAccountModel }

  private init() { }

}
