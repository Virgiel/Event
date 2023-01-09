import SwiftUI

final class DailySchedule: TimelineSchedule {
    typealias Entries = [Date]

    func entries(from startDate: Date, mode: Mode) -> Entries {
        (1...30).map { startDate.addingTimeInterval(Double($0 * 24 * 3600)) }
    }
}

extension TimelineSchedule where Self == DailySchedule {
    static var daily: Self { .init() }
}

struct PlanningView: View {
    var body: some View {
        TimelineView(.daily) { context in
            let value = dayValue(for: context.date)

            Circle()
                .trim(from: 0, to: value)
                .stroke()
        }
    }

    private func dayValue(for date: Date) -> Double {
        let day = Calendar.current.component(.day, from: date)
        return Double(day) / 30
    }
}

/*struct PlanningView: View {
    @State var offset: CGFloat = CGFloat.zero
    @State var lastOffset: CGFloat = CGFloat.zero

    var body: some View {
        ScrollView {
            HStack {
                ForEach(["A", "B", "C"], id: \.self) { item in
                    ScrollView {
                        VStack {
                            ForEach(0..<100) { index in
                                Text("Item \(item): \(index + 1)")
                            }
                        }
                        .frame(width: 200, alignment: .center)
                    }
                }
        } /*.offset(x:offset)
            .gesture(
                DragGesture()
                    .onChanged({ val in
                        self.offset = lastOffset + val.translation.width
                    })
                    .onEnded({ val in
                      lastOffset = offset
                    })
            )
            .animation(.easeInOut)*/
        }
        /*TabView {
            ForEach(["A", "B", "C"], id: \.self) { item in
                ScrollView {
                    VStack {
                        ForEach(0..<100) { index in
                            Text("Item \(item): \(index + 1)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }.tabItem {
                    Text(item)
                }
            }
        }*/
        
        /*VStack {
            HStack {
                
                ScrollView {
                    VStack {
                        ForEach(0..<100) { index in
                            Text("Item A: \(index + 1)")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { geo in
                            let scrollLength = geo.size.height - scrollViewHeight
                            let rawProportion = -geo.frame(in: .named("scroll")).minY / scrollLength
                            let proportion = min(max(rawProportion, 0), 1)
                            
                            Color.clear
                                .preference(
                                    key: ScrollProportion.self,
                                    value: proportion
                                )
                                .onPreferenceChange(ScrollProportion.self) { proportion in
                                    self.proportion = proportion
                                }
                        }
                    )
                }
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            scrollViewHeight = geo.size.height
                        }
                    }
                )
                .coordinateSpace(name: "scroll")
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ForEach(0..<100) { index in
                                Text("Item B: \(index + 1)")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { geo in
                                let scrollLength = geo.size.height - scrollViewHeight
                                let rawProportion = -geo.frame(in: .named("scroll")).minY / scrollLength
                                let proportion = min(max(rawProportion, 0), 1)
                                
                                Color.clear
                                    .preference(
                                        key: ScrollProportion.self,
                                        value: proportion
                                    )
                                    .onPreferenceChange(ScrollProportion.self) { proportion in
                                        self.proportion = proportion
                                    }
                            }
                        )
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear.onAppear {
                                scrollViewHeight = geo.size.height
                            }
                        }
                    )
                    .coordinateSpace(name: "scroll")
                }
            }
        

            ProgressView(value: proportion, total: 1)
                    .padding(.horizontal)
        }*/
    }
}

struct ScrollProportion: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}*/

struct PlanningView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningView()
    }
}
