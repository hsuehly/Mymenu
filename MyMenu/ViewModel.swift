//
//  ViewModel.swift
//  MyMenu
//
//  Created by xueliuyang on 2022/8/10.
//

import SwiftUI

class ViewModel: ObservableObject {
    // 当前餐段
    @Published var currentTimeName: String = ""
    @Published var currentImageURL: String = ""
    @Published var currentName: String = ""
    @Published var currentModels: [Model] = []
    @Published var isRead: Bool = true
    
    
    private var models: [Model] = []
    let DataURL = "https://api.npoint.io/4e97acfc3e5f73300779"
//    let DataURL = "https://itgowo.com/order.json"
    // http://localhost:8080/api/v1/menu/1
    let DataURL2 = "http://10.1.101.29:8080/api/v1/menu/1"
    


    init() {
        updateTime()
        getMenu()
//        print(models.count,"count")
    }

    // 餐段枚举
    enum MealTimeName: String {
        case breakfast = "早餐"
        case lunch = "午餐"
        case afternoonTea = "下午茶"
        case supper = "晚餐"
        case nightSnack = "宵夜"
    }

    // 获取当前系统时间
    func getCurrentTime() -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH"
        return Int(dateformatter.string(from: Date()))!
    }

    // 更新当前餐段
    func updateTime() {
        if getCurrentTime() < 10 {
            currentTimeName = MealTimeName.breakfast.rawValue
        } else if getCurrentTime() >= 10 && getCurrentTime() < 14 {
            currentTimeName = MealTimeName.lunch.rawValue
        } else if getCurrentTime() >= 14 && getCurrentTime() < 16 {
            currentTimeName = MealTimeName.afternoonTea.rawValue
        } else if getCurrentTime() >= 16 && getCurrentTime() < 20 {
            currentTimeName = MealTimeName.supper.rawValue
        } else {
            currentTimeName = MealTimeName.nightSnack.rawValue
        }
    }
    // 网络请求
    func getMenu() {
        //        self.isRead = true
        print("开始请求")
        let url = URL(string: DataURL2)
        let request = URLRequest(url: url!)
    
        
//        request.timeoutInterval = 15
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("请求出错\(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("请求错误")
                return
            }
            guard let data = data else {
                print("数据出错")
                return
            }
            
            do {
//                let meals = try JSONDecoder().decode([Model].self, from: data)
                let meals = try JSONDecoder().decode(FoodMenu.self, from: data)
                let str = meals.data.data(using: .utf8)
                let foodMenu = try JSONDecoder().decode([Model].self, from: str!)
                

                DispatchQueue.main.async {
                    self.models = foodMenu
                    self.currentModels = foodMenu.filter{ $0.foodTime.lowercased().contains(self.currentTimeName)}
                    print(self.currentModels.count,"currentModels")
                    self.isRead = false
                    print("请求成功")
                }
            } catch {
                print(error)
            }
        }
        session.resume()
        
        
    }
//        let session = URLSession(configuration: .default)
//        session.dataTask(with: URL(string: DataURL)!) { data, _, _ in
    
    // 根据餐段获得餐品信息
    func getMealMessage(time:String) {
        let query = time.lowercased()
        print(query,"query")
        self.currentModels = models.filter { $0.foodTime.lowercased().contains(query) }
//        self.models = filter
//        let filter = self.models.filter{ $0.foodTime.lowercased().contains(query) }
//        DispatchQueue.main.async {
//            withAnimation(.spring()) {
//                    self.currentModels = filter
//                }
//
//        }
//        self.currentModels =
//        DispatchQueue.global(qos: .background).async {
//            let filter = self.models.filter { $0.foodTime.lowercased().contains(query) }
//            print(filter.count,"filter")
//            DispatchQueue.main.async {
//                withAnimation(.spring()) {
//                    self.currentModels = filter
//                }
//            }
//        }
    }
    //随机推荐菜品
    func getRandomFood() {
        let index = Int(arc4random() % UInt32(currentModels.count))
        print(index,"index")
        currentName = currentModels[index].foodName
        currentImageURL = currentModels[index].foodImageURL
    }



}
