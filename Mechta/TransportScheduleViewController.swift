import UIKit

class TransportScheduleViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! TransportScheduleCell
        cell.show(scheduleItem: ScheduleItem(hour: "10", minutes: [("05", false), ("10", true), ("15", false), ("30", false), ("45", true), ("55", false)]))
        return cell
    }
}
