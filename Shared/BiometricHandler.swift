//
//  BiometricIDHandler.swift
//  handler-id
//
//  Created by Matheus Gois on 21/12/21.
//

import LocalAuthentication

// MARK: - Enums

enum BiometricError: Int {
    /// Authentication was not successful because user failed to provide valid credentials.
    case authenticationFailed = -1

    /// Authentication was canceled by user (e.g. tapped Cancel button).
    case userCancel = -2

    /// Authentication was canceled because the user tapped the fallback button (Enter Password).
    case userFallback = -3

    /// Authentication was canceled by system (e.g. another application went to foreground).
    case systemCancel = -4

    /// Authentication could not start because passcode is not set on the device.
    case passcodeNotSet = -5

    /// Authentication could not start because Touch ID is not available on the device.
    @available(macOS, introduced: 10.10, deprecated: 10.13, message: "use LAErrorBiometryNotAvailable")
    case touchIDNotAvailable = -6

    /// Authentication could not start because Touch ID has no enrolled fingers.
    @available(macOS, introduced: 10.10, deprecated: 10.13, message: "use LAErrorBiometryNotEnrolled")
    case touchIDNotEnrolled = -7

    /// Authentication was not successful because there were too many failed Touch ID attempts and
    /// Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating
    /// LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
    @available(macOS, introduced: 10.11, deprecated: 10.13, message: "use LAErrorBiometryLockout")
    case touchIDLockout = -8

    /// Authentication was canceled by application (e.g. invalidate was called while
    /// authentication was in progress).
    @available(macOS 10.11, *)
    case appCancel = -9

    /// LAContext passed to this call has been previously invalidated.
    @available(macOS 10.11, *)
    case invalidContext = -10

    /// Generic error
    case generic = -11
}

// MARK: - Handler

struct BiometricHandler {
    static func authenticate(reason: String, completion: @escaping (_ success: Bool, _ errorCode: BiometricError?) -> Void) {
        let laContext = LAContext()
        var error: NSError?

        if laContext.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {
            laContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometricsOrWatch,
                localizedReason: reason
            ) { success, authenticationError in
                if let authError = authenticationError as? LAError {
                    let errorCase = BiometricError(rawValue: authError.code.rawValue)
                    completion(success, errorCase)
                } else {
                    completion(success, nil)
                }
            }
        } else {
            completion(false, .generic)
        }
    }
}
