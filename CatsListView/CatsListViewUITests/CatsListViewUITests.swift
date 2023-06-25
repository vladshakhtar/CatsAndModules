//
//  CatsListViewUITests.swift
//  CatsListViewUITests
//
//  Created by Vladislav Stolyarov on 20.06.2023.
//

import Networking
import XCTest

final class CatsListViewUITests: XCTestCase {
    
    
    func testScreenshots() throws {
        let app = XCUIApplication()

        app.launchArguments += ["-UIDeviceOrientation", "portrait"]
        setupSnapshot(app)
        app.launch()

        // Wait for the "Fetch Cats/Dogs" button to appear and tap it
        let fetchButton = app.buttons["Fetch Cats/Dogs"]
        XCTAssertTrue(fetchButton.waitForExistence(timeout: 10))
        fetchButton.tap()

        // Wait for the list to load before taking screenshots
        let listLoaded = NSPredicate(format: "exists == 1")
        expectation(for: listLoaded, evaluatedWith: app.cells.element(boundBy: 0), handler: nil)
        waitForExpectations(timeout: 20, handler: nil)

        // Take screenshots of the main screen
        snapshot("Main Screen")

        // Tap on the first item in the list to open the details view
        let firstItem = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstItem.waitForExistence(timeout: 5))
        firstItem.tap()

        // Wait for the details view to appear before taking screenshots
        let detailsViewLoaded = NSPredicate(format: "exists == 1")
        expectation(for: detailsViewLoaded, evaluatedWith: app.staticTexts["Details View"], handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        // Take screenshots of the details screen
        snapshot("Details Screen")
    }


//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
