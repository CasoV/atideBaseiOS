//
//  ListAllMobile3.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/21.
//  Copyright © 2019 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListAllMobile3 : NSObject{
    
    var eight : String?
    var eighteen : String?
    var eleven : String?
    var fifteen : String?
    var five : String?
    var four : String?
    var fourteen : String?
    var month : String?
    var name : String?
    var nine : String?
    var nineteen : String?
    var one : String?
    var seven : String?
    var seventeen : String?
    var six : String?
    var sixteen : String?
    var supervisorId : String?
    var ten : String?
    var thirteen : String?
    var thirty : String?
    var thirtyOne : String?
    var three : String?
    var total : String?
    var twelve : String?
    var twenty : String?
    var twentyEight : String?
    var twentyFive : String?
    var twentyFour : String?
    var twentyNine : String?
    var twentyOne : String?
    var twentySeven : String?
    var twentySix : String?
    var twentyThree : String?
    var twentyTwo : String?
    var two : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        eight = dictionary["eight"] .stringValue
        eighteen = dictionary["eighteen"] .stringValue
        eleven = dictionary["eleven"] .stringValue
        fifteen = dictionary["fifteen"] .stringValue
        five = dictionary["five"] .stringValue
        four = dictionary["four"] .stringValue
        fourteen = dictionary["fourteen"] .stringValue
        month = dictionary["month"] .stringValue
        name = dictionary["name"] .stringValue
        nine = dictionary["nine"] .stringValue
        nineteen = dictionary["nineteen"] .stringValue
        one = dictionary["one"] .stringValue
        seven = dictionary["seven"] .stringValue
        seventeen = dictionary["seventeen"] .stringValue
        six = dictionary["six"] .stringValue
        sixteen = dictionary["sixteen"] .stringValue
        supervisorId = dictionary["supervisorId"] .stringValue
        ten = dictionary["ten"] .stringValue
        thirteen = dictionary["thirteen"] .stringValue
        thirty = dictionary["thirty"] .stringValue
        thirtyOne = dictionary["thirtyOne"] .stringValue
        three = dictionary["three"] .stringValue
        total = dictionary["total"] .stringValue
        twelve = dictionary["twelve"] .stringValue
        twenty = dictionary["twenty"] .stringValue
        twentyEight = dictionary["twentyEight"] .stringValue
        twentyFive = dictionary["twentyFive"] .stringValue
        twentyFour = dictionary["twentyFour"] .stringValue
        twentyNine = dictionary["twentyNine"] .stringValue
        twentyOne = dictionary["twentyOne"] .stringValue
        twentySeven = dictionary["twentySeven"] .stringValue
        twentySix = dictionary["twentySix"] .stringValue
        twentyThree = dictionary["twentyThree"] .stringValue
        twentyTwo = dictionary["twentyTwo"] .stringValue
        two = dictionary["two"] .stringValue
    }
    
}
