//
//  CX_Products+CoreDataProperties.m
//  NowFloats
//
//  Created by SRINIVASULU on 27/03/17.
//  Copyright © 2017 CX. All rights reserved.
//

#import "CX_Products+CoreDataProperties.h"

@implementation CX_Products (CoreDataProperties)

+ (NSFetchRequest<CX_Products *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CX_Products"];
}

@dynamic addToCart;
@dynamic createdById;
@dynamic favourite;
@dynamic imageUrl;
@dynamic itemCode;
@dynamic json;
@dynamic name;
@dynamic pid;
@dynamic pPrice;
@dynamic pUpdateDate;
@dynamic quantity;
@dynamic storeId;
@dynamic subCateNameId;
@dynamic type;
@dynamic metaData;

@end
