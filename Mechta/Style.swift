import UIKit

class Style {
    static let backgroundDarkColor = UIColor.fromRgbString("#D3DBE2")
    static let backgroundColor = UIColor.fromRgbString("#EBEFF6")
    static let darkColor = UIColor.fromRgbString("#4E6A79")
    static let brightColor = UIColor.fromRgbString("#00A5DC")
    static let additionalColor = UIColor.fromRgbString("#52BE5A")
    static let greenColor = UIColor.fromRgbString("#8DC374")
    
    static func apply() {
        //Таблицы
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = backgroundColor
        
        //Ячейки таблицы.
        let tableCellAppearance = UITableViewCell.appearance()
        let cellSelectionBackground = UIView()
        cellSelectionBackground.backgroundColor = backgroundDarkColor
        tableCellAppearance.selectedBackgroundView = cellSelectionBackground
        
        //Надписи
        let labelAppearance = UILabel.appearance()
        labelAppearance.textColor = darkColor
        
        //Индикатор активности
        let activityIndicatorViewAppearance = UIActivityIndicatorView.appearance()
        activityIndicatorViewAppearance.tintColor = darkColor
        
        //Кнопки
        let buttonAppearance = UIButton.appearance()
        buttonAppearance.tintColor = brightColor
        
        //Панель навигации
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barStyle = .black
        navBarAppearance.tintColor = UIColor.white
        navBarAppearance.setBackgroundImage(brightColor.coloredImage, for: .default)
        navBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        //Переключатель
        let switchAppearance = UISwitch.appearance()
        switchAppearance.onTintColor = additionalColor
    }
}
