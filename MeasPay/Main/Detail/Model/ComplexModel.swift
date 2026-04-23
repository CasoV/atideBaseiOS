//
//  ComplexModel.swift
//  ycxm
//
//  Created by 高小伟 on 2020/12/1.
//  Copyright © 2020 末末班车. All rights reserved.
//

import Foundation
import SwiftyJSON

class ComplexModel : NSObject{
    
    var costCode : String?
    var costName : String?
    var calBase : String?
    var reportCode : String?
    var seeNo : String?
    var showOn : Bool?
    var dataShow : Bool?
    var dataAllShow : Double?
    var contractAMT : Double?
    var show : Double?
    var designAMT : Double?
    var bargainAMT: Double?
    var changeAMT: Double?
    var abandonAMT: Double?
    var waterDestroyAMT: Double?
    var totalAMT: Double?
    var cCompAMT: Double?
    var pCompAMT: Double?
    var compAMT: Double?
    var compDesignAMT: Double?
    var compChangeAMT: Double?
    var compAbandonAMT: Double?
    var yearAMT: Double?
    var yPAMT: Double?
    
    var  listName : String?
    var  listCode : String?
    var  listUnit : String?
    
    var  contractPrice: Double?
    var  newlyPrice: Double?
    
    var  listNum: Double?
    var  listAmt: Double?
    var  tcompQuantity: Double?
    var  tcompAmt: Double?
    var  pcompQuantity: Double?
    var  pcompAmt: Double?
    var  compQuantity: Double?
    var  compAmt: Double?
    

    var  startNo: String?
    var  place: String?
    
    var sectName:String?
    var changeCode:String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        sectName = dictionary["sectName"].stringValue
        changeCode = dictionary["changeCode"].stringValue
        
        
        startNo = dictionary["startNo"].stringValue
        place = dictionary["place"].stringValue
        
        
        listNum = dictionary["listNum"].doubleValue
        listAmt = dictionary["listAmt"].doubleValue
        tcompQuantity = dictionary["tcompQuantity"].doubleValue
        tcompAmt = dictionary["tcompAmt"].doubleValue
        pcompQuantity = dictionary["pcompQuantity"].doubleValue
        pcompAmt = dictionary["pcompAmt"].doubleValue
        compQuantity = dictionary["compQuantity"].doubleValue
        compAmt = dictionary["compAmt"].doubleValue
        
        
        contractPrice = dictionary["contractPrice"].doubleValue
        newlyPrice = dictionary["newlyPrice"].doubleValue
        listName = dictionary["listName"] .stringValue
        listCode = dictionary["listCode"] .stringValue
        listUnit = dictionary["listUnit"] .stringValue
        
        
        costCode = dictionary["costCode"] .stringValue
        costName = dictionary["costName"] .stringValue
        calBase = dictionary["calBase"] .stringValue
        reportCode = dictionary["reportCode"] .stringValue
        seeNo = dictionary["seeNo"] .stringValue
        
        showOn = dictionary["showOn"].boolValue
        dataShow = dictionary["dataShow"].boolValue
        
        dataAllShow = dictionary["dataAllShow"].doubleValue
        contractAMT = dictionary["contractAMT"].doubleValue
        show = dictionary["show"].doubleValue
        designAMT = dictionary["designAMT"].doubleValue
        bargainAMT = dictionary["bargainAMT"].doubleValue
        changeAMT = dictionary["changeAMT"].doubleValue
        abandonAMT = dictionary["abandonAMT"].doubleValue
        waterDestroyAMT = dictionary["waterDestroyAMT"].doubleValue
        totalAMT = dictionary["totalAMT"].doubleValue
        cCompAMT = dictionary["cCompAMT"].doubleValue
        pCompAMT = dictionary["pCompAMT"].doubleValue
        compAMT = dictionary["compAMT"].doubleValue
        compDesignAMT = dictionary["compDesignAMT"].doubleValue
        compChangeAMT = dictionary["compChangeAMT"].doubleValue
        compAbandonAMT = dictionary["compAbandonAMT"].doubleValue
        yearAMT = dictionary["yearAMT"].doubleValue
        yPAMT = dictionary["yPAMT"].doubleValue
        

    }
    
    
    
}
