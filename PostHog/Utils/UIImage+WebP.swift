//
//  UIImage+WebP.swift
//  PostHog
//
//  Created by Yiannis Josephides on 09/12/2024.
//
// Adapted from: https://github.com/SDWebImage/SDWebImageWebPCoder/blob/master/SDWebImageWebPCoder/Classes/SDImageWebPCoder.m

#if os(iOS)
    import Accelerate
    import CoreGraphics
    import Foundation
    import UIKit

    extension UIImage {
        /**
         Returns a data object that contains the image in WebP format.

         - Parameters:
         - compressionQuality: desired compression quality [0...1] (0=max/lowest quality, 1=low/high quality)
         - Returns: A data object containing the WebP data, or nil if there’s a problem generating the data.
         */
        func webpData(compressionQuality: CGFloat) -> Data? {
            

            let webpData = Data(bytes: [], count: 0)

            return webpData
        }
    }
#endif
