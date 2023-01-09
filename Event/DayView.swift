import SwiftUI

func fmtMinutes(_ minutes: Int) -> String {
    return String(format: "%dh%02d", minutes/60, minutes%60)
}

func fmtEvent(_ minutes: ClosedRange<Int>) -> String {
    return "\(fmtMinutes(minutes.first!)) - \(fmtMinutes(minutes.last!)) · \(minutes.count - 1) min"
}

let daySize = CGFloat(120)

struct EventDetailView: View {
    let model: ViewModel
    let minutes: ClosedRange<Int>
    let schedule: Schedule
    var body: some View {
        List {
            let color = scheduleColor[schedule.type]
            VStack(alignment: .leading, spacing: 4) {
                Text(schedule.type).foregroundColor(color)
                Text(fmtEvent(minutes))
                Text(schedule.location)
            }
            
            if let speakers = schedule.speakers {
                Section {
                    ForEach(speakers, id: \.self) { id in
                        PeopleView(people: model.speakers[id]!)
                    }
                } header: {
                    Text("Speakers")
                }
            }
            
            if let note = schedule.note {
                Section {
                    Text(note)
                } header: {
                    Text("Notes")
                }
            }
        }
        .navigationTitle(schedule.activity)
        .onAppear {
            print(model.speakers)
            print(schedule.speakers)
        }
    }
}

struct EventView: View {
    @State private var isShowingDetailView = false
    let model: ViewModel
    let schedule: Schedule
    let minutes: ClosedRange<Int>
    var body: some View {
        // let height = CGFloat(minutes.count) * 2; TODO get our beautiful UI back on track
        NavigationLink {
            EventDetailView(model: model, minutes: minutes, schedule: schedule)
        } label: {
            let color = scheduleColor[schedule.type]
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(schedule.activity).bold()
                    Spacer(minLength: 4)
                    Text(schedule.type).foregroundColor(color)
                }
                Text(fmtEvent(minutes))
                Text(schedule.location)
                Spacer(minLength: 0)
            }//.frame(height: height)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(color.opacity(0.2))
                .cornerRadius(8)

        }
                .buttonStyle(PlainButtonStyle())
    }
}

// As two events can happen at the same time, our beautiful UI cannot handle them.
// We sadly do not have enough time to handle this ... :/

struct Day: View {
    let model: ViewModel
    let hours: Range<Int>
    let events: [(ClosedRange<Int>, Schedule)]
    var body: some View {
        VStack {
            ForEach(events, id: \.self.1.activity) { (minutes, schedule) in
                EventView(model: model, schedule: schedule, minutes: minutes)
            }
        }.padding(8)
        /*HStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(0..<22) { index in
                    Text("\(index):00")
                            .frame(height: daySize, alignment: .bottomLeading)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                            .offset(y: 8)
                }
            }
            Divider().padding(0)
            ZStack(alignment: .topLeading) {
                VStack {
                    ForEach(8..<21) { _ in
                        Spacer(minLength: daySize)
                        Divider()
                    }
                }
                ForEach(events, id: \.self.1.activity) { (minutes, schedule) in
                    let offset = CGFloat(minutes.first!) * 2// - CGFloat(hours.first!) * daySize;
                    EventView(schedule: schedule, minutes: minutes).offset(y: offset)
                }
            }
        }
                .frame(maxWidth: .infinity).padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))*/
    }
}
