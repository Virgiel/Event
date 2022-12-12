
// Created by antoine on 12/12/2022.
//

import SwiftUI

struct Day: View {
    var body: some View {
        VStack {
            ForEach(0 ..< 24) { index in
                Text("\(index):00").frame(maxWidth: .infinity, minHeight: 100)
            }
        }
    }
}

struct Carousel: View {
    @GestureState private var isDetectingLongPress = false
    @State private var dragOff: CGFloat? = nil
    @Binding var selected: Int
    private let count: Int = 3

    var body: some View {
        GeometryReader {
            geometry in
            ScrollView {
                HStack(alignment: .center, spacing: .zero) {
                    ForEach([Color.red, Color.blue,  Color.yellow], id: \.self) { item in
                        Day().frame(width: geometry.size.width)
                                .background(item)
                    }
                }
            }
                    .offset(x: (-CGFloat(selected) * (geometry.size.width)) + (dragOff ?? 0))
                    .animation(.easeInOut(duration: 0.3), value: dragOff == nil)
                    .animation(.easeInOut(duration: 0.3), value: selected)
                    .gesture(
                            DragGesture()
                                    .onChanged { value in
                                        dragOff = value.translation.width
                                    }
                                    .onEnded { value in
                                        let threeshold = geometry.size.width / 6
                                        if value.translation.width < -threeshold && selected < count {
                                            selected += 1
                                        } else if value.translation.width > threeshold && selected > 0 {
                                            selected -= 1
                                        }
                                        dragOff = nil
                                    }
                    )
        }
    }
}


struct CarouselExample: View {
    @State private var selected: Int = 0
    var body: some View {
        VStack(alignment: .center)  {
            Carousel(selected: $selected)
            HStack {
                Button(action: {selected -= 1}) {
                    Text("prev")
                }.disabled(selected == 0)
                Button(action: {selected += 1}) {
                    Text("next")
                }.disabled(selected == 2)
            }
        }
    }
}


struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselExample()
    }
}
