//
//  SDViewController.m
//  SDForms
//
//  Created by Rafal Kwiatkowski on 13.08.2014.
//  Copyright (c) 2014 Snowdog sp. z o.o. All rights reserved.
//

#import "SDViewController.h"
#import "SDForms.h"

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *salary;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSNumber *hp;
@property (nonatomic, strong) NSNumber *isStudent;

@end

@implementation Person

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@\nsurname:%@\nage:%@\nsex:%@\nsalary:%@\ndob:%@\nbio:%@\nhp:%@\nisStudent:%@", self.name, self.surname, self.age, self.sex, self.salary, self.dateOfBirth, self.bio, self.hp, self.isStudent];
}

@end

@interface SDViewController () <SDFormFieldCustomizationDelegate, SDFormDelegate, SDFormDataSource>

@property (nonatomic, strong) SDForm *form;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSArray *section1Fields;
@property (nonatomic, strong) NSArray *section2Fields;

@end

@implementation SDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped:)];
    self.navigationItem.rightBarButtonItem = save;
    
    [self initFields];
    
    [self.form reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)formattedValueForField:(SDFormField *)field
{
    if ([field.name isEqualToString:@"picker1"]) {
        SDPickerField *pickerField = (SDPickerField *)field;
        NSInteger index = [pickerField indexOfSelectedItemInComponent:0];
        NSString *title = [pickerField itemAtIndex:index inComponent:0];
        return [NSString stringWithFormat:@"%ld. %@", index + 1, title];
    } else if ([field.name isEqualToString:@"selection1"]) {
        NSInteger i = 0;
        SDItemSelectionField *selectionField = (SDItemSelectionField *)field;
        NSString *title;
        if (selectionField.selectedIndexes.count > 0) {
            for (NSNumber *number in selectionField.selectedIndexes) {
                NSString *item = [selectionField.items objectAtIndex:number.integerValue];
                if (i > 0) {
                    title = [NSString stringWithFormat:@"%@, %@", title, item];
                } else {
                    title = [NSString stringWithFormat:@"%@", item];
                }
                i++;
            }
        } else {
            title = @"( ͡° ͜ʖ ͡°)";
        }
        return title;
    }
    return nil;
}

- (void)saveButtonTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Person" message:[NSString stringWithFormat:@"%@", self.person] /*[NSString stringWithFormat:@"name:%@; surname:%@; salary:%@", self.person.name, self.person.surname, self.person.salary]*/ delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (UIViewController *)viewControllerForForm:(SDForm *)form
{
    return self;
}

- (void)form:(SDForm *)form didSelectFieldAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select field in section: %ld row: %ld", indexPath.section, indexPath.row);
}

- (NSInteger)numberOfSectionsForForm:(SDForm *)form
{
    return 2;
}

- (NSInteger)form:(SDForm *)form numberOfFieldsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.section1Fields.count;
    } else {
        return self.section2Fields.count;
    }
}

- (NSString *)form:(SDForm *)form titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Section 1";
    } else {
        return @"Section 2";
    }
}

- (NSString *)form:(SDForm *)form titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"End of section 1";
    } else {
        return nil;
    }
}

- (CGFloat)form:(SDForm *)form heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    } else {
        return 30.0;
    }
}

- (CGFloat)form:(SDForm *)form heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    } else {
        return 0.0;
    }
}

- (UIView *)form:(SDForm *)form viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)form:(SDForm *)form viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (SDFormField *)form:(SDForm *)form fieldForRow:(NSInteger)row inSection:(NSInteger)section
{
    if (section == 0) {
        SDFormField *field = [self.section1Fields objectAtIndex:row];
        return field;
    } else {
        SDFormField *field = [self.section2Fields objectAtIndex:row];
        return field;
    }
}

