//
//  LINEAPI.swift
//  LINEStickerExplorer
//
//  Created by UnciaX on 2016/1/2.
//  Copyright © 2016年 UnciaX. All rights reserved.
//

import Foundation

class LINEAPI{
    let baseUrl = "https://sdl-stickershop.line.naver.jp/products/0/0/1/"
    
    //MARK: - Method
    //MARK: Sticker Info
    func getSetInfo(setID: Int) -> String{
        //http://dl.stickershop.line.naver.jp/products/0/0/1/1064176/android/productInfo.meta
        return "\(baseUrl)\(setID)/android/productInfo.meta"
    }
    
    //MARK: Sticker Image
    
    func getSetMainSticker(setID: Int) -> String{
        //http://dl.stickershop.line.naver.jp/products/0/0/1/5033/android/main.png
        return "\(baseUrl)\(setID)/android/main.png"
    }
    
    func getStickerImage(setID: Int, stickerID: Int) -> String{
        //http://dl.stickershop.line.naver.jp/products/0/0/1/5033/android/stickers/7115474.png
        return "\(baseUrl)\(setID)/android/stickers/\(stickerID).png"
    }
    
    func getAnimationSticker(setID: Int, stickerID: Int) -> String{
        //https://sdl-stickershop.line.naver.jp/products/0/0/1/5754/android/animation/9314105.png
        return "\(baseUrl)\(setID)/android/animation/\(stickerID).png"
    }
    
    //MARK: Sticker Sound
    
    func getSoundUrl(setID: Int, stickerID: Int) -> String{
        //https://sdl-stickershop.line.naver.jp/products/0/0/1/5754/android/sound/9314105.m4a
        return "\(baseUrl)\(setID)/android/sound/\(stickerID).m4a"
    }
}