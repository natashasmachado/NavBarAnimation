//
//  ViewController.swift
//  NavBarAnimation
//
//  Created by Natasha Machado on 2023-05-15.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  
  
  @IBOutlet var whiteViewController: UIView!
  @IBOutlet var grayView: UIView!
  
  @IBOutlet var grayViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var plusIcon: UIButton!
  
  @IBOutlet var tableView: UITableView!
  
  
  var stackView: UIStackView!
  let snackName = UILabel()
  let titleLabel = UILabel()
  var snackNames = ["Oreo", "Pizza", "Pop-Tarts", "Popsicle", "Ramen"]
  var selectedSnackName: String?
 
  

  var isPlusIconVisible = true {
    didSet {
      let rotationAngle = isPlusIconVisible ? 0.0 : CGFloat.pi / 4.0
      UIView.animate(withDuration: 0.3) {
        self.plusIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
      }
      
      stackView.isHidden = isPlusIconVisible
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    setupStackView()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SnackCell")

  }
  
  private func setupStackView() {
    stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    
    var index = 0
    for imageName in snackNames {
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.contentMode = .scaleAspectFit
      stackView.addArrangedSubview(imageView)
      
      imageView.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
      imageView.addGestureRecognizer(tapGesture)
      
      index += 1
    }
    
    for (index, subview) in stackView.arrangedSubviews.enumerated() {
      guard let imageView = subview as? UIImageView else { continue }
      
      let button = UIButton(type: .system)
      button.tag = index
      button.addTarget(self, action: #selector(snackButtonPressed(_:)), for: .touchUpInside)
      imageView.isUserInteractionEnabled = true
      
      imageView.addSubview(button)
      
      button.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        button.topAnchor.constraint(equalTo: imageView.topAnchor),
        button.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
        button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
        button.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
      ])
    }
    
    
    grayView.addSubview(stackView)
    
    
    titleLabel.text = "Snacks"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    grayView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 65),
      stackView.widthAnchor.constraint(equalTo: grayView.widthAnchor),
      stackView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: grayView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: grayView.bottomAnchor),
      
      titleLabel.centerXAnchor.constraint(equalTo: grayView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: grayView.topAnchor, constant: 70),
    ])
    
    stackView.isHidden = true
  }
  
  
  @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
    _ = sender.view as? UIImageView
  }
  
  
  @IBAction func plusIconPressed(_ sender: UIButton) {
    isPlusIconVisible.toggle()
    titleLabel.text = "Add Snacks"
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
      self.grayViewHeightConstraint.constant = self.isPlusIconVisible ? 88 : 200
      self.view.layoutIfNeeded()
    }, completion: nil)
    
    print("plus icon pressed")
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return snackNames.count
  }
  

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SnackCell", for: indexPath)
      let snackName = snackNames[indexPath.row]
      cell.textLabel?.text = snackName
      cell.textLabel?.isHidden = true
    
      return cell
  }
   
  @objc func snackButtonPressed(_ sender: UIButton) {
    let index = sender.tag
    let cell = tableView.dequeueReusableCell(withIdentifier: "SnackCell")
    guard index >= 0 && index < snackNames.count else { return }
    cell?.textLabel?.isHidden = false
    tableView.reloadData()
  }
  
}
