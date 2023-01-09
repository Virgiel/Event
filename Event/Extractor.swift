import Foundation

struct Schedule: Codable{
    var Activity = ""
    var type = ""
    var Start = ""
    var End = ""
    var Location = ""
    var Speaker = ""
    var Notes = ""
}

struct Speakers: Codable{
    var Name = ""
    var Company = ""
    var Role = ""
    var Email = ""
    var Phone = ""
    var Confirmed = ""
}

struct Attendees: Codable{
    var Name = ""
    var Company = ""
    var Role = ""
    var Email = ""
    var Phone = ""
}

struct Budget: Codable{
    var Item = ""
    var Estimated = ""
    var Actual = ""
    var Quantity = ""
    var Notes = ""
    var Total_budget = ""
    var Under_budget = ""
    var Total_cost = ""
}

struct DBClient {
    private static let table_schedule = URL(string: "https://airtable.com/appLxCaCuYWnjaSKB/tblon3PzkaCkPGUnr/viwPg3QwJjoQEsQSQ?blocks=hide")!
    private static let table_speakers = URL(string: "https://airtable.com/appLxCaCuYWnjaSKB/tbl2hICf6XwPGRTzz/viw6DgExWVs4ZMeOt?blocks=hide")!
    private static let table_attendees = URL(string: "https://airtable.com/appLxCaCuYWnjaSKB/tblfPFuMesBrZme8P/viw3tftXWXKm4H1Gb?blocks=hide")!
    private static let table_budget = URL(string: "https://airtable.com/appLxCaCuYWnjaSKB/tblniaHmA6WFtaelM/viw78oS93nQLwsPEJ?blocks=hide")!

    func createRequest (_ urlStr: URL) -> URLRequest {
        var request = URLRequest(url: urlStr)
        request.timeoutInterval = 100
        request.httpMethod = "GET"
        let accessToken = " keymaCPSexfxC2hF9"
        request.setValue("Bearer\(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    func getSchedule (_ schedule: [Schedule]?) -> Void {
        let session = URLSession(configuration: .default)
        /*let task = session.dataTask(with: createRequest(Event.table_schedule)) {
            (data, response, error) in
            if let data = data, error == nil {
                if let responseHttp = response as? HTTPURLResponse {
                    if responseHttp.statusCode==200 {
                        if let response = try?
                            JSONDecoder().decode(Schedule.self, from: data){
                        }
                    }
                }
            }
        }
        task.resume()*/
    }

   // DBClient()


    func getSpeakers (_ speakers: [Speakers]?) -> Void {

    }
    func getAttendees (_ attendees: [Attendees]?) -> Void{

    }
    func getBudget (_ budget: [Budget]?) -> Void{

    }


 }
