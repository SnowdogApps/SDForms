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
@property (nonatomic, readonly) NSString *formattedDOB;
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

- (NSString *) formattedDOB
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd MMM yyyy";
    return [NSString stringWithFormat:@"%@", [formatter stringFromDate:self.dateOfBirth]];;
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
    NSLog (@"VC frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog (@"TableView frame: %@", NSStringFromCGRect(self.tableView.frame));
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonTapped:)];
    self.navigationItem.rightBarButtonItem = save;
    
    [self initFields];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog (@"After layout VC frame: %@", NSStringFromCGRect(self.view.frame));
    NSLog (@"After layout TableView frame: %@", NSStringFromCGRect(self.tableView.frame));
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
    sex.enabled = NO;
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
    bio.relatedObject = self.person;
    bio.relatedPropertyKey = @"bio";
    
    SDDatePickerField *dob = [[SDDatePickerField alloc] initWithObject:self.person relatedPropertyKey:@"dateOfBirth" formattedValueKey:@"formattedDOB"];
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
    
    SDMultilineTextField *autoHeightText = [[SDMultilineTextField alloc] init];
    autoHeightText.editable = NO;
    autoHeightText.automaticHeight = YES;
    autoHeightText.value = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. \
        \n\nNullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi.\
        \n\nNam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh.\
        \n\nDonec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien. Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestibulum volutpat pretium libero. Cras id dui. Aenean ut";
    
    SDButtonField *submit = [[SDButtonField alloc] init];
    submit.title = @"Submit";
    
    self.section2Fields = @[picker1, selection, hired, autoHeightText, submit];
}

@end
