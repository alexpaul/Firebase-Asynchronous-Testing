//
//  FirebaseTestingTests.swift
//  FirebaseTestingTests
//
//  Created by Alex Paul on 5/29/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@testable import FirebaseTesting

class FirebaseTestingTests: XCTestCase {
  override func setUp() {
    super.setUp()
    FirebaseApp.configure()
  }
  
  //===========================================================================
  // unit test - testIfFilePathExist
  //===========================================================================
    func testIfFilePathExist() {
    // arrange
    let queryPath = Bundle.main.path(forResource: "landscape2", ofType: "jpg") // optional String?
    
    // act
    guard let _ = queryPath else {
      XCTFail("failed to read path")
      return
    }
    
    // assert
    XCTAssert(true)
  }
  
  //===========================================================================
  // unit test - testConvertBundlePathToData
  //===========================================================================
  func testConvertBundlePathToData() {
    // arrange
    let queryPath = Bundle.main.path(forResource: "landscape1", ofType: "jpg") // optional String?
    
    guard let path = queryPath else {
      XCTFail("failed to read path")
      return
    }
    
    // act
    guard let imageData = FileManager.default.contents(atPath: path) else {
      XCTFail("failed, data contents is nil")
      return
    }
    
    // assert
    XCTAssertEqual(imageData.count, 37024)
  }
  
  //===========================================================================
  // asychronous (network) test for firebase
  //===========================================================================
  
  //===========================================================================
  // firebase - testing authentication
  //===========================================================================
  func testCreateAuthenticatedUser() {
    // arrange
    let email = "\(randomName())@bunny.com"
    let password = "123456"
    let exp = XCTestExpectation(description: "auth user created")
    
    // act
    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      exp.fulfill()
      // assert
      if let error = error {
        XCTFail("failed to create auth user with error: \(error.localizedDescription)")
      } else if let authDataResult = authDataResult {
        XCTAssertEqual(authDataResult.user.email, email)
      }
    }
    
    wait(for: [exp], timeout: 3.0) // 3 seconds
  }
  
  func randomName() -> String {
    let alphabet = "abcdefghijklmnopqrstuvwxyz"
    var name = ""
    for _ in 0..<4 {
      name.append(alphabet.randomElement() ?? "a")
    }
    return name
  }
  
  
  //===========================================================================
  // firebase - testing firestore database
  //===========================================================================
  
  func testCreateDatabaseUser() {
    // arrange
    let exp = XCTestExpectation(description: "db user created")
    guard let user = FirebaseAuth.Auth.auth().currentUser else {
      XCTFail("no logged user")
      return
    }
    let userDict: [String: Any] = ["email": user.email ?? "",
                                   "username": user.displayName ?? "",
                                   "userId": user.uid,
                                   "createdDate": Date(),
                                   "formattedAddress": "568 Broadway, New York",
                                   "phone Number": "555-673-8912"
    ]
    
    // act
    // collection -> document
    Firestore.firestore().collection("users").document(user.uid).setData(userDict) { (error) in
      exp.fulfill()
      // assert
      if let error = error {
        XCTFail("failed to create db user with error: \(error.localizedDescription)")
      }
      
      XCTAssert(true)
    }
    
    wait(for: [exp], timeout: 3.0)
  }
  
  func testIsEmployed() {
    // arrange
    let databaseService = DatabaseService()
    
    // act
    let status = databaseService.isEmployed(status: true)
    
    // assert
    XCTAssertEqual(status, true)
  }
  
  func testFetchUser() {
    
    let databaseService = DatabaseService()
    
    
    databaseService.fetchUser { (result) in
      switch result {
      case .failure:
        break
      case .success:
        break
      }
    }
    
  }
  
  
  //===========================================================================
  // firebase - testing storage
  //===========================================================================
  
  func testUploadVideo() {
    // arrange
    
    let exp = XCTestExpectation(description: "video uploaded")
    let queryPath = Bundle.main.path(forResource: "Mulan-Trailer", ofType: "mp4") // optional String?
    
    guard let path = queryPath else {
      XCTFail("failed to read path")
      return
    }
    
    guard let videoData = FileManager.default.contents(atPath: path) else {
      XCTFail("failed, data contents is nil")
      return
    }
    
    let storageRef = FirebaseStorage.Storage.storage().reference()
    let videoRef = storageRef.child("Videos/mulan")
    
    let metedata = StorageMetadata()
    metedata.contentType = "video/mp4" // mime type e.g "application/json" "images/jpg" "video/mp4"
    
    // act
    videoRef.putData(videoData, metadata: metedata) { (metadata, error) in
      exp.fulfill()
      // assert
      if let error = error {
        XCTFail("failed to upload video with error: \(error.localizedDescription)")
      }
      XCTAssert(true)
    }
    
    wait(for: [exp], timeout: 10.0)
  }
}
