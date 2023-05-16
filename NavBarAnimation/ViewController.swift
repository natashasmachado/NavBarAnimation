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
  let imageNames = ["Oreo", "Pizza", "Pop-Tarts", "Popsicle", "Ramen"]
  let snackName = UILabel()
  
  
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
    tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageCell")
    
  }
  
  private func setupStackView() {
    stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    
    var index = 0
    for imageName in imageNames {
      let imageView = UIImageView(image: UIImage(named: imageName))
      imageView.contentMode = .scaleAspectFit
      stackView.addArrangedSubview(imageView)
      
      imageView.isUserInteractionEnabled = true
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
      imageView.addGestureRecognizer(tapGesture)
      
      index += 1
    }
    
    grayView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 45),
      stackView.widthAnchor.constraint(equalTo: grayView.widthAnchor),
      stackView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: grayView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: grayView.bottomAnchor),
    ])
    
    stackView.isHidden = true
  }
  
  
  @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
    guard let imageView = sender.view as? UIImageView else {
      return
    }
    
    guard let index = stackView.arrangedSubviews.firstIndex(of: imageView) else {
      return
    }
    
    let label: UILabel = self.snackName
    
    switch index {
    case 0:
      label.text = "Oreo"
    case 1:
      label.text = "Pizza"
    case 2:
      label.text = "Pop-Tarts"
    case 3:
      label.text = "Popsicle"
    case 4:
      label.text = "Ramen"
    default:
      break
    }
  }
  
  
  
  @IBAction func plusIconPressed(_ sender: UIButton) {
    isPlusIconVisible.toggle()
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
      self.grayViewHeightConstraint.constant = self.isPlusIconVisible ? 88 : 200
      self.view.layoutIfNeeded()
    }, completion: nil)
    print("plus icon pressed")
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return imageNames.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTableViewCell
    
    if indexPath.row < imageNames.count {
      let imageName = imageNames[indexPath.row]
      cell.snackName?.text = imageName
      cell.snackName?.isHidden = false
    } else {
      cell.snackName.text = ""
      cell.snackName.isHidden = true  
    }
    
    // Configure the tap action closure
    cell.tapAction = { [weak self] tappedImageName in
      if let index = self?.imageNames.firstIndex(of: tappedImageName) {
        let indexPath = IndexPath(row: index, section: 0)
        if let visibleCell = tableView.cellForRow(at: indexPath) as? ImageTableViewCell {
          visibleCell.snackName.isHidden = !visibleCell.snackName.isHidden
        }
      }
    }
    
    return cell
  }
  
  
  
}
