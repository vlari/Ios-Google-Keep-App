//
//  TagListViewControllerTests.swift
//  NotesAppTests
//
//  Created by Obed Garcia on 29/1/22.
//

import XCTest
@testable import NotesApp

class TagListViewControllerTests: XCTestCase {
    var sut: TagListViewController!
    
    override func setUpWithError() throws {
        sut = TagListViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTagTableViewDelegateExist() {
        let tableView = sut.tagTableView
        
        XCTAssertNotNil(tableView.delegate, "Delegate")
        XCTAssertNotNil(tableView.dataSource, "Data Source")
    }
}
