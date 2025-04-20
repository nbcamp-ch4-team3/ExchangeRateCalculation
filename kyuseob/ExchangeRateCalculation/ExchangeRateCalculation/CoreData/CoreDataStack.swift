import CoreData

class CoreDataStack {
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

    func addFavorite(with currencyCode: String) {
        let newFavoriteCurrency = FavoriteCurrency(context: viewContext)

        newFavoriteCurrency.currencyCode = currencyCode

        saveContext()
    }

    func fetchAllFavoriteCurrencies() -> [FavoriteCurrency] {
        let request = FavoriteCurrency.fetchRequest()

        guard let favorites = try? viewContext.fetch(request) else { return [] }
        print(favorites)

        return favorites
    }

}
