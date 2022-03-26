//
//  ViewController.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 25.03.22.
//

import UIKit
import SnapKit
class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setConstraints()
        setupCollectionView()
        searchTextField.backgroundColor = .white
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        
        let service = Service()
        service.getCoctailName()
        
                NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
                NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionView.self, forCellWithReuseIdentifier: "cellid")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
        @objc func keyboardWillShow(notification: NSNotification) {
            guard let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                   return
                }
            viewForTf.snp.makeConstraints { make in
                make.bottom.equalTo(view.keyboardLayoutGuide.snp.bottom)
            }
            }
    
    
        @objc func keyboardWillHide(notification: NSNotification) {
            print("2")
        }
    
    //MARK: - Create UI
    var searchTextField = UITextField(placeholder: "Coctail name")
    let viewForTf: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        return view
    }()
    //MARK: - SnapKit constraints
    
    func setConstraints() {
        view.addSubview(viewForTf)
        viewForTf.addSubview(searchTextField)
    
        
        viewForTf.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(90)
            maker.height.equalTo(40)
        }
        searchTextField.snp.makeConstraints { maker in
            maker.left.equalTo(viewForTf.snp.left)
            maker.right.equalTo(viewForTf.snp.right)
            maker.bottom.equalTo(viewForTf.snp.bottom)
            maker.top.equalTo(viewForTf.snp.top)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    
}
// MARK: - SwiftUI
import SwiftUI

struct MainViewController: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = ViewController()
        
        func makeUIViewController(context: Context) ->  ViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

