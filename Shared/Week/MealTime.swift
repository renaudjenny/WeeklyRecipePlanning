import Foundation

enum MealTime: Equatable, CaseIterable, Identifiable {
    case sundayDinner
    case mondayLunch
    case mondayDinner
    case tuesdayLunch
    case tuesdayDinner
    case wednesdayLunch
    case wednesdayDinner
    case thursdayLunch
    case thursdayDinner
    case fridayLunch
    case fridayDinner
    case saturdayLunch
    case saturdayDinner
    case sundayLunch

    var name: String {
        switch self {
        case .sundayDinner: return NSLocalizedString("Sunday Dinner", comment: "Meal Time: Sunday Dinner")
        case .mondayLunch: return NSLocalizedString("Monday Lunch", comment: "Meal Time: Monday Lunch")
        case .mondayDinner: return NSLocalizedString("Monday Dinner", comment: "Meal Time: Monday Dinner")

        case .tuesdayLunch: return NSLocalizedString("Tuesday Lunch", comment: "Meal Time: Tuesday Lunch")
        case .tuesdayDinner: return NSLocalizedString("Tuesday Dinner", comment: "Meal Time: Tuesday Dinner")

        case .wednesdayLunch: return NSLocalizedString("Wednesday Lunch", comment: "Meal Time: Wednesday Lunch")
        case .wednesdayDinner: return NSLocalizedString("Wednesday Dinner", comment: "Meal Time: Wednesday Dinner")

        case .thursdayLunch: return NSLocalizedString("Thursday Lunch", comment: "Meal Time: Thursday Lunch")
        case .thursdayDinner: return NSLocalizedString("Thursday Dinner", comment: "Meal Time: Thursday Dinner")

        case .fridayLunch: return NSLocalizedString("Friday Lunch", comment: "Meal Time: Friday Lunch")
        case .fridayDinner: return NSLocalizedString("Friday Dinner", comment: "Meal Time: Friday Dinner")

        case .saturdayLunch: return NSLocalizedString("Saturday Lunch", comment: "Meal Time: Saturday Lunch")
        case .saturdayDinner: return NSLocalizedString("Saturday Dinner", comment: "Meal Time: Saturday Dinner")

        case .sundayLunch: return NSLocalizedString("Sunday Lunch", comment: "Meal Time: Sunday Lunch")
        }
    }

    var next: MealTime {
        // TODO: test that!
        if self == .sundayLunch {
            return .sundayDinner
        }
        guard let selfIndex = MealTime.allCases.firstIndex(of: self) else {
            return .sundayDinner
        }
        return MealTime.allCases[selfIndex + 1]
    }

    var id: MealTime { self }
}

