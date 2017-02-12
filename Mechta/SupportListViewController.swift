import UIKit

class SupportListViewController: UITableViewController {
    private let model = SupportFacade()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if model.hasSupportedApps {
            showContentBackground()
        } else {
            showMessageBackground("Поддерживаемые приложения не установлены", subtitle: "Вы можете установить Whatsapp или Viber для связи с диспетчером")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.hasSupportedApps
            ? "Для получения информации о маршрутах и расписании мечта-авто, а так же уточнения любых выпросов свяжитесь любым удобным для вас способом с диспетчером"
            : nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.supportedApps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell") as! SupportItemCell
        let app = model.supportedApps[indexPath.row]
        cell.show(title: app.title, imageName: app.icon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let app = model.supportedApps[indexPath.row]
        model.call(url: app.url)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
