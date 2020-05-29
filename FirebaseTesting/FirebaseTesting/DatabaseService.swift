//
//  DatabaseService.swift
//  FirebaseTesting
//
//  Created by Alex Paul on 5/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

class DatabaseService {
  
  func isEmployed(status: Bool) -> Bool {
    if status {
      return true
    }
    return false
  }
  
  
  func fetchUser(completion: @escaping (Result<String, Error>) -> ()) {
    
  }
  
}
