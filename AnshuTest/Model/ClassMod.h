//
//  ClassMod.h
//  AnshuTest
//
//  Created by Rakhi on 05/02/19.
//  Copyright © 2019 myself. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ClassMod;
@interface ClassMod : JSONModel

@property (nonatomic,strong) NSString<Optional> * teacher_class;
@property (nonatomic,strong) NSString<Optional> * teacher_section;
@property (nonatomic,strong) NSString<Optional> * teacher_subject;


@end

NS_ASSUME_NONNULL_END


