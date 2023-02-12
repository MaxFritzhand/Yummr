//
//  UserService.swift
//  PlopIt
//
//  Created by Raivis Olehno on 13/01/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase
import FirebaseCore
import GoogleSignIn
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import CryptoKit
import AuthenticationServices
import CodableFirebase

class UserService: NSObject {
    
    private let auth = Auth.auth()
    var isOwnerStatus = false
    // Unhashed nonce for Apple sign in
    var currentNonce: String?
    static var isOwner: Bool = false
    
    func login(email: String, password: String, withSuccess success:@escaping() -> (), withFailure failure: @escaping(String) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            if error != nil {
                failure(error!.localizedDescription)
                return
            }
            self.setOwnerStatus()
            success()
        }
    }
        
    func getOwnerStatus(completion: @escaping (_ isOwner: Bool?) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
                completion(nil)
                return
            }
        Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let doc = snapshot?.documents.first {
                if let isOwner = doc.get("isOwner") as? Bool {
                    completion(isOwner)
                } else {
                    completion(nil)
                }
            } else {
                if let error = error {
                    print(error)
                }
                completion(nil)
            }
        }
    }
    
    func setOwnerStatus() {
        guard let email = Auth.auth().currentUser?.email else {
                return
            }
        Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let doc = snapshot?.documents.first {
                if let isOwner = doc.get("isOwner") as? Bool {
                    UserDefaults.standard.set(isOwner, forKey: "isOwner")
                }
            }
        }
    }
    
    func checkOwnerStatusBeforeSocialSignIn(email: String) {
        Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let data = document.data()
                    let isOwner = data["isOwner"] as? Bool
                    print("Owner Status: \(String(describing: isOwner))")
                    
                    if isOwner! {
                        UserDefaults.standard.set(true, forKey: "isOwner")
                        self.isOwnerStatus = true
                        print("Set isOwner to true in UserDefault.")
                        
                    } else {
                        
                        print("isOwner = false")
                    }
                    
                    print("isOwnerStatus: \(String(describing: self.isOwnerStatus))")
                    
                }
                
            }
        }
    }
    
    func GoogleLogIn(vc: UIViewController, withSuccess success:@escaping() -> (), withFailure failure: @escaping(String) -> ()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { user, error in
            
            if let userEmail = user?.profile?.email {
                print("User email: \(userEmail)")
                self.checkOwnerStatusBeforeSocialSignIn(email: userEmail)
            }
            
            if let error = error {
                failure(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    failure("\(error)")
                    
                }

                
                print("Sign in successfully with Google")
                API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: "Google sign in a success!")
                
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    let displayName = user.displayName
                    
                    Firestore.firestore().collection("users").document(uid).setData([
                        
                        "email" : email,
                        "favoriteID" : "",
                        "fullName" : displayName,
                        "isOwner" : self.isOwnerStatus,
                        "ownerID" : "",
                        "userID" : uid
                    ], merge: true)
                    
                    success()
                }
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
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
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow(vc: LoginViewController) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = vc
        authorizationController.performRequests()
    }
    
    func resetPassword(email: String, withSuccess success:@escaping() -> (), withFailure failure: @escaping(String) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) {(error) in
            if let error = error {
                print("Error sending password reset: \(error)")
                failure("\(error)")
            } else {
                success()
                API.shared.bannerManager.showSuccessNotification(withTitle: "Password Reset", withMessage: "Password email sent, check spam inbox")
            }
        }
    }
    
    func createAccount(isOwner:Bool, email: String, password: String, confirmPassword: String, fullName: String, restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, hourArray: [String], dietaryDict: [String:Bool], genreDict: [String:Bool], restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String,  withSuccess success:@escaping() -> (), withFailure failure: @escaping(String) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if (error == nil) {
                print("-------> Account created")
                guard let result = result else { return }
                
                self.addUserInfoToFirestore(uId: result.user.uid, isOwner:isOwner, email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, restaurantName: restaurantName, addressStreet: addressStreet, addressCity: addressCity, addressState: addressState, addressZip: addressZip, restaurantDescription: restaurantDescription, phoneNumber: phoneNumber, priceRange: priceRange, websiteURL: websiteURL, hourArray: hourArray, dietaryDict: dietaryDict, genreDict: genreDict, restaurantHeaderImageURL: restaurantHeaderImageURL, restaurantThumbnailImageURL: restaurantThumbnailImageURL)
                success()
            }
            
            else{
                print("Error message: \(error!)")
                failure("\(error!.localizedDescription)")
                return
            }
        }
    }
    
    func createOwnerAccount(isOwner: Bool, email: String, password: String, confirmPassword: String, fullName: String, restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, hourArray: [String], dietaryDict: [String:Bool], genreDict: [String:Bool], restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String,  withSuccess success:@escaping() -> (), withFailure failure: @escaping(String) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if (error == nil) {
                
                print("-------> Account created")
                
                guard let result = result else { return }
                //
                self.addUserInfoToFirestore(uId: result.user.uid, isOwner:isOwner, email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, restaurantName: restaurantName, addressStreet: addressStreet, addressCity: addressCity, addressState: addressState, addressZip: addressZip, restaurantDescription: restaurantDescription, phoneNumber: phoneNumber, priceRange: priceRange, websiteURL: websiteURL, hourArray: hourArray, dietaryDict: dietaryDict, genreDict: genreDict, restaurantHeaderImageURL: restaurantHeaderImageURL, restaurantThumbnailImageURL: restaurantThumbnailImageURL)
                success()
            
            }
            
            else{
                print("Error message: \(error)")
                failure("\(error?.localizedDescription)")
                return
            }
        }
    }
    
    
    private func addUserInfoToFirestore(uId: String, isOwner:Bool, email: String, password: String, confirmPassword: String, fullName: String, restaurantName: String, addressStreet: String, addressCity: String, addressState: String, addressZip: String, restaurantDescription: String, phoneNumber: String, priceRange: String, websiteURL: String, hourArray: [String], dietaryDict: [String:Bool], genreDict: [String:Bool], restaurantHeaderImageURL: String, restaurantThumbnailImageURL: String) {
        let uid = uId
        
        var docData = [String:Any]()
        
        if isOwner == true{
            
            let ownerRef = Firestore.firestore().collection("Owners").document(uid)
            let ownerID = uid
            
            //restaurant doc
            let ownerDetailRef = Firestore.firestore().collection("Restaurant")
            
            let restaurantID = ownerDetailRef.collectionID
            
            let ownerDict = ["email":email,
                             "fullName": fullName,
                             "ownerID":ownerID,
                             "restaurantID": restaurantID,
                             "userID":uid]
            
            //ownerRef.addDocument(data: ownerDict)
            
            ownerRef.setData(ownerDict) { [self] (error) in
                if let error = error {
                    print("Error + \(error)")
                    return
                }
            }
            
            docData = ["fullName": fullName,
                       "email": email,
                       "favoriteID": "",
                       "isOwner":true,
                       "ownerID": ownerID,
                       "userID":uid]
            
            //add restaurant details here
            
            let ownerDetailData: [String : Any] = [
                "isApproved" : false,
                "menuHeaderArray" : [],
                "ownerID" : ownerID,
                "restaurantID" : restaurantID,
                "restaurantInformation" : [
                    "hours": [
                        "Monday" : hourArray[0],
                        "Tuesday" :  hourArray[1],
                        "Wednesday" : hourArray[2],
                        "Thursday" : hourArray[3],
                        "Friday" : hourArray[4],
                        "Saturday" : hourArray[5],
                        "Sunday": hourArray[6],
                    ],
                    "phoneNumber" : phoneNumber,
                    "restaurantAddress" : [
                        "city" : addressCity,
                        "latitudeLongitude" : "",
                        "state" : addressState,
                        "street" : addressStreet,
                        "zip" : addressZip,
                    ],
                    "restaurantDescription" : restaurantDescription,
                    "restaurantName" : restaurantName,
                    "websiteURL" : websiteURL,
                ],
                "restaurantSettings" : [
                    "dietary" : dietaryDict,
                    "priceRange" : priceRange,
                    "restaurantGenre" : genreDict,
                    "restaurantHeaderImageURL" : "https://firebasestorage.googleapis.com/v0/b/plopit-aceb3.appspot.com/o/defaultBackgroundHeader.png?alt=media&token=5e5b463a-6feb-420",
                    "restaurantThumbnailImageURL" : "https://firebasestorage.googleapis.com/v0/b/plopit-aceb3.appspot.com/o/defaultBackgroundHeader.png?alt=media&token=5e5b463a-6feb-420",
                ],
                "users" : [
                    "0" : uid
                ]
            ]
            
            Firestore.firestore().collection("Restaurant").addDocument(
                data: ownerDetailData
            ) { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            }
            API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: "Owner Account created")
        }
        else {
            docData =   ["fullName": fullName,
                         "email": email,
                         "favoriteID": "",
                         "isOwner":false,
                         "ownerID": "",
                         "userID":uid]
            API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: "User Account created")
        }
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData) { [self] (error) in
            if let error = error {
                print("Error + \(error)")
                return
            }
            fetchUserInfoFromFirestore(userRef: userRef) { user in
                print(user.fullName)
            }
        }
    }
    
    func fetchUserInfoFromFirestore(userRef: DocumentReference, completion: @escaping(User) -> Void) {
        //Change this to the previous code?
        userRef.getDocument { (snapshot, error) in
            if let error = error {
                print("Something went wrong : \(error)")
                API.shared.userManager.informConsumersUserFailedToGetCurrentUser(with: "\(error)")
                return
            }
            guard let safeSnapshot = snapshot else { return }
            if let doc = safeSnapshot.data() {
                let model = try! FirestoreDecoder().decode(User.self, from: doc)
                print(model.fullName)
                API.shared.userManager.informConsumersUserDidGetCurrentUser()
                //print(doc["fullName"])
               
            }
            
            
            //            let user = User.init(dic: safeSnapshot.data()!)
            //            print("Fetched Dat: \(user.fullName)")
        }
    }
    
    func getCurrentUserInfoWithEmail(UserEmail email: String, completion: @escaping(User) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let e = error {
                print(e)
            }
            guard let snapShot = querySnapshot?.documents else{return}
            snapShot.forEach { snap in
                let value =  snap.data()
                let model = try! FirestoreDecoder().decode(User.self, from: value)
                completion(model)
            }
        }
    }
    
    func getOwnerRestaurantInfo(withEmail email: String) {
        let db = Firestore.firestore()
        db.collection("Owners").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let e = error {
                print(e)
            }
            
            else {
                if let doc = snapshot?.documents {
                    
                    
                    //change to .decode
                    // let user = User.init(dic: doc[0].data())
                }
            }
        }
    }
    
    func getOwner(completion: @escaping(Owner) -> Void) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
        
        let docRef = Firestore.firestore().collection("Owners").document(uid)
        //let docRef = db.collection("Owners").document(uid)
        
        docRef.getDocument() { (document, error) in
            if let document = document{
                let data = document.data()
                let Owner = try! FirestoreDecoder().decode(Owner.self, from: (data)!)

                //let Owner = Owner(email: data!["email"], fullName: data!["fullName"], restaurantID: data!["restaurantID"], userID: data!["userID"], ownerID: data!["ownerID"])
                completion(Owner)
            } else{
                print("document does no exist in cache")
            }
        }
    }
    
    
    func getOwnerRestaurantID(){
        let user = Auth.auth().currentUser
        let uid = user!.uid
        
        let docRef = Firestore.firestore().collection("Owners").document(uid)
        //let docRef = db.collection("Owners").document(uid)
        
        docRef.getDocument(source: .cache){ (document, error) in
            if let document = document{
                let property = document.get("ownerID")
            } else{
                print("document does no exist in cache")
            }
        }
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> ()) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            completion(.success(true))
        } catch let err {
            completion(.failure(err))
        }
    }
    
}

