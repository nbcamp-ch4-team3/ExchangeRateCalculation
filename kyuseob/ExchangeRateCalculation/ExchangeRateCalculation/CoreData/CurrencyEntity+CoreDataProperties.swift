import Foundation
import CoreData


extension CurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
    }

    @NSManaged public var code: String?
    @NSManaged public var country: String?
    @NSManaged public var rate: Double

}

extension CurrencyEntity : Identifiable {
    var codeValue: String {
        return code ?? ""
    }

    var countryValue: String {
        return country ?? ""
    }

    var rateValue: Double {
        return rate
    }
}
