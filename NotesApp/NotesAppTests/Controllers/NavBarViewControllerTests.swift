//
//  NavBarViewController.swift
//  NotesAppTests
//
//  Created by Obed Garcia on 29/1/22.
//

import XCTest
@testable import NotesApp

class NavBarViewControllerTests: XCTestCase {
    var sut: NavBarViewController!
    
    override func setUpWithError() throws {
        sut = NavBarViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTableViewDelegateExist() {
        let tableView = sut.tableView
        
        XCTAssertNotNil(tableView.delegate, "Delegate")
        XCTAssertNotNil(tableView.dataSource, "Data Source")
    }
    
    func testTableViewRowsShouldBe2() {
        let dataSource = sut.tableView.dataSource
        let numberOfRows = dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(numberOfRows, 2)
    }
    
    func testTableViewRow0LabelShouldBeNotes() {
        let dataSource = sut.tableView.dataSource
        let rowCell = dataSource?.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(rowCell?.textLabel?.text, "Notes")
    }
    
    func testTableViewRow1LabelShouldBeSettings() {
        let dataSource = sut.tableView.dataSource
        let rowCell = dataSource?.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(rowCell?.textLabel?.text, "Settings")
    }

}
