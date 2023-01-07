import SwiftUI

struct EventView: View {
    let event: EventItem
    var body: some View {
        let height = CGFloat(event.end - event.start);
        Text(event.name)
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .background(event.color)
                .cornerRadius(8)
                .padding(2)
    }
}

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
                    let offset = CGFloat(event.start - 8 * 60);
                    EventView(event: event).offset(y: offset)
                }
            }
        }
                .frame(maxWidth: .infinity).padding(8)
    }
}