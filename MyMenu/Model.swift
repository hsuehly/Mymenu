//
//  Model.swift
//  MyMenu
//
//  Created by xueliuyang on 2022/8/10.
//
import SwiftUI

struct Model: Decodable {
    var foodTime: String
    var foodName: String
    var foodImageURL: String
}
struct FoodMenu: Decodable {
    var code: Int
    var msg: String
    var data:String
}
