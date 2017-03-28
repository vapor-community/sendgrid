//
//  SecureToken.swift
//  Mail
//
//  Created by Anthony Castelli on 3/28/17.
//
//

import Foundation

/** Coppied from TurstyleCrypto.
  * Reason for this is to elimite the requirement on Tunrstyle per Vapor 2.0
 **/
public class SecureToken {
    private let file = fopen("/dev/urandom", "r")
    
    /// Initialize URandom
    public init() {}
    
    deinit {
        fclose(file)
    }
    
    private func read(numBytes: Int) -> [Int8] {
        /// Initialize an empty array with numBytes+1 for null terminated string
        var bytes = [Int8](repeating: 0, count: numBytes)
        fread(&bytes, 1, numBytes, file)
        
        return bytes
    }
    
    /// Get a byte array of random UInt8s
    public func random(numBytes: Int) -> [UInt8] {
        return unsafeBitCast(read(numBytes: numBytes), to: [UInt8].self)
    }
    
    /// Get a random string usable for authentication purposes
    public var token: String {
        return Data(bytes: random(numBytes: 16)).base64UrlEncodedString
    }
    
}

extension Data {
    var base64UrlEncodedString: String {
        return base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}
