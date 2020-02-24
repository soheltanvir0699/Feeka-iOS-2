//
//  Extension+String.swift
//  FEEKA
//
//  Created by Apple Guru on 21/2/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation
import UIKit

      extension String {

          var htmlToAttributedString: NSAttributedString? {
              guard
                  let data = self.data(using: .utf8)
                  else { return nil }
              do {
                  return try NSAttributedString(data: data, options: [
                      NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                      NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                      ], documentAttributes: nil)
              } catch let error as NSError {
                  print(error.localizedDescription)
                  return  nil
              }
          }

          var htmlToString: String {
              return htmlToAttributedString?.string ?? ""
          }
        
        var validEmail:Bool{
            let emailFormat="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate=NSPredicate(format: "SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with:self)
        }
        func localize()->String{
            var bundle:Bundle?
            if  let path = Bundle.main.path(forResource:Locale.preferredLanguages[0], ofType: "lproj"){
                bundle = Bundle(path: path)
            }else{
                let path = Bundle.main.path(forResource: "en", ofType: "lproj")
                bundle = Bundle(path: path!)
            }
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
      }


