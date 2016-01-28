//
//  ChatDataSource.swift
//  Ask Food
//
//  Created by Colearo on 16/1/26.
//  Copyright © 2016年 Colearo. All rights reserved.
//

import Foundation
/*
数据提供协议
*/
protocol ChatDataSource
{
    func rowsForChatTable(tableView:TableView) -> Int
    
    func chatTableView(tableView:TableView, dataForRow:Int)-> MessageItem
}