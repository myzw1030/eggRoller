import SwiftUI

struct ContentView: View {
    // 卵の初期位置
    @State private var eggPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
    // 直前の卵の位置を保持する
    @State private var lastLocation: CGPoint = .zero // 追加：直前の位置
    @State private var velocity: CGPoint = .zero // 追加：スワイプの速度
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                // 卵を表示する
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 80, height: 90)
                    .position(eggPosition)
                    // ドラッグで卵の位置更新
                    .gesture(
                        DragGesture().onChanged({ value in
                            // ドラッグ中の位置に卵を移動(直前の位置からドラッグの差分)
                            let translation = CGPoint(x: value.translation.width, y: value.translation.height)
                            let newPosition = CGPoint(x: eggPosition.x + translation.x, y: eggPosition.y + translation.y)
                            
                            // 画面の外に出さないように制限する
                            eggPosition.x = min(max(newPosition.x, 25), geometry.size.width - 25)
                            eggPosition.y = min(max(newPosition.y, 25), geometry.size.height - 100)
                            
                            // スワイプの速度を計算して保存
                            velocity = CGPoint(x: value.predictedEndLocation.x - value.location.x,y: value.predictedEndLocation.y - value.location.y)
                        }).onEnded({ value in
                            // ドラッグが終了したときの処理
//                            let maxVelocity: CGFloat = 1500
//                            let speed = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
//                            let scaleFactor = min(speed, maxVelocity) / speed
//                            velocity = CGPoint(x: velocity.x * scaleFactor, y: velocity.y * scaleFactor)
//                            eggPosition.x += velocity.x
//                            eggPosition.y += velocity.y
                    }))
                    .animation(.easeOut) // 追加：ドラッグ時のアニメーションを滑らかにする
                    .onChange(of: eggPosition, perform: { value in
                        // ドラッグの速度を制限する
                        let translation = CGPoint(x: eggPosition.x - lastLocation.x, y: eggPosition.y - lastLocation.y)
                        let maxVelocity: CGFloat = 1000
                        let distance = sqrt(translation.x * translation.x + translation.y * translation.y)
                        if distance > maxVelocity {
                            eggPosition.x = lastLocation.x + translation.x / distance * maxVelocity
                            eggPosition.y = lastLocation.y + translation.y / distance * maxVelocity
                        }
                        lastLocation = eggPosition // 直前の位置を更新
                    })
            }
        }
    }
}

extension CGPoint {
    func normalized() -> CGPoint {
        let length = sqrt(x * x + y * y)
        return CGPoint(x: x / length, y: y / length)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
