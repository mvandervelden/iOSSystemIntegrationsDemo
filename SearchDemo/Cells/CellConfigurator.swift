//
//  File.swift
//  SearchDemo
//
//  Created by maarten.van.der.velden@philips.com on 07/04/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit

struct CellConfigurator<Cell where Cell:Updatable, Cell:UITableViewCell> {
    let viewData: Cell.ViewData
    let reuseIdentifier: String = NSStringFromClass(Cell)
    let cellClass: AnyClass = Cell.self
    
    func updateCell(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.updateWithViewData(viewData)
        }
    }
}

extension CellConfigurator: CellConfiguratorType {
}