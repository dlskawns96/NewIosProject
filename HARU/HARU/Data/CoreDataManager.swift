//
//  CoreDataManager.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/17.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {
        
    }
    
    static var diaryList = [Diary]()
    
    func fetchDiary() {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do {
            CoreDataManager.diaryList = try mainContext.fetch(request)
        } catch  {
            print(error)
        }
        
    }
    
    func saveDiary(_ content: String?, _ date: String?) {
        let newDiary = Diary(context: mainContext)
        newDiary.content = content
        newDiary.date = date
        
        CoreDataManager.diaryList.insert(newDiary, at: 0)
        saveContext()
    }
    
    func updateDiary(_ content: String?, _ date: String?) {
        
        for item in CoreDataManager.diaryList
        {
            if item.date == date
            {
                item.content = content
                
            }
        }
        
        saveContext()
    }
    
    static func returnDiary(date:String) -> String {
        
        var list:String = ""
        
        for item in CoreDataManager.diaryList
        {
            if item.date == date
            {
                list = item.content!
                
            }
        }
        return list
    }
    
    static func returnDiary(date:String, type:String) -> Bool {
        
        var result:Bool = false
        
        for item in CoreDataManager.diaryList
        {
            if item.date == date
            {
                result = true
            }
        }
        
        return result
        
    }
    
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}
