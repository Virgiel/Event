import SwiftUI

struct EventDetailView: View {
    let event: EventItem
    var body: some View {
        Text(event.name)
    }
}

struct EventDetailView_Preview: PreviewProvider {
    static var previews: some View {
        EventDetailView(event:
            EventItem(start: 570, end: 690, name: "Welcom Breakfast", color: Color.blue)
        )
    }
}
