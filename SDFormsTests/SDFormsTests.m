//
//  SDFormsTests.m
//  SDFormsTests
//
//  Created by Rafal Kwiatkowski on 25.03.2015.
//  Copyright (c) 2015 Snowdog sp. z o.o. All rights reserved.
//

#import <Kiwi.h>
#import "TestClass.h"
#import "SDForms.h"

SPEC_BEGIN(SDFormsSpec)

describe(@"SDPickerField", ^{
    
    context(@"when updating value", ^{
        __block SDPickerField *pickerField;
        __block TestClass *testObject;
        
        beforeAll(^{
            testObject = [[TestClass alloc] init];
            testObject.value = @"value";
            testObject.formattedValue = @"Value";
            
            pickerField = [[SDPickerField alloc] initWithObject:testObject relatedPropertyKey:@"value" formattedValueKey:@"formattedValue" settableFormattedValueKey:@"settabeFormattedValue"];
        });
        
        it(@"sets object values as own values", ^{
            [[pickerField.value should] equal:@"value"];
            [[pickerField.formattedValue should] equal:@"Value"];
        });
        
        
        
        afterAll(^{
            testObject = nil;
            pickerField = nil;
        });
    });
    
});

SPEC_END