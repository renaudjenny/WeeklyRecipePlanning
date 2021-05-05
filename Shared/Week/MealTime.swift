import Foundation

enum MealTime: Equatable, CaseIterable, Identifiable {
    case sundayDiner
    case mondayLunch
    case mondayDiner
    case tuesdayLunch
    case tuesdayDiner
    case wednesdayLunch
    case wednesdayDiner
    case thursdayLunch
    case thursdayDiner
    case fridayLunch
    case fridayDiner
    case saturdayLunch
    case saturdayDiner
    case sundayLunch

    var name: String {
        switch self {
        case .sundayDiner: return NSLocalizedString("Sunday Diner", comment: "Meal Time: Sunday Diner")
        case .mondayLunch: return NSLocalizedString("Monday Lunch", comment: "Meal Time: Monday Lunch")
        case .mondayDiner: return NSLocalizedString("Monday Diner", comment: "Meal Time: Monday Diner")

        case .tuesdayLunch: return NSLocalizedString("Tuesday Lunch", comment: "Meal Time: Tuesday Lunch")
        case .tuesdayDiner: return NSLocalizedString("Tuesday Diner", comment: "Meal Time: Tuesday Diner")

        case .wednesdayLunch: return NSLocalizedString("Wednesday Lunch", comment: "Meal Time: Wednesday Lunch")
        case .wednesdayDiner: return NSLocalizedString("Wednesday Diner", comment: "Meal Time: Wednesday Diner")

        case .thursdayLunch: return NSLocalizedString("Thursday Lunch", comment: "Meal Time: Thursday Lunch")
        case .thursdayDiner: return NSLocalizedString("Thursday Diner", comment: "Meal Time: Thursday Diner")

        case .fridayLunch: return NSLocalizedString("Friday Lunch", comment: "Meal Time: Friday Lunch")
        case .fridayDiner: return NSLocalizedString("Friday Diner", comment: "Meal Time: Friday Diner")

        case .saturdayLunch: return NSLocalizedString("Saturday Lunch", comment: "Meal Time: Saturday Lunch")
        case .saturdayDiner: return NSLocalizedString("Saturday Diner", comment: "Meal Time: Saturday Diner")

        case .sundayLunch: return NSLocalizedString("Sunday Lunch", comment: "Meal Time: Sunday Lunch")
        }
    }

    var id: MealTime { self }
}

