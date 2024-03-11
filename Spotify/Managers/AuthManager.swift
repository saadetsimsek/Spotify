//
//  AuthManager.swift
//  Spotify
//
//  Created by Saadet Şimşek on 11/03/2024.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "47db1ac2fadd4643be219212a260a4ca"
        static let clientSecret = "2682acf148ed4ef494382e49b16044a1"
    }
    
    private init(){
        
    }
    
    public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://iosacademy.io" // spotify developer page, redirecturl must be same
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken:Bool {
        return false
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool)) -> Void){
        //Get Token
    }
    
    public func refreshAccessToken(){
        
    }
    
    private func cacheToken(){
        
    }
}
