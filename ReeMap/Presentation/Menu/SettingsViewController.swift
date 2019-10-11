import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    
    private var pickerView: UIPickerView!
    private let pickerViewHeight: CGFloat = 160
    
    private var pickerToolbar: UIToolbar!
    private let toolbarHeight: CGFloat = 40.0
    
    private let meters: [Double] = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
    
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .groupTableViewBackground
        table.separatorInset = .zero
        table.register(MenuDetailCell.self, forCellReuseIdentifier: String(describing: MenuDetailCell.self))
        return table
    }()
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsViewController {
    
    func setup() {
        view.addSubview(tableView)
        navigationController?.isNavigationBarHidden = false
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        //pickerView
        pickerView = UIPickerView(frame: CGRect(x: 0, y: height + toolbarHeight, width: width, height: pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .clear
        self.view.addSubview(pickerView)
        
        //pickerToolbar
        pickerToolbar = UIToolbar(frame: CGRect(x: 0, y: height, width: width, height: toolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneTapped))
        pickerToolbar.items = [flexible, doneBtn]
        self.view.addSubview(pickerToolbar)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Settings.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Settings.allCases[section] {
        case .range:
            return Settings.range.descriptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.apply(.body)
        label.text = Settings.allCases[section].description
        label.textColor = .gray
        view.addSubview(label)
        label.anchor()
            .top(to: view.topAnchor, constant: 10)
            .left(to: view.leftAnchor, constant: 10)
            .bottom(to: view.bottomAnchor, constant: -10)
            .activate()
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let label = UILabel()
        label.apply(.body)
        label.numberOfLines = 0
        label.text = R.string.localizable.message_range_select()
        label.textColor = .gray
        view.addSubview(label)
        label.anchor()
            .top(to: view.topAnchor, constant: 10)
            .centerXToSuperview()
            .bottom(to: view.bottomAnchor, constant: -10)
            .width(constant: self.view.frame.width * 0.7)
            .activate()
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuDetailCell.self), for: indexPath) as? MenuDetailCell
        else { return UITableViewCell() }
        cell.title.text = Settings.allCases[indexPath.section].descriptions[indexPath.row]
        cell.content.text = "\(Int(AppUserDefaultsUtils.getRemindMeter())) m"
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = meters.findIndex { "\(Int($0))" == "\(Int(AppUserDefaultsUtils.getRemindMeter()))" }
        pickerView.selectRow(index[0], inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
        UIView.Animator(duration: 0.2).animations { [unowned self] in
            self.pickerToolbar.frame.origin.y = self.view.frame.height - self.pickerViewHeight - self.toolbarHeight
            self.pickerView.frame.origin.y = self.view.frame.height - self.pickerViewHeight
        }.animate()
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return meters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "\(Int(meters[row])) m"
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuDetailCell else { return }
        cell.content.text = "\(Int(meters[row])) m"
        AppUserDefaultsUtils.setRangeMeter(meters[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension SettingsViewController {
    
    @objc func doneTapped() {
        UIView.Animator(duration: 0.2).animations { [unowned self] in
            self.pickerToolbar.frame = CGRect(x: 0,
                                              y: self.view.frame.height,
                                              width: self.view.frame.width,
                                              height: self.toolbarHeight)
            self.pickerView.frame = CGRect(x: 0,
                                           y: self.view.frame.height + self.toolbarHeight,
                                           width: self.view.frame.width,
                                           height: self.pickerViewHeight)
        }.animate()
    }
}

extension Array {
    
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        var indexArray: [Int] = []
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}
