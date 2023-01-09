import SwiftUI

class CarouselState: ObservableObject {
    @Published var count: Int
    @Published var selected: Int;

    init(count: Int, selected: Int = 0) {
        self.count = count;
        self.selected = selected;
    }

    func has_next() -> Bool {
        selected < count - 1
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
                        }
                                .frame(width: geometry.size.width)
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
                                        let threshold = geometry.size.width / 6
                                        if value.translation.width < -threshold {
                                            state.next()
                                        } else if value.translation.width > threshold {
                                            state.prev()
                                        }
                                        dragOff = nil
                                    }
                    )
        }
    }
}

let color = [Color.red, Color.blue, Color.yellow];
