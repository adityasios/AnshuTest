//
//  TecherMod.h
//  AnshuTest
//
//  Created by Rakhi on 05/02/19.
//  Copyright © 2019 myself. All rights reserved.
//

#import "JSONModel.h"
#import "ClassMod.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface TecherMod : JSONModel
@property (nonatomic,strong) NSURL<Optional> * teacher_school_image;
@property (nonatomic,strong) UIImage<Optional> * img_school;
@property (nonatomic,strong) NSString<Optional> * teacher_school_name;
@property (nonatomic,strong) NSArray<Optional,ClassMod> *teacher_classes;
@end

NS_ASSUME_NONNULL_END
