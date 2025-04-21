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

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("저장 실패: \(nserror), \(nserror.userInfo)")
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

}
