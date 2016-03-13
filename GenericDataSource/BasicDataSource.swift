//
//  BasicDataSource.swift
//  GenericDataSource
//
//  Created by Mohamed Afifi on 9/16/15.
//  Copyright © 2016 mohamede1945. All rights reserved.
//

import UIKit

public class BasicDataSource<ItemType, CellType: ReusableCell> : AbstractDataSource {

    /// The size of the cell. When setting a value to it. It will set `useDelegateForItemSize` to `true`.
    public var itemSize: CGSize = CGSize.zero {
        didSet {
            useDelegateForItemSize = true
        }
    }

    /// Used for UITableView.
    public var itemHeight: CGFloat {
        set {
            itemSize = CGSize(width: 0, height: newValue)
        }
        get {
            return itemSize.height
        }
    }

    public var useDelegateForItemSize: Bool = false

    public var items: [ItemType] = [] {
        didSet {
            selectionHandler?.dataSourceItemsModified(self)
        }
    }

    public let reuseIdentifier: String
    
    public var selectionHandler: AnyDataSourceSelectionHandler<ItemType, CellType>? = nil

    public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }

    // MARK:- Items

    public func itemAtIndexPath(indexPath: NSIndexPath) -> ItemType {
        return items[indexPath.item]
    }

    public func replaceItemAtIndexPath(indexPath: NSIndexPath, withItem item: ItemType) {
        items[indexPath.item] = item
    }

    // MARK:- DataSource
    
    // MARK: Cell

    public override func ds_numberOfSections() -> Int {
        return 1
    }

    public override func ds_numberOfItems(inSection section: Int) -> Int {
        return items.count
    }

    public override func ds_collectionView(collectionView: GeneralCollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ReusableCell {

        let cell = ds_collectionView(collectionView, nonConfiguredCellForItemAtIndexPath: indexPath)
        let item: ItemType = itemAtIndexPath(indexPath)
        ds_collectionView(collectionView: collectionView, configureCell: cell, withItem: item, atIndexPath: indexPath)
        selectionHandler?.dataSource(self, collectionView: collectionView, configureCell: cell, withItem: item, atIndexPath: indexPath)
        return cell
    }

    public func ds_collectionView(collectionView: GeneralCollectionView, nonConfiguredCellForItemAtIndexPath indexPath: NSIndexPath) -> CellType {

        let cell = collectionView.ds_dequeueReusableCellViewWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        guard let castedCell = cell as? CellType else {
            fatalError("cell: \(cell) with reuse identifier '\(reuseIdentifier)' expected to be of type \(CellType.self).")
        }
        return castedCell
    }

    public func ds_collectionView(collectionView collectionView: GeneralCollectionView, configureCell cell: CellType, withItem item: ItemType, atIndexPath indexPath: NSIndexPath) {
        // does nothing
        // should be overriden by subclasses
    }

    // MARK: Size

    public override func ds_shouldConsumeItemSizeDelegateCalls() -> Bool {
        return useDelegateForItemSize
    }

    public override func ds_collectionView(collectionView: GeneralCollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return itemSize
    }

    // MARK: Selection
    public override func ds_collectionView(collectionView: GeneralCollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return selectionHandler?.dataSource(self, collectionView: collectionView, shouldHighlightItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, shouldHighlightItemAtIndexPath: indexPath)
    }
    
    public override func ds_collectionView(collectionView: GeneralCollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        return selectionHandler?.dataSource(self, collectionView: collectionView, didHighlightItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, didHighlightItemAtIndexPath: indexPath)
    }
    
    public override func ds_collectionView(collectionView: GeneralCollectionView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        return selectionHandler?.dataSource(self, collectionView: collectionView, didUnhighlightItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, didUnhighlightRowAtIndexPath: indexPath)
    }

    public override func ds_collectionView(collectionView: GeneralCollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return selectionHandler?.dataSource(self, collectionView: collectionView, shouldSelectItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, shouldSelectItemAtIndexPath: indexPath)
    }
    
    public override func ds_collectionView(collectionView: GeneralCollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        return selectionHandler?.dataSource(self, collectionView: collectionView, didSelectItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    public override func ds_collectionView(collectionView: GeneralCollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return selectionHandler?.dataSource(self, collectionView: collectionView, shouldDeselectItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, shouldDeselectItemAtIndexPath: indexPath)
    }

    public override func ds_collectionView(collectionView: GeneralCollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        return selectionHandler?.dataSource(self, collectionView: collectionView, didDeselectItemAtIndexPath: indexPath) ??
            super.ds_collectionView(collectionView, didDeselectItemAtIndexPath: indexPath)
    }
}