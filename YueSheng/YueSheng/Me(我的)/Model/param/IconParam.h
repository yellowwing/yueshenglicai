//
//  IconParam.h
//  YueSheng
//
//  Created by yellow on 16/8/2.
//  Copyright © 2016年 yellow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconParam : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *Ui_Img;
/**
 *  上传的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  上传到服务器的文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传文件的类型
 */
@property (nonatomic, copy) NSString *mimeType;


@end
