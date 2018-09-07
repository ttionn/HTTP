//
//  HTTPTaskTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
@testable import HTTP

class HTTPTaskTests: XCTestCase {
    
    var sut: HTTPTask!
    
    let request = URLRequest(url: URL(string: "www.fake.com")!)
    let session = URLSession.shared
    
    let fakeBase = "www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        sut = HTTPDataTask(request: request, session: session, completion: { _ in })
    }
    
    func testDataTask() {
        let dataTask = sut as! HTTPDataTask
        XCTAssert(dataTask.sessionTask is URLSessionDataTask)
    }
    
    func testDataTaskForDownload() {
        sut = HTTPDataTask(request: request, session: session, taskType: .download, completion: { _ in })
        XCTAssert((sut as! HTTPDataTask).sessionTask is URLSessionDownloadTask)
    }
    
    func testDataTaskForUpload() {
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        sut = HTTPDataTask(request: request, session: session, taskType: .upload(content), completion: { _ in })
        XCTAssert((sut as! HTTPDataTask).sessionTask is URLSessionDataTask)
    }
    
    func testFileTaskForDownload() {
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HTTPFileTask(request: request, session: session, taskType: .download, progress: progress, completed: completed)
        XCTAssertEqual((sut as! HTTPFileTask).taskType, .download)
        XCTAssertNotNil((sut as! HTTPFileTask).progress)
        XCTAssertNotNil((sut as! HTTPFileTask).completed)
        XCTAssert((sut as! HTTPFileTask).sessionTask is URLSessionDownloadTask)
    }
    
    func testFileTaskForUpload() {
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        let fileRequest = HTTPFileRequest(base: fakeBase, path: fakePath, method: .post, params: nil, headers: nil, sessionConfig: .standard, taskType: .upload(content), completed: nil)
        let request = fileRequest.urlRequest!
        
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HTTPFileTask(request: request, session: session, taskType: .upload(content), progress: progress, completed: completed)
        XCTAssertEqual((sut as! HTTPFileTask).taskType, .upload(content))
        XCTAssertNotNil((sut as! HTTPFileTask).progress)
        XCTAssertNotNil((sut as! HTTPFileTask).completed)
        XCTAssert((sut as! HTTPFileTask).sessionTask is URLSessionUploadTask)
    }
    
    func testTaskType() {
        let content = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: Data())
        
        let data: TaskType = .data
        let download: TaskType = .download
        let upload: TaskType = .upload(content)
        
        XCTAssertEqual(data, TaskType.data)
        XCTAssertEqual(download, TaskType.download)
        XCTAssertEqual(upload, TaskType.upload(content))
    }
    
    func testTaskState() {
        let sessionTask = (sut as! HTTPDataTask).sessionTask
        let taskState = TaskState(sessionTask)
        XCTAssertEqual(taskState, .suspended)
        
        let running = TaskState.running
        XCTAssertEqual(running, TaskState.running)
        
        let suspended = TaskState.suspended
        XCTAssertEqual(suspended, TaskState.suspended)
        
        let canceling = TaskState.canceling
        XCTAssertEqual(canceling, TaskState.canceling)
        
        let completed = TaskState.completed
        XCTAssertEqual(completed, TaskState.completed)
    }
    
}