- (void)initFields
{
    self.person = [[Person alloc] init];
    self.person.name = @"John";
    self.person.surname = @"Smith";
    self.person.salary = @3000;
    self.person.dateOfBirth = [[NSDate date] dateByAddingTimeInterval:(3600 * 24 * 365 * 25)];
    self.person.age = @25;
    self.person.bio = @"There was a boy";
    self.person.hp = @70;
    self.person.isStudent = @YES;
    
    self.form = [[SDForm alloc] initWithTableView:self.tableView];
    self.form.delegate = self;
    self.form.dataSource = self;
	
    SDTextFormField *name = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"name"];
    name.title = @"Name";
    name.placeholder = @"Name";
    name.cellType = SDTextFormFieldCellTypeTextAndLabel;
    
    SDTextFormField *surname = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"surname"];
    surname.title = @"Surname";
    surname.placeholder = @"Surname";
    surname.cellType = SDTextFormFieldCellTypeTextAndLabel;
    
    SDTextFormField *password = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"password"];
    password.placeholder = @"Password";
    password.value = @"P@ssw0rd";
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.secure = YES;
    
    SDTextFormField *age = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"age"];
    age.placeholder = @"Age";
    age.valueType = SDFormFieldValueTypeInt;
    
    SDPickerField *sex = [[SDPickerField alloc] init];
    sex.name = @"sex";
    sex.title = @"Sex";
    [sex setItems:@[@[@"Male", @"Female", @"Other"]]];
    [sex setValues:@[@[@"male", @"female", @"other"]]];
    sex.relatedObjects = @[self.person];
    sex.relatedPropertyKeys = @[@"sex"];
    [sex selectItem:1 inComponent:0];
    
    SDTextFormField *salary = [[SDTextFormField alloc] initWithObject:self.person relatedPropertyKey:@"salary"];
    salary.placeholder = @"Salary";
    salary.valueType = SDFormFieldValueTypeDouble;
    
    SDLabelField *label = [[SDLabelField alloc] init];
    label.title = @"Time worked";
    label.value = @"5h";
    
    SDMultilineTextField *bio = [[SDMultilineTextField alloc] init];
    bio.value = bio.relatedObject = self.person;
    bio.relatedPropertyKey = @"bio";
    
    SDDatePickerField *dob = [[SDDatePickerField alloc] initWithObject:self.person relatedPropertyKey:@"dateOfBirth"];
    dob.title = @"Date of birth";
    dob.value = [NSDate date];
    dob.datePickerMode = UIDatePickerModeDateAndTime;
    
    SDSliderField *hp = [[SDSliderField alloc] initWithObject:self.person relatedPropertyKey:@"hp"];
    hp.title = @"HP";
    hp.min = 0.0;
    hp.max = 100.0;
    hp.step = 10.0;
    
    SDSwitchField *isStudent = [[SDSwitchField alloc] initWithObject:self.person relatedPropertyKey:@"isStudent"];
    isStudent.title = @"Is student";
    
    self.section1Fields = @[name, surname, password, age, sex, salary, label, bio, dob, hp, isStudent];
    
    
    SDPickerField *picker1 = [[SDPickerField alloc] init];
    picker1.formatDelegate = self;
    picker1.name = @"picker1";
    picker1.title = @"Picker 1";
    [picker1 setItems:@[@[@"Option 1", @"Option 2", @"Option 3"]]];
    [picker1 selectItem:2 inComponent:0];
    
    SDItemSelectionField *selection = [[SDItemSelectionField alloc] init];
    selection.formatDelegate = self;
    selection.title = @"Selection 1";
    selection.name = @"selection1";
    selection.multiChoice = YES;
    selection.presentingMode = SDFormFieldPresentingModePush;
    [selection setItems:@[@"Option 1", @"Option 2", @"Option 3", @"Option 4"]];
    [selection setSelectedIndexes:[@[@0] mutableCopy]];
    
    SDDatePickerField *hired = [[SDDatePickerField alloc] init];
    hired.title = @"Hired";
    hired.value = [NSDate date];
    hired.datePickerMode = UIDatePickerModeDateAndTime;
    
    SDButtonField *submit = [[SDButtonField alloc] init];
    submit.title = @"Submit";
    
    self.section2Fields = @[picker1, selection, hired, submit];
}

@end
