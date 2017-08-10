//
//  WBStatusToolBar.swift
//  SinaWeiBo
//
//  Created by Frank on 2017/8/9.
//  Copyright © 2017年 Frank. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {

    
    
    /// 转发
    @IBOutlet weak var retweetedButton: UIButton!
    /// 评论
    @IBOutlet weak var commentButton: UIButton!
    /// 点赞
    @IBOutlet weak var likeButton: UIButton!
    
    
    var viewModel: WBStatusViewModel? {
        didSet {
//                        retweetedButton.setTitle("\(viewModel?.status.reposts_count)", for: [])
//                        commentButton.setTitle("\(viewModel?.status.comments_count)", for: [])
//                        likeButton.setTitle("\(viewModel?.status.attitudes_count)", for: [])
            
            retweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }

}
