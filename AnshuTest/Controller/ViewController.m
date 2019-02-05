//
//  ViewController.m
//  AnshuTest
//
//  Created by Rakhi on 05/02/19.
//  Copyright © 2019 myself. All rights reserved.


/*

## Create app in Objective c language
Create tableview expandable & collapsable
Use Storyboard to create layouts that fits for all devices
Consider the url given:
http://168.62.167.198/mobile/users/manage?flag=get_profile_details&user_id=1739
Fetch data from key teacher_profile_data from Api
one section is Profile - expanded by default, show teacher_school_image and teacher name

other section is class & section [fetch teacher_classes key]
On selection of above row - display Class and section ex. 1st, C
and on further selection of above row - show subject according to class and section
ex.  Hindi [on selecting 1st, C]
English [on selecting LKG, A]
Maths [on selecting UKG, B]
*/
//

#import "ViewController.h"


@interface ViewController (){
    TecherMod * objTch;
    NSInteger intSelectedSection ;
    NSInteger intSelectedRow ;
}


@property (weak, nonatomic) IBOutlet UITableView *tblv;

@end

@implementation ViewController



#pragma mark - VC LIOFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  initMethod];
    [self  webcallForAPI];
}

#pragma mark - INIT METHOD
-(void)initMethod{
    intSelectedSection = 0;
    intSelectedRow = -1;
    self.tblv.estimatedRowHeight = 40;
    self.tblv.rowHeight = UITableViewAutomaticDimension;
}



#pragma mark - WEBCALL
-(void)webcallForAPI {
    [DejalBezelActivityView  activityViewForView:self.view withLabel:@"Please Wait"];
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    NSURL *url = [NSURL URLWithString:@"http://168.62.167.198/mobile/users/manage?flag=get_profile_details&user_id=1739"];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL: url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DejalBezelActivityView  removeViewAnimated:true];
        });
        NSError * err;
        NSDictionary * dict = [NSJSONSerialization  JSONObjectWithData:data options:kNilOptions error:&err];
        if (err != nil) {
            NSLog(@"Error %@", err.localizedDescription);
        }else{
            NSDictionary * dictTch = [[[dict  objectForKey:@"response"] objectForKey:@"response_data"] objectForKey:@"teacher_profile_data"]  ;
            [self  parsingWebCallData:dictTch];
        }
    }];
    [dataTask resume];
}


-(void)parsingWebCallData:(NSDictionary *)dictTch{
    NSError * err;
    objTch = [[TecherMod  alloc] initWithDictionary:dictTch error:&err];
    if (err != nil) {
        NSLog(@"localizedDescription: %@",err.localizedDescription);
    }else{
        NSLog(@"objTch: %@",objTch.description);
        [self  loadSchoolImageOnImgView:nil isImgView:false];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblv  reloadData];
        });
    }
}




#pragma mark - TBLV DATASOURCE
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (intSelectedSection == 0) {
            return 2;
            
        }else{
            return 1;
        }
    }else{
        if (intSelectedSection == 1) {
            return objTch.teacher_classes.count + 1;
        }else{
            return 1;
        }
    }
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell * tcell = [tableView  dequeueReusableCellWithIdentifier:@"celltitle" forIndexPath:indexPath];
            UILabel * lbl = (UILabel *)[tcell  viewWithTag:10];
            lbl.text = @"Profile";
            return tcell;
        }else{
            UITableViewCell * tcell = [tableView  dequeueReusableCellWithIdentifier:@"cellpro" forIndexPath:indexPath];
            
            //name
            UILabel * lbl = (UILabel *)[tcell  viewWithTag:20];
            lbl.text = objTch.teacher_school_name;
            
            //img
            UIImageView * imgV = (UIImageView *)[tcell  viewWithTag:10];
            if (objTch.img_school) {
                imgV.image = objTch.img_school;
            }else{
                [self  loadSchoolImageOnImgView:imgV isImgView:true];
            }
            return tcell;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell * tcell = [tableView  dequeueReusableCellWithIdentifier:@"celltitle" forIndexPath:indexPath];
            UILabel * lbl = (UILabel *)[tcell  viewWithTag:10];
            lbl.text = @"Class & Section";
            return tcell;
        }else{
            ClassMod * objClass =  [objTch.teacher_classes objectAtIndex:indexPath.row - 1];
            
            UITableViewCell * tcell = [tableView  dequeueReusableCellWithIdentifier:@"cellclass" forIndexPath:indexPath];
            UILabel * lbl = (UILabel *)[tcell  viewWithTag:10];
            if (indexPath.row == intSelectedRow) {
                lbl.text = [NSString  stringWithFormat:@"%@ ( %@ )\n\n %@ ",objClass.teacher_class,objClass.teacher_section,objClass.teacher_subject];
            }else{
                lbl.text = [NSString  stringWithFormat:@"%@ ( %@ ) ",objClass.teacher_class,objClass.teacher_section];
            }
            return tcell;
        }
    }
    return nil;
}






#pragma mark - TBLV DELEGATE
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 40;
        }else{
            return 150;
        }
    } else if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }
    
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        intSelectedSection = indexPath.section;
        [self.tblv  reloadData];
    }else if (indexPath.row > 0 && indexPath.section == 1){
        intSelectedRow = indexPath.row;
        [self.tblv  reloadData];
    }
}



/*
 [self.tblv beginUpdates];
 NSIndexSet * indexset = [[NSIndexSet alloc] initWithIndex:intSelectedSection];
 [self.tblv reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
 [self.tblv endUpdates];
 */

#pragma mark - LOAD IMAGE
-(void)loadSchoolImageOnImgView:(UIImageView *)imgV isImgView:(BOOL)isImgV{
    
    NSURL * url = objTch.teacher_school_image;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: url];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->objTch.img_school = [UIImage imageWithData: data];
            if (isImgV) {
                imgV.image = self->objTch.img_school;
            }
            
        });
    });
}




@end
