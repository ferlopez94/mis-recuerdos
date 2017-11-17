//
//  Question.swift
//  MisRecuerdos
//
//  Created by mac OS on 11/16/17.
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

final class Question: NSObject {
    
    var descrip: String = ""
    var answersList: [String] = []
    var answer: Int!
    var photo: UIImage!
    var questionType: String!
    
    init(descrip: String, answersList: [String], answer: Int, photo: UIImage, questionType: String) {
        self.descrip = descrip
        self.answersList = answersList
        self.answer = answer
        self.photo = photo
        self.questionType = questionType
    }

}
