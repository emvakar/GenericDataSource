//
//  AbstractDataSource.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 9/16/15.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import UIKit

internal let sizeSelectors: [Selector] = ["tableView:heightForRowAtIndexPath", "collectionView:layout:sizeForItemAtIndexPath"]

extension AbstractDataSource: DataSource { }

public class AbstractDataSource : NSObject, UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {

    public var scrollViewDelegate: UIScrollViewDelegate? = nil

    public weak var reusableViewDelegate: DataSourceReusableViewDelegate? = nil
    
    override init() {
        guard self.dynamicType != AbstractDataSource.self else {
            fatalError("AbstractDataSource instances can not be created; create a subclass instance instead.")
        }
    }

    // MARK: respondsToSelector

    private func scrollViewDelegateCanHandleSelector(selector: Selector) -> Bool {
        if let scrollViewDelegate = scrollViewDelegate where selector.description.hasPrefix("scrollView") && scrollViewDelegate.respondsToSelector(selector) {
            return true
        }
        return false
    }

    public override func respondsToSelector(selector: Selector) -> Bool {

        if sizeSelectors.contains(selector) {
            return canHandleCellSize()
        }

        if scrollViewDelegateCanHandleSelector(selector) {
             return true
        }

        return super.respondsToSelector(selector)
    }
    
    public override func forwardingTargetForSelector(selector: Selector) -> AnyObject? {
        if scrollViewDelegateCanHandleSelector(selector) {
            return scrollViewDelegate
        }
        return super.forwardingTargetForSelector(selector)
    }

    // MARK:- DataSource

    // MARK: UITableViewDataSource

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableCollectionView(tableView, cellForItemAtIndexPath: indexPath) as! UITableViewCell
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    public func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            return tableCollectionView(collectionView, cellForItemAtIndexPath: indexPath) as! UICollectionViewCell
    }

    // MARK: UITableViewDelegate

    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableCollectionView(tableView, shouldHighlightItemAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableCollectionView(tableView, didHighlightItemAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableCollectionView(tableView, didSelectItemAtIndexPath: indexPath)
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableCollectionView(tableView, sizeForItemAtIndexPath: indexPath).height
    }

    // MARK: UICollectionViewDelegate

    public func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableCollectionView(collectionView, shouldHighlightItemAtIndexPath: indexPath)
    }

    public func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        tableCollectionView(collectionView, didHighlightItemAtIndexPath: indexPath)
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        tableCollectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return tableCollectionView(collectionView, sizeForItemAtIndexPath: indexPath)
    }
}