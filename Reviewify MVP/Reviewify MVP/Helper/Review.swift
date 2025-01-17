//
//  Review.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/22/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

class Review : PFObject, PFSubclassing {
    
    override class func initialize() {
        superclass()?.load()
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return Constants.Review.ClassName
    }
    
    var restaurantObjectId:String? {
        get {
            return self[Constants.Review.Restaurant] as? String
        }
        set {
            self[Constants.Review.Restaurant] = newValue
        }
    }
    
    var mealObjectId:String? {
        get {
            return self[Constants.Review.Meal] as? String
        }
        set {
            self[Constants.Review.Meal] = newValue
        }
    }
    
    var textReviews:[String]? {
        get {
            return self[Constants.Review.Review] as? [String]
        }
        set {
            self[Constants.Review.Review] = newValue
        }
    }
    
    var starRatings:[Float]? {
        get {
            return self[Constants.Review.StarRating] as? [Float]
        }
        set {
            self[Constants.Review.StarRating] = newValue
        }
    }
    
    var potentialReward:Int? {
        get {
            return self[Constants.Review.Reward] as? Int
        }
        set {
            self[Constants.Review.Reward] = newValue
        }
    }
    
    var reviewer:String? {
        get {
            return self[Constants.Review.Reviewer] as? String
        }
        set {
            self[Constants.Review.Reviewer] = newValue
        }
    }

    
    init(restaurant:String!, mealCode:String!, reviews:[String]!, stars:[Float]!, reward:Int!) {
        super.init()
        restaurantObjectId = restaurant
        mealObjectId = mealCode
        textReviews = reviews
        starRatings = stars
        potentialReward = reward
        reviewer = PFUser.currentUser()?.username
        
        self.saveEventually(nil)
    }
}
