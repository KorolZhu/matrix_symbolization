import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(matrix_symbolizationTests.allTests),
    ]
}
#endif
