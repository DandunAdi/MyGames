//
//  FavoriteGameModel.swift
//  MyGames
//
//  Created by DDD on 17/10/20.
//  Copyright © 2020 Dandun Adi. All rights reserved.
//

import Foundation
import CoreData

struct FavoriteGameModel {
    var id: Int?
}

class FavoriteGameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.CoreData.favoriteGamesName)
        
        container.loadPersistentStores { storeDesription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavoritedGames(completion: @escaping(_ members: [Int]) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.favoriteGameEntityName)
            do {
                let results = try taskContext.fetch(fetchRequest)
                var gamesId: [Int] = []
                for result in results {
                    let game = FavoriteGameModel(id: result.value(forKey: "id") as? Int)
                    
                    if let id = game.id {
                        gamesId.append(id)
                    }
                }
                completion(gamesId)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addNewFavoritedGames(_ id: Int, completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            if let entity = NSEntityDescription.entity(forEntityName: Constants.CoreData.favoriteGameEntityName, in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKeyPath: "id")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteFavoritedGame(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.favoriteGameEntityName)
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }

}
