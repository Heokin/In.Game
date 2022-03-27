//
//  ViewController.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 25.03.22.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Item = LabelCollectionViewCell.Entity
    typealias Cell = LabelCollectionViewCell
    
    enum Section: CaseIterable {
        case main
    }
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    private lazy var labelSnapshot = makeLabelSnapshot()
    private lazy var textField = makeTextField()

    private let service: Service = ServiceImpl()
    
    private var drinkItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        prepareUI()
        setupDataSource()
        hideKeyboardWhenTappedAround()
        setupNotifications()
    }

    //MARK: - Keyboard setup
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification as Notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification as Notification)
    }
    
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        UIView.animate(withDuration: 0.3) { [unowned self] in
            if notification.name == UIResponder.keyboardWillHideNotification {
                textField.layer.cornerRadius = 9.0
                textField.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview().inset(50)
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
                    make.height.equalTo(40)
                }
            } else {
                textField.layer.cornerRadius = 0.0
                textField.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
                    make.height.equalTo(40)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        drinkItems.forEach { $0.state = .normal }
        selectedItem.state = .selected

        dataSource.applySnapshotUsingReloadData(labelSnapshot)
    }
}

private extension MainViewController {
    func prepareUI() {
        view.addSubview(collectionView)
        view.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).inset(-10)
        }
    }
    
    func cellProvider(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: Item) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell
        cell?.configure(entity: item)
        
        return cell
    }
    
    func setupDataSource() {
        service.getDrinks { [weak self] drinks in
            guard let self = self else { return }
            
            self.drinkItems = drinks.compactMap { drink -> Item? in
                guard let drinkName = drink.strDrink else { return nil }
                
                return .init(text: drinkName)
            }
            
            self.dataSource.applySnapshotUsingReloadData(self.labelSnapshot)
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    
    func configureCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(30.0), heightDimension: .absolute(28.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(28.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(Constant.interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = Constant.interGroupSpacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
        if self.textField.text == "" {
            self.textField.placeholder = "Coctail name"
        }
    }
    
    @objc
    func textFieldValueChanged(_ textField: UITextField) {
        guard let text = textField.text?.lowercased() else { return }
        
        if text == "" {
            dataSource.applySnapshotUsingReloadData(labelSnapshot)
        } else {
            let filteredItems = drinkItems.filter { $0.text.lowercased().contains(text) }
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(filteredItems)
            
            dataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
    
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCompositionalLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        
        return collectionView
    }
    
    func makeTextField() -> UITextField {
        let textField = UITextField(placeholder: "Coctail name")
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        
        return textField
    }
    
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView, cellProvider: { [unowned self] in cellProvider($0, $1, $2) })
    }
    
    func makeLabelSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(drinkItems)
        
        return snapshot
    }
}

private extension MainViewController {
    enum Constant {
        static var interItemSpacing: CGFloat { 8.0 }
        static var interGroupSpacing: CGFloat { interItemSpacing }
    }
}
