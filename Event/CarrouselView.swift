
// Created by antoine on 12/12/2022.
//

import SwiftUI

struct Day: View {
    var body: some View {
        List {
            
        }
        VStack {
            ForEach(0 ..< 24) { index in
                Text("\(index):00").frame(maxWidth: .infinity, minHeight: 100)
            }
        }
    }
}

class CarouselState: ObservableObject {
    let count: Int
    @Published private(set) var selected: Int;
    
    init(count: Int, selected: Int = 0) {
        assert(count >= 0 && selected >= 0 && selected < count)
        self.count = count;
        self.selected = selected;
    }

    
    func has_next() -> Bool {
        selected < count-1
    }
    
    func has_prev() -> Bool {
        selected > 0
    }
    
    func next() {
        if has_next() {
            selected += 1;
        }
    }
    
    func prev() {
        if has_prev() {
            selected -= 1;
        }
    }
}

struct Carousel<Content: View>: View {
    @GestureState private var isDetectingLongPress = false
    @State private var dragOff: CGFloat? = nil
    @ObservedObject var state: CarouselState
    @ViewBuilder var content: (Int) -> Content

    var body: some View {
        GeometryReader {
            geometry in
            ScrollView {
                HStack(alignment: .center, spacing: .zero) {
                    ForEach(0..<state.count, id: \.self) { i in
                        VStack {
                            content(i)
                        }.frame(width: geometry.size.width)
                    }
                }
            }
            .offset(x: (-CGFloat(state.selected) * (geometry.size.width)) + (dragOff ?? 0))
            .animation(.easeInOut(duration: 0.3), value: dragOff == nil)
            .animation(.easeInOut(duration: 0.3), value: state.selected)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOff = value.translation.width
                    }
                    .onEnded { value in
                        let threeshold = geometry.size.width / 6
                        if value.translation.width < -threeshold {
                            state.next()
                        } else if value.translation.width > threeshold {
                            state.prev()
                        }
                        dragOff = nil
                    }
            )
        }
    }
}

let color = [Color.red, Color.blue,  Color.yellow];

struct CarouselExample: View {
    @StateObject private var state = CarouselState(count: color.count)
    var body: some View {
        VStack(alignment: .center)  {
            HStack {
                Button(action: {state.prev()}) {
                    Text("prev")
                }.disabled(!state.has_prev())
                Text("Jour \(state.selected)")
                Button(action: {state.next()}) {
                    Text("next")
                }.disabled(!state.has_next())
            }
            Carousel(state: state, content: {(i) in Day().background(color[i]) })
        }
    }
}


struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselExample()
    }
}
