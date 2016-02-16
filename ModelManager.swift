//
//  ModelManager.swift
//  DigitalLearningTree
//
//  Created by mrinal khullar on 1/18/16.
//  Copyright © 2016 mrinal khullar. All rights reserved.
//

import UIKit
let sharedInstance = ModelManager()
class ModelManager: NSObject
{
     var database: FMDatabase? = nil
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: GetFilePath.getPath("DigitalLearnngtree.sqlite"))
        }
        return sharedInstance
    }
    
    //MARK:- LessonTable
    
    func addStudentData(lessonTable: LessonsTable) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Lesson_Table (Class_ID, Lesson_ID,Position) VALUES (?, ?, ?)", withArgumentsInArray: [lessonTable.Class_ID,lessonTable.Lesson_ID,lessonTable.Position])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateStudentData(lessonTable: LessonsTable) -> Bool
    {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Lesson_Table SET Class_ID=?, Position=? WHERE Lesson_ID=?", withArgumentsInArray: [lessonTable.Class_ID,lessonTable.Position,lessonTable.Lesson_ID])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteStudentData(lessonid:NSString) -> Bool
    {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Lesson_Table WHERE Lesson_ID=?", withArgumentsInArray: [lessonid])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    
    func getTableData(tblName: String, selectColumns: NSArray, whereString: String, whereFields: NSArray )->FMResultSet {
        
        sharedInstance.database!.open()
        
        var fieldValues = [String]()
        
        
        var finalWhereString = "1"
        
        
        if(whereString != "")
        {
            finalWhereString = whereString
            
            for j in 0..<whereFields.count
            {
                fieldValues.append("\(whereFields[j])")
            }
        }
        
        var finalSelectColumnString = "*"
        
        if(selectColumns.count>0)
        {
            finalSelectColumnString = selectColumns.componentsJoinedByString(", ")
        }
        
        //println("SELECT \(finalSelectColumnString) FROM \(tblName) WHERE \(finalWhereString)")
        
        //println(fieldValues)
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT \(finalSelectColumnString) FROM \(tblName) WHERE \(finalWhereString)", withArgumentsInArray: fieldValues as [AnyObject])
        
        return resultSet
    }
    
    func deleteAllLessonBaseOnClassData(classID:NSString) -> Bool
    {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Lesson_Table WHERE Class_ID=?", withArgumentsInArray: [classID])
        sharedInstance.database!.close()
        return isDeleted
    }




    //MARK:- ResourceTable
    
    func addResourceData(resourceTable: ResourceTable) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO ResourceTable (Class_ID, Resource_ID,Position) VALUES (?, ?, ?)", withArgumentsInArray: [resourceTable.Class_ID,resourceTable.Resource_ID,resourceTable.Position])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateResourceData(resourceTable: ResourceTable) -> Bool
    {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE ResourceTable SET Class_ID=?, Position=? WHERE Resource_ID=?", withArgumentsInArray: [resourceTable.Class_ID,resourceTable.Position,resourceTable.Resource_ID])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteResourceData(resourceid:NSString) -> Bool
    {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM ResourceTable WHERE Resource_ID=?", withArgumentsInArray: [resourceid])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    
      func getResourceTableData(tblName: String, selectColumns: NSArray, whereString: String, whereFields: NSArray )->FMResultSet {
        
        sharedInstance.database!.open()
        
        var fieldValues = [String]()
        
        
        var finalWhereString = "1"
        
        
        if(whereString != "")
        {
            finalWhereString = whereString
            
            for j in 0..<whereFields.count
            {
                fieldValues.append("\(whereFields[j])")
            }
        }
        
        var finalSelectColumnString = "*"
        
        if(selectColumns.count>0)
        {
            finalSelectColumnString = selectColumns.componentsJoinedByString(", ")
        }
        
        //println("SELECT \(finalSelectColumnString) FROM \(tblName) WHERE \(finalWhereString)")
        
        //println(fieldValues)
        
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT \(finalSelectColumnString) FROM \(tblName) WHERE \(finalWhereString)", withArgumentsInArray: fieldValues as [AnyObject])
        
        return resultSet
    }
    

    //MARK:- ClassTable
    
    func addClassData(classTable: ClassTable) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Class_Table (Class_ID, Mem_ID,Position) VALUES (?, ?, ?)", withArgumentsInArray: [classTable.Class_ID,classTable.Mem_ID,classTable.Position])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateClassData(classTable: ClassTable) -> Bool
    {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Class_Table SET Mem_ID=?, Position=? WHERE Class_ID=?", withArgumentsInArray: [classTable.Mem_ID,classTable.Position,classTable.Class_ID])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteClassData(ClassID:NSString) -> Bool
    {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Class_Table WHERE Class_ID=?", withArgumentsInArray: [ClassID])
        sharedInstance.database!.close()
        return isDeleted
    }

}
