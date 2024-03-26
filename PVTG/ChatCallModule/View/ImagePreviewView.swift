//
//  ImagePreviewView.swift
//  SocketAudioChat
//
//  Created by Anuj Kumar on 21/11/22.
//

import UIKit

class ImagePreviewView: AKBaseVC {
    //MARK: - IBOutlet
    @IBOutlet private weak var adapter: UICollectionView!
    //MARK: - variables
    var list: [String] = []
    var selectedIndax = 0
    //MARK: - Lifecycle function
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.adapter.scrollToItem(at: IndexPath(row: self.selectedIndax, section: 0), at: .centeredHorizontally, animated: true)
    }
    //MARK: - Set Data
    func set(list: [String]) {
        self.list = list
    }
    func setScroll(index: Int){
        //        adapter.reloadData()
        
    }
    //MARK: - IBAction For Navigation
    @IBAction private func backAction() {
        self.back()
    }
}
//MARK: - CollectionView Delegate Method
extension ImagePreviewView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.adapter.dequeueReusableCell(withReuseIdentifier: ImagePreviewCVCell.id, for: indexPath) as! ImagePreviewCVCell
        if let url = URL(string: self.list[indexPath.item]) {
//            AKCachedImageLoader.shared.loadImage(from: url, placeholder: UIImage(systemName: "photo.fill")!) { img in
//                cell.imageVw.image = img
//            }
            cell.imageVw.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            cell.imageVw.image = UIImage(systemName: "photo.fill")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.adapter.frame.size
    }
}

class ImagePreviewCVCell: UICollectionViewCell {
    @IBOutlet weak var imageVw: UIImageView!
}
