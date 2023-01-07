
// Created by antoine on 12/12/2022.
//

import SwiftUI

struct Day: View {
    let events: [EventItem]
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(8 ..< 21) { index in
                    Text("\(index):00").frame(height: 60, alignment: .bottomLeading).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                }
            }
            Divider().padding(0)
            ZStack(alignment: .topLeading) {
                VStack {
                    ForEach(8 ..< 21) { _ in
                        Spacer(minLength: 60)
                        Divider()
                    }
                }
                ForEach(events, id: \.self.start) { event in
                    let height = CGFloat(event.end - event.start);
                    let offset = CGFloat(event.start - 8 * 60);
                    /*@START_MENU_TOKEN@*/Text(event.name)/*@END_MENU_TOKEN@*/
                        .frame(height: height)
                        .frame(maxWidth: .infinity)
                        .background(event.color)
                        .cornerRadius(8)
                        .offset(y: offset)
                        .padding(2)
                }
            }
        }
        .frame(maxWidth: .infinity).padding(8)
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

struct EventItem {
    let start: UInt16
    let end: UInt16
    let name: String
    let color: Color
}

struct CarouselExample: View {
    @StateObject private var state = CarouselState(count: 3)
    
    let program = [
        [
            EventItem(start: 540, end: 570, name: "Breakfast", color: Color.red),
            EventItem(start: 570, end: 690, name: "Welcom Breakfast", color: Color.blue)
        ],
        [
        ],
        [
        ]
    ]
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
            Carousel(state: state, content: {(i) in Day(events: program[i]) })
        }
    }
}


struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselExample()
    }
}
