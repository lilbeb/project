//
//  TodoItem.swift
//  ToDoList
//
//

import Foundation

enum Importance: String {
    case notImportant = "неважная"
    case usual = "обычная"
    case important = "важная"
}
struct TodoItem {
   
    let taskId: String
    let text: String
    let importance: Importance
    var deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    
    init(taskId: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isDone: Bool = false, creationDate: Date = Date(), modificationDate: Date? = nil) {
        self.taskId = taskId
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

}


extension TodoItem {
    
    static func parse(json: Any) -> TodoItem? {
        do {
            guard let dict = json as? [String: Any ] else { return nil }
            
            guard
                  let taskId = dict["taskId"] as? String,
                  let text = dict["text"] as? String,
                  let creationDate = (dict["creationDate"] as? Int).flatMap ({ Date(timeIntervalSince1970: TimeInterval($0)) }) else {
                return nil
            }
            let importance = (dict["importance"] as? String).flatMap(Importance.init(rawValue:)) ?? .usual
            let deadline = (dict["deadline"] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
            let isDone = (dict["isDone"] as? Bool) ?? false
            let modificationDate = (dict["modificationDate"] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
            
            return TodoItem(
                taskId: taskId,
                text: text,
                importance: importance,
                deadline: deadline,
                isDone: isDone,
                creationDate: creationDate,
                modificationDate: modificationDate
            )
        }
    }
    var json: Any {
           var res: [String: Any] = [:]
           res["taskId"] = taskId
           res["text"] = text
           if importance != .usual {
               res["importance"] = importance.rawValue
           }
           if let deadline = deadline {
               res["deadline"] = Int(deadline.timeIntervalSince1970)
           }
           res["isDone"] = isDone
           res["creationDate"] = Int(creationDate.timeIntervalSince1970)
           if let modificationDate = modificationDate {
               res["modificationDate"] = Int(modificationDate.timeIntervalSince1970)
           }
           return res
       }
}

class FileCache {
    
    private(set) var todoItems : [TodoItem] = []
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func addTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.taskId == item.taskId }) {
            todoItems[index] = item
        } else {
            todoItems.append(item)
        }
    }
    
    func removeTodoItem(id: String) {
        if let index = todoItems.firstIndex(where: { $0.taskId == id }) {
            todoItems.remove(at: index)
        }
    }
    public func save(to file: String) {
        do {
            let json = todoItems.map {$0.json}
            let data = try JSONSerialization.data(withJSONObject: json)
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(url)
            let fileURL = url.appendingPathComponent("\(file).json")
            try data.write(to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    public func load(to file: String) {
        do {
            if let data = try? Data(contentsOf: getUrl(file: file, fileExtension: "json")){
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                    print(json)
                    var toDoItems2: [TodoItem] = []
                                    for i in json {
                                        if let item = TodoItem.parse(json: i) {
                                            toDoItems2.append(item)
                                            
                                        }
                                        
                                    }
                    todoItems = toDoItems2
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func getUrl(file: String, fileExtension: String) -> URL {
            var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            path = path.appendingPathComponent("\(file).\(fileExtension)")
            return path
        }
}
