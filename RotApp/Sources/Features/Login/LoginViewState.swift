//
//  LoginViewState.swift
//  RotApp
//
//  Created by m1 on 07/11/2025.
//

import Foundation

struct LoginViewState {
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var isSuccess: Bool = false
    var errorMessage: String?
}
