import SwiftUI

func minuteOffset(date: Date) -> Int {
    let comps = Calendar.current.dateComponents([.hour,.minute], from: date)
    return comps.hour! * 60 + comps.minute!
}

struct ScheduleAnalysis {
    let days: [(Int, [(ClosedRange<Int>, Schedule)])]
    let firstHour: Int
    let lastHour: Int
    let nbHour: Int
    
    init(schedules: [Schedule]) {
        if schedules.isEmpty {
            days = []
            firstHour = 0
            lastHour = 0
            nbHour = 0
            return
        }
        let calendar = Calendar.current
        // Sort schedule and extract they date components
        let sorted = schedules.sorted(by: {$0.start < $1.start}).map({(calendar.dateComponents([.day, .hour], from: $0.start), $0)})
        // Create list of days
        let start = sorted.first?.0.day ?? 0
        let end = sorted.last?.0.day ?? 0
        self.firstHour = sorted.map({$0.0.hour!}).min()!
        self.lastHour = sorted.map({$0.0.hour!}).max()!
        var days: [(Int, [(ClosedRange<Int>, Schedule)])] = Array(start...end).map({($0, [])})
        // Group schedule by days
        for (comps, schedule) in sorted {
            // Compute minutes offset
            days[comps.day!-start].1.append((minuteOffset(date: schedule.start)...minuteOffset(date: schedule.end), schedule))
        }
        self.days = days
        nbHour = lastHour - firstHour
    }
}

struct ScheduleView: View {
    var model: ViewModel
    @StateObject private var state = CarouselState(count: 0)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        ForEach(0..<model.analysis.days.count, id: \.self) { i in
                            let background = state.selected == i ? Color.accentColor : Color.clear
                            let text = state.selected == i ? Color.white : Color.primary
                            Button(action: { state.selected = i }) {
                                Text("\(model.analysis.days[i].0)").foregroundColor(text)
                            }
                            .frame(width: 35, height: 35)
                            .background(background)
                            .clipShape(Capsule())
                        }
                    }
                    Spacer().frame(height: 10)
                    Divider()
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemFill))
                Carousel(state: state, content: { (i) in Day( model: model, hours: model.analysis.firstHour..<model.analysis.lastHour, events: model.analysis.days[i].1) })
            }.onAppear {
                state.count = model.analysis.days.count
            }
        }
    }
}
