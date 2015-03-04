//
//  AddressBookHelper.swift
//  Wildcard
//
//  Created by Samuel Beek on 04-03-15.
//  Copyright (c) 2015 Samuel Beek. All rights reserved.
//

import AddressBook
import AddressBookUI


class Contact {
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var jobTitle: String?
}

// Adds a contact to the AddressBook
func addToAddressBook(contact: Contact){
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }
    
    let stat = ABAddressBookGetAuthorizationStatus()
    switch stat {
    case .Denied, .Restricted:
        println("no access to addressbook")
    case .Authorized, .NotDetermined:
        var err : Unmanaged<CFError>? = nil
        var adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            println(err)
            return
        }
        ABAddressBookRequestAccessWithCompletion(adbk) {
            (granted:Bool, err:CFError!) in
            if granted {
                var newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
                var success:Bool = false
                
                //Updated to work in Xcode 6.1
                var error: Unmanaged<CFErrorRef>? = nil
                //Updated to error to &error so the code builds in Xcode 6.1
                if(contact.firstName != nil){
                    success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, contact.firstName, &error)
                }
                
                if(contact.lastName != nil){
                    success = ABRecordSetValue(newContact, kABPersonLastNameProperty, contact.lastName, &error)
                }
                
                if(contact.jobTitle) {
                    success = ABRecordSetValue(newContact, kABPersonJobTitleProperty, contact.jobTitle, &error)
                }
                
                if(contact.phoneNumber != nil) {
                    let propertyType: NSNumber = kABMultiStringPropertyType
                    
                    var phoneNumbers: ABMutableMultiValueRef =  createMultiStringRef()
                    var phone = ((user.phoneNumber as String).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString)
                    
                    ABMultiValueAddValueAndLabel(phoneNumbers, phone, kABPersonPhoneMainLabel, nil)
                    success = ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumbers, &error)
                    
                    
                }
                
                success = ABRecordSetValue(newContact, kABPersonNoteProperty, "added via wildcard - getwildcard.co", &error)
                success = ABAddressBookAddRecord(adbk, newContact, &error)
                success = ABAddressBookSave(adbk, &error)

                println("Saving addressbook successful? \(success)")
                
            } else {
                println(err)
            }
        }
    }
    
    
    
}
