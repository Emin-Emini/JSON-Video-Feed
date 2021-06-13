//
//  JSON_Video_Feed_Tests.swift
//  JSON Video Feed_Tests
//
//  Created by Emin Emini on 13.6.21.
//

import XCTest
@testable import JSON_Video_Feed

class JSON_Video_Feed_Tests: XCTestCase {
    
    let apiController = APIController()
    var feedVC: FeedViewController!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.feedVC = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        
        _ = feedVC.view
        
        self.feedVC.loadView()
        self.feedVC.viewDidLoad()
    }
    
    //MARK: Feed Table View Tests
    func testInitTableView() {
        XCTAssertNotNil(feedVC.feedTableView)
    }
    
    func testLoadViewSetsTableDataSource() {
        XCTAssertTrue(feedVC.feedTableView.dataSource is FeedViewController)
    }
    
    func testLoadViewSetsTableDelegate() {
        XCTAssertTrue(feedVC.feedTableView.delegate is FeedViewController)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(feedVC.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(feedVC.responds(to: #selector(feedVC.tableView(_:didSelectRowAt:))))
    }
        
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(feedVC.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(feedVC.responds(to:#selector(feedVC.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(feedVC.responds(to:#selector(feedVC.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
        let numberOfCells = feedVC.feedTableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfCells, feedVC.apiController.feedList.count)
    }
    
    
    //MARK: - API Tests
    func testGetFeedWithExpectedURLHostAndPath() {
        apiController.getFeed(completion: { result in
            switch result {
            case .success( _):
                XCTAssertEqual(
                    self.apiController.baseURL,
                    URL(string: "https://private-anon-9a67925951-technicaltaskapi.apiary-mock.com/feed?page=1&sport=football"))
            case .failure(let error):
                XCTFail("\(error)")
            }
        })
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidApiCallGetsHTTPStatusCode200() throws {
        let urlString =
        "https://private-anon-9a67925951-technicaltaskapi.apiary-mock.com/feed?page=1&sport=football"
        let urlRequest = URL(string: urlString)!
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                XCTFail("\(error)")
                return
            }
            if let error = error {
              XCTFail("Error: \(error.localizedDescription)")
              return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
              if statusCode == 200 {
                promise.fulfill()
              } else {
                XCTFail("Status code: \(statusCode)")
              }
            }
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }

}
