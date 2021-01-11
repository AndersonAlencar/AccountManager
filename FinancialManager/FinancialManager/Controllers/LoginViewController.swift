//
//  LoginViewController.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 11/01/21.
//

import UIKit
import Firebase
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController {
    
    fileprivate var currentNonce: String?

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light

        super.viewDidLoad()
        setupSignButton()
    }
    
    func setupSignButton() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        button.center = view.center
        view.addSubview(button)
    }
    
    @objc func handleSignInWithAppleTapped() {
        performSignIn()
    }
    
    func performSignIn() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDprovider = ASAuthorizationAppleIDProvider()
        let request = appleIDprovider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()
      return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid State: A login callback was received, but no login request was sent")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let user = authResult?.user {
                    print("Nice! You are signed in as \(String(describing: user.displayName))")
                }
                
          }
            let storyboard = UIStoryboard(name: "FinanceTabBar", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabControllerID") as! FinanceTabViewController
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
            
        }
        
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}
