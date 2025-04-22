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

    func addCurrency(code: String, country: String, rate: Double, trend: String, updatedDate: Date) {
        // background context 생성
        let context = persistentContainer.newBackgroundContext()

        context.perform {
            // nil 체크
            guard !code.isEmpty, !country.isEmpty, !trend.isEmpty else {
                print("Core Data Error: 필수 값이 비어 있습니다")
                return
            }

            let fetchRequest: NSFetchRequest<CurrencyEntity> = CurrencyEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "code == %@", code)

            do {
                let matches = try context.fetch(fetchRequest)
                if let existingCurrency = matches.first {
                    existingCurrency.code = code
                    existingCurrency.country = country
                    existingCurrency.rate = rate
                    existingCurrency.trend = trend
                    existingCurrency.updatedDate = updatedDate
                } else {
                    let newCurrency = CurrencyEntity(context: context)
                    newCurrency.code = code
                    newCurrency.country = country
                    newCurrency.rate = rate
                    newCurrency.trend = trend
                    newCurrency.updatedDate = updatedDate
                }

                try context.save()
            } catch {
                print("CoreData addCurrency 실패: \(error.localizedDescription)")
            }
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

// MARK: - Last State feature
extension CoreDataStack {
    func saveLastPage(identifier: String, params: [String: Any]?) {
        deleteAllPages()

        let lastPageEntity = LastPageEntity(context: viewContext)
        lastPageEntity.identifier = identifier
        lastPageEntity.timestamp = Date()
        if let params {
            lastPageEntity.paramsData = try? NSKeyedArchiver.archivedData(
                withRootObject: params,
                requiringSecureCoding: false
            )
        }

        try? viewContext.save()
    }

    func fetchLastPage() -> LastPageEntity? {
        let fetchRequest: NSFetchRequest<LastPageEntity> = LastPageEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        return try? viewContext.fetch(fetchRequest).first
    }

    private func deleteAllPages() {
        let fetchRequest: NSFetchRequest<LastPageEntity> = LastPageEntity.fetchRequest()

        if let entities = try? viewContext.fetch(fetchRequest) {
            for entity in entities {
                viewContext.delete(entity)
            }
            try? viewContext.save()
        }
    }
}

extension LastPageEntity {
    func getParams() -> [String: Any]? {
        guard let paramsData = self.paramsData else {
            return nil
        }

        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(paramsData) as? [String: Any]
    }
}
