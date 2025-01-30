//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Jaya on 27/01/25.
//

import XCTest
@testable import NewsApp

class NewsPresenterTests: XCTestCase {
    func testFetchingNews() {
        let expectation = self.expectation(description: "Fetching news")
        NetworkService.shared.fetchNews { result in
            switch result {
            case .success(let articles):
                XCTAssertFalse(articles.isEmpty, "News list should not be empty")
            case .failure:
                XCTFail("Fetching news failed")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
