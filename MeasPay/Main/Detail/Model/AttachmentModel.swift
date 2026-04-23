//
//  AttachmentModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/11.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class AttachmentModel : NSObject{
    
    var accessExpression : String?
    var accessSql : String?
    var code : String?
    var contentType : String?
    var createTime : String?
    var curVer : String?
    var download : String?
    var downloadCount : String?
    var extName : String?
    var fileType : String?
    var filename : String?
    var fromDate : String?
    var id : String?
    var includeSelf : String?
    var length : String?
    var md5 : String?
    var memo : String?
    var metaData:AttachmentMetadata?
    var orgId : String?
    var orgName : String?
    var originalId : String?
    var originalName : String?
    var recursion : String?
    var status : String?
    var storePath : String?
    var storeType : String?
    var superCode : String?
    var superId : String?
    var system : String?
    var toDate : String?
    var updateTime : String?
    var userId : String?
    var userName : String?
    var version : String?
    var view : String?
    var viewCount : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        accessExpression = dictionary["accessExpression"] .stringValue
        accessSql = dictionary["accessSql"] .stringValue
        code = dictionary["code"] .stringValue
        contentType = dictionary["contentType"] .stringValue
        createTime = dictionary["createTime"] .stringValue
        curVer = dictionary["curVer"] .stringValue
        download = dictionary["download"] .stringValue
        downloadCount = dictionary["downloadCount"] .stringValue
        extName = dictionary["extName"] .stringValue
        fileType = dictionary["fileType"] .stringValue
        filename = dictionary["filename"] .stringValue
        fromDate = dictionary["fromDate"] .stringValue
        id = dictionary["id"] .stringValue
        includeSelf = dictionary["includeSelf"] .stringValue
        length = dictionary["length"] .stringValue
        md5 = dictionary["md5"] .stringValue
        memo = dictionary["memo"] .stringValue
        metaData = AttachmentMetadata(dictionary:dictionary["metaData"])
        orgId = dictionary["orgId"] .stringValue
        orgName = dictionary["orgName"] .stringValue
        originalId = dictionary["originalId"] .stringValue
        originalName = dictionary["originalName"] .stringValue
        recursion = dictionary["recursion"] .stringValue
        status = dictionary["status"] .stringValue
        storePath = dictionary["storePath"] .stringValue
        storeType = dictionary["storeType"] .stringValue
        superCode = dictionary["superCode"] .stringValue
        superId = dictionary["superId"] .stringValue
        system = dictionary["system"] .stringValue
        toDate = dictionary["toDate"] .stringValue
        updateTime = dictionary["updateTime"] .stringValue
        userId = dictionary["userId"] .stringValue
        userName = dictionary["userName"] .stringValue
        version = dictionary["version"] .stringValue
        view = dictionary["view"] .stringValue
        viewCount = dictionary["viewCount"] .stringValue
    }
    
    
}

class AttachmentMetadata : NSObject{
    var formId : String?
    var fileName : String?
    var orderNum : String?
    var fileType : String?
    init(dictionary: JSON){
        formId = dictionary["formId"] .stringValue
        fileName = dictionary["fileName"] .stringValue
        orderNum = dictionary["orderNum"] .stringValue
        fileType = dictionary["fileType"] .stringValue
    }
}
