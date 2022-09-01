//
//  ContentView.swift
//  MyMenu
//
//  Created by xueliuyang on 2022/8/10.
//

import SwiftUI




struct ContentView: View {
    
//    @State var models: [Model] = []
    @ObservedObject private var viewModel = ViewModel()
    @State var DefaultTime:String = "午餐"

    @State var showChooseTimeSheet: Bool = false
    


    // 推荐结果
    @State var DefaultImageURL:String = "https://img0.baidu.com/it/u=156558209,1663147989&fm=253&fmt=auto&app=138&f=JPEG?w=626&h=500"
    @State var DefaultName:String = "今天想吃点啥？"
    @State var showResult: Bool = false

    var body: some View {
        VStack (spacing: 30){
            TitleView(time: DefaultTime)
            Spacer()
            if !showResult {
                VStack{
                    CardView(imageURL: DefaultImageURL, name: DefaultName)
                    Text(DefaultName)
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .padding()
                }
            } else {
                LoadingView()
            }
//            CardView(imageURL: DefaultImageURL, name: DefaultName)
            Spacer()
            ChooseBtn()
        }
        .onAppear() {
            print(viewModel.currentTimeName,"name")
            DefaultTime = viewModel.currentTimeName
//            viewModel.getMealMessage(time: DefaultTime)
            
        }
        // 选择餐段
        .actionSheet(isPresented: $showChooseTimeSheet, content: { ChooseTimeSheet })
        
    }
    // 切换餐段
    private var ChooseTimeSheet: ActionSheet {
        let action = ActionSheet(
            title: Text("餐段"),message: Text("请选择餐段"),buttons:[
                .default(Text("早餐"), action: {
                    self.DefaultTime = "早餐"
//                    viewModel.getMenu()
                    viewModel.getMealMessage(time: "早餐")
                    DefaultImageURL = "https://img0.baidu.com/it/u=156558209,1663147989&fm=253&fmt=auto&app=138&f=JPEG?w=626&h=500"
                    DefaultName = "今天早餐想吃点啥？"
                }),
                .default(Text("午餐"), action: {
                    self.DefaultTime = "午餐"
//                    viewModel.getMenu()
                    viewModel.getMealMessage(time: "午餐")

                    DefaultImageURL = "https://img0.baidu.com/it/u=156558209,1663147989&fm=253&fmt=auto&app=138&f=JPEG?w=626&h=500"
                    DefaultName = "今天午餐想吃点啥？"
                }),
                .default(Text("下午茶"), action: {
                    self.DefaultTime = "下午茶"
//                    viewModel.getMenu()
                    viewModel.getMealMessage(time: "下午茶")
                    DefaultImageURL = "https://img0.baidu.com/it/u=156558209,1663147989&fm=253&fmt=auto&app=138&f=JPEG?w=626&h=500"
                    DefaultName = "今天下午茶想喝点啥？"
                }),
                .default(Text("晚餐"), action: {
                    self.DefaultTime = "晚餐"
//                    viewModel.getMenu()
                    viewModel.getMealMessage(time: "晚餐")

                    DefaultImageURL = "https://img0.baidu.com/it/u=156558209,1663147989&fm=253&fmt=auto&app=138&f=JPEG?w=626&h=500"
                    DefaultName = "今天晚餐想吃点啥？"
                }),
                .default(Text("宵夜"), action: {
                    self.DefaultTime = "宵夜"
//                    viewModel.getMenu()
                    viewModel.getMealMessage(time: "宵夜")

                    DefaultImageURL = "https://img0.baidu.com/it/u=156558209,1663147989&fm=253&fmt=auto&app=138&f=JPEG?w=626&h=500"
                    DefaultName = "今天宵夜想吃点啥？"
                }),
                .cancel(Text("取消"), action: {})
            ]
        )
        return action
    }

    // 推荐按钮
    func ChooseBtn() -> some View {
        Button(action: {
//            viewModel.getMealMessage(time: DefaultTime)
            viewModel.getRandomFood()
//            DefaultImageURL = viewModel.currentImageURL
//            DefaultName = viewModel.currentName
            //
            self.showResult = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.showResult = false
                DefaultImageURL = viewModel.currentImageURL
                DefaultName = viewModel.currentName
            }
            Haptics.hapticSuccess()
        }) {
            Text("一键推荐")
                .font(.system(size: 17))
                .fontWeight(.bold)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(viewModel.isRead ? .gray : Color.Hex(0x67C23A))
                .cornerRadius(5)
                .padding(.horizontal, 20)
                .padding(.bottom)
        }
        .disabled(viewModel.isRead)
    }
    
    // 标题视图
    func TitleView(time:String) -> some View {
        HStack {
        Text("当前餐段 : " + time)
                .font(.title2)
            .fontWeight(.bold)

            Spacer()

            Image(systemName: "rectangle.grid.1x2.fill")
                .foregroundColor(Color.Hex(0x67C23A))
                .onTapGesture {
                    self.showChooseTimeSheet.toggle()
                    Haptics.hapticWarning()
                 }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    // 推荐结果
    func CardView(imageURL: String, name: String) -> some View {
        VStack {
            AsyncImage(url: URL(string: imageURL))
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 120, maxWidth: .infinity, minHeight: 120, maxHeight: .infinity)
//                .frame(minWidth: 120, maxWidth: 420, minHeight: 120, maxHeight: 420)


        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.Hex(0x67C23A), lineWidth: 2))
        .padding([.top, .horizontal])
    }



}
struct Haptics {
    static func hapticSuccess() {
    let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func hapticWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
