//
//  MATableView.swift
//  MyPlayer11
//
//  Created by Mohd Arsad on 20/04/19.
//  Copyright © 2019 Mohd Arsad. All rights reserved.
//

import Foundation
import UIKit


protocol UITableViewPullRefreshDelegate {
    func tableView(_ tableView: UITableView, pulltoRefreshStart: Bool)
}
protocol UICollectionViewPullRefreshDelegate {
    func collectionView(_ collectionView: UICollectionView, pulltoRefreshStart: Bool)
}
protocol UIScrollViewPullRefreshDelegate {
    func scrollView(_ scrollView: UIScrollView, pulltoRefreshStart: Bool)
}


class MATableView: UITableView, UIScrollViewDelegate {
    
    var pullToRefreshControl: UIRefreshControl?
    var pullToRefreshDelegate:UITableViewPullRefreshDelegate? {
        didSet {
            self.setupPullToRefresh()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // Specify the fill color and apply it to the path.
    }
    private func setupPullToRefresh() {
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl?.tintColor = UIColor.appOrange
        //self.addSubview(pullToRefreshControl!)
        self.refreshControl = pullToRefreshControl
        self.pullToRefreshControl?.addTarget(self, action: #selector(onPullToRefreshExecute(_:)), for: .valueChanged)
    }
    @objc func onPullToRefreshExecute(_ sender: Any) {
        pullToRefreshDelegate?.tableView(self, pulltoRefreshStart: true)
    }
}


class MACollectionView: UICollectionView, UIScrollViewDelegate {
    
    var pullToRefreshControl: UIRefreshControl?
    var pullToRefreshDelegate: UICollectionViewPullRefreshDelegate? {
        didSet {
            self.setupPullToRefresh()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // Specify the fill color and apply it to the path.
    }
    private func setupPullToRefresh() {
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl?.tintColor = UIColor.appOrange
        self.refreshControl = pullToRefreshControl
        self.pullToRefreshControl?.addTarget(self, action: #selector(onPullToRefreshExecute(_:)), for: .valueChanged)
    }
    @objc func onPullToRefreshExecute(_ sender: Any) {
        pullToRefreshDelegate?.collectionView(self, pulltoRefreshStart: true)
    }
}

class MAScrollView: UIScrollView, UIScrollViewDelegate {
    
    var pullToRefreshControl: UIRefreshControl?
    var pullToRefreshDelegate: UIScrollViewPullRefreshDelegate? {
        didSet {
            self.setupPullToRefresh()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // Specify the fill color and apply it to the path.
    }
    private func setupPullToRefresh() {
        pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl?.tintColor = UIColor.appOrange
        self.refreshControl = pullToRefreshControl
        self.pullToRefreshControl?.addTarget(self, action: #selector(onPullToRefreshExecute(_:)), for: .valueChanged)
    }
    @objc func onPullToRefreshExecute(_ sender: Any) {
        pullToRefreshDelegate?.scrollView(self, pulltoRefreshStart: true)
    }
}