// MARK: - FaceBook login

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        //let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        if let accessToken = AccessToken.current?.tokenString {
            let credential = FacebookAuthProvider
              .credential(withAccessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                }
                //user successfully sign in
                API.shared.userManager.informConsumersUserDidLogIn()
                print("Successfully sign in with Facebook")
                API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: "Facebook sign in a success!")
               
                
                GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
                    (connection, graphResult, error) in
                    if error != nil {
                        print("Failed to Start Graph Request:", error as Any)
                        return
                    }
                    
                    let facebookDetail = graphResult as! NSDictionary
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        let email = facebookDetail["email"]
                        let displayName = facebookDetail["name"]
                        
                        print("uid: \(uid)")
                        print("email: \(String(describing: email))")
                        print("display name: \(String(describing: displayName))")
                        
                        Firestore.firestore().collection("users").document(uid).setData([
                            
                            "email" : email,
                            "favoriteID" : "",
                            "fullName" : displayName,
                            "isOwner" : false,
                            "ownerID" : "",
                            "userID" : uid
                        ], merge: true)
                    }
                }
            }
        } else {
            API.shared.bannerManager.showWarningNotification(withTitle: "Warning", withMessage: "User cancelled sign in.")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out")
    }
}

//MARK: - Apple Login

@available(iOS 13.0, *)
extension UserService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    
                    return
                }
                // User is signed in to Firebase with Apple.
                API.shared.userManager.informConsumersUserDidLogIn()
                print("Successfully sign in with Apple")
                
                API.shared.bannerManager.showSuccessNotification(withTitle: "Success", withMessage: "Apple sign in a success!")
                
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    let displayName = appleIDCredential.fullName?.givenName
                    
                    print("uid: \(uid)")
                    print("email: \(String(describing: email))")
                    print("display name: \(String(describing: displayName))")
                    
                    Firestore.firestore().collection("users").document(uid).setData([
                        
                        "email" : email,
                        "favoriteID" : "",
                        "fullName" : displayName,
                        "isOwner" : false,
                        "ownerID" : "",
                        "userID" : uid
                    ], merge: true)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
