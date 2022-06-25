//
//  LoginUser.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 03/01/2022.
//

import Foundation
import CoreData

class LoginUser{
    static private var currentUser: User?
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static func getLoginUser() -> User?{
        return currentUser
    }
    
    static func login(email: String){
        let persistentContainer = PersistenceController.preview.container
        let fetchRequest: NSFetchRequest<User>
        fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "email LIKE %@", email
        )
        let context = persistentContainer.viewContext
        let objects = try? context.fetch(fetchRequest)
        if let user = objects?.first {
            self.currentUser = user
        }
    }
    
    static func getCart() -> Cart?{
        if(currentUser != nil){
            return currentUser?.cart
        }
        return nil
    }
}
