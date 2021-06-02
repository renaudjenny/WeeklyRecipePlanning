import XCTest

class TestsMealTime: XCTestCase {
    func testNext() throws {
        for mealTime in MealTime.allCases {
            switch mealTime {
            case .sundayDinner: XCTAssertEqual(mealTime.next, .mondayLunch)
            case .mondayLunch: XCTAssertEqual(mealTime.next, .mondayDinner)
            case .mondayDinner: XCTAssertEqual(mealTime.next, .tuesdayLunch)
            case .tuesdayLunch: XCTAssertEqual(mealTime.next, .tuesdayDinner)
            case .tuesdayDinner: XCTAssertEqual(mealTime.next, .wednesdayLunch)
            case .wednesdayLunch: XCTAssertEqual(mealTime.next, .wednesdayDinner)
            case .wednesdayDinner: XCTAssertEqual(mealTime.next, .thursdayLunch)
            case .thursdayLunch: XCTAssertEqual(mealTime.next, .thursdayDinner)
            case .thursdayDinner: XCTAssertEqual(mealTime.next, .fridayLunch)
            case .fridayLunch: XCTAssertEqual(mealTime.next, .fridayDinner)
            case .fridayDinner: XCTAssertEqual(mealTime.next, .saturdayLunch)
            case .saturdayLunch: XCTAssertEqual(mealTime.next, .saturdayDinner)
            case .saturdayDinner: XCTAssertEqual(mealTime.next, .sundayLunch)
            case .sundayLunch: XCTAssertEqual(mealTime.next, .sundayDinner)
            }
        }
    }
}
