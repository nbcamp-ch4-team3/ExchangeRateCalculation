import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExchangeRateCalculation")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data CRUD Method

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("CoreData 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Favorite CurrencyCode Method
    func fetchAllFavoriteCurrencies() throws -> [FavoriteCurrency] {
        let request = FavoriteCurrency.fetchRequest()

        do {
            let favorites = try viewContext.fetch(request)
            return favorites
        } catch {
            throw CoreDataError.fetchFavoritesFailed(error: error)
        }
    }

    func addFavorite(with currencyCode: String) throws {
        let newFavoriteCurrency = FavoriteCurrency(context: viewContext)
        newFavoriteCurrency.currencyCode = currencyCode

        do {
            try viewContext.save()
        } catch {
            throw CoreDataError.addFavoriteFailed(error: error)
        }
    }

    func removeFavorite(with currencyCode: String) throws {
        let request = FavoriteCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)

        do {
            let matches = try viewContext.fetch(request)
            for match in matches {
                viewContext.delete(match)
            }
            try viewContext.save()
        } catch {
            throw CoreDataError.deleteFavoriteFailed(error: error)
        }
    }

    func fetchAllCurrencies() throws -> [CurrencyEntity] {
        let request = CurrencyEntity.fetchRequest()

        do {
            let currencies = try viewContext.fetch(request)
            return currencies
        } catch {
            throw CoreDataError.fetchCurrenciesFailed(error: error)
        }
    }

    func addCurrency(code: String, country: String, rate: Double, trend: String, updatedDate: Date) throws {
        do {
            let newCurrency = CurrencyEntity(context: viewContext)
            newCurrency.code = code
            newCurrency.country = country
            newCurrency.rate = rate
            newCurrency.trend = trend
            newCurrency.updatedDate = updatedDate

            try viewContext.save()
        } catch {
            throw CoreDataError.addFavoriteFailed(error: error)
        }
    }

    func deleteAllCurrencies() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CurrencyEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: viewContext)
            try viewContext.save()
        } catch {
            throw CoreDataError.deleteFavoriteFailed(error: error)
        }
    }

}
