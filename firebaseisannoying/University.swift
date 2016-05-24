//
//  Universities.swift
//  Swaggerz
//
//  Created by Philippe Rivard on 1/11/16.
//  Copyright © 2016 Swaggerz Light. All rights reserved.
//

import Foundation

class University {
    private var _uniName: String
    // private var _uniCountry: String
    private var _uniState: String
    // private var _uniCity: String
    // private var _uniColorBanner: String
    //  private var _uniColorBackground: String
    
    init(uniName: String, uniState: String) {
        _uniName = uniName
        //_uniCountry = uniCountry
        _uniState = uniState
        // _uniCity = uniCity
        // _uniColorBanner = uniColorBanner
        // _uniColorBackground = uniColorBackground
    }
    
    var uniName: String {
        return _uniName
    }
    
    // var uniCountry: String {
    //     return _uniCountry
    // }
    
    var uniState: String {
        return _uniState
    }
    
    // var uniCity: String {
    //    return _uniCity
    // }
    
    // var uniColorBanner: String {
    //     return _uniColorBanner
    // }
    
    // var unicolorBackground: String {
    //     return _uniColorBackground
    // }
    
}