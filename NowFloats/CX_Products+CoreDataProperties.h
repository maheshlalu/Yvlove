//
//  CX_Products+CoreDataProperties.h
//  NowFloats
//
//  Created by SRINIVASULU on 30/03/17.
//  Copyright © 2017 CX. All rights reserved.
//

#import "CX_Products+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CX_Products (CoreDataProperties)

+ (NSFetchRequest<CX_Products *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *addToCart;
@property (nullable, nonatomic, copy) NSString *categoryType;
@property (nullable, nonatomic, copy) NSString *createdById;
@property (nullable, nonatomic, copy) NSString *favourite;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, copy) NSString *itemCode;
@property (nullable, nonatomic, copy) NSString *json;
@property (nullable, nonatomic, copy) NSString *metaData;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *p3rdCategory;
@property (nullable, nonatomic, copy) NSString *pid;
@property (nullable, nonatomic, copy) NSNumber *pPrice;
@property (nullable, nonatomic, copy) NSNumber *pUpdateDate;
@property (nullable, nonatomic, copy) NSString *quantity;
@property (nullable, nonatomic, copy) NSString *storeId;
@property (nullable, nonatomic, copy) NSString *subCategoryType;
@property (nullable, nonatomic, copy) NSString *subCateNameId;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *age;
@property (nullable, nonatomic, copy) NSString *discountprice;

@end

NS_ASSUME_NONNULL_END
