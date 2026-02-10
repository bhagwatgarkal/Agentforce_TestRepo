/****************************************************************************************
Name            : SLTC_Event_CallCampaignEvent_Test 
Author          : Ganesh Bora
Created Date    : 10/03/2023
Last Mod Date   : 7 July 2023
Last Mod By     : Ganesh Bora
NICC Reference  : NICC-#########
Description     : Test Class for SLTC_Event_CallCampaignEvent
:  
******************************************************************************************/
@isTest 
private class SLTC_Event_CallCampaignEvent_Test 
{
    // ======================================================================================================================================= 
    // = CREATE TEST DATA
    // ======================================================================================================================================= 
    @testSetup static void createTestData() 
    {        
    }
    
    // =======================================================================================================================================
    // = TEST METHOD 1: Call Create Account Campaign event flow
    // =======================================================================================================================================    
    @isTest static void callCampaignEventTest() 
    {   
        //create Account
        List<Account> accountList = SLTC_TestDataFactory.createAccounts('SLTC','AccountTest','MDM Approved','SLTC_Property','Customer',1);
        INSERT accountList;
        
        Id AccountId = accountList[0].id;
        Account updateAcc = [Select Id,Amadeus_BP_ID__c from Account where Id =:AccountId  ORDER BY CreatedDate DESC limit 1];
        updateAcc.Amadeus_BP_ID__c = '56329';
        update updateAcc;
        
        //create Contact
        List<Contact> contactList=SLTC_TestDataFactory.createcontact('SLTC Account Test','Contact',accountList[0].id,1);
        INSERT contactList;
        
        //create Opportunity
        List<Opportunity> opportunityList = SLTC_TestDataFactory.createopportunity('Initial Interest','New Business', accountList[0], 1, 'SLTC_Opportunity');
       INSERT opportunityList;
        
        
        
        //create Proposal 
        Apttus_Proposal__Proposal__c proposal= SLTC_TestDataFactory.createProposal(accountList[0].id, contactList[0].id,opportunityList[0].id,'Proposal'); 
        INSERT proposal;
        
        Id proposalId1 = proposal.id;
        Apttus_Proposal__Proposal__c updateprop1 = [Select Id,Apttus_Proposal__Opportunity__c from Apttus_Proposal__Proposal__c where Id =:proposalId1  ORDER BY CreatedDate DESC limit 1];
        updateprop1.Apttus_Proposal__Opportunity__c = opportunityList[0].id;
        update updateprop1;
        
        
        // create HI Product
        List<Product2> productListHI= SLTC_TestDataFactory.createProduct('HI -',1);
        INSERT productListHI;
        
        Apttus_Proposal__Proposal_Line_Item__c ProposalLineItemHI = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Product__c = productListHI[0].id,
            Apttus_Proposal__Proposal__c = proposal.id
        );
        INSERT ProposalLineItemHI;
        
         // create ME Product
        List<Product2> productListME= SLTC_TestDataFactory.createProduct('ME -',1);
        INSERT productListME;
        
        Apttus_Proposal__Proposal_Line_Item__c ProposalLineItemME = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Product__c = productListME[0].id,
            Apttus_Proposal__Proposal__c = proposal.id
        );
        INSERT ProposalLineItemME;
        
         // create BI Product
        List<Product2> productListBI= SLTC_TestDataFactory.createProduct('BI -',1);
        INSERT productListBI;
        
        Apttus_Proposal__Proposal_Line_Item__c ProposalLineItemBI = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Product__c = productListBI[0].id,
            Apttus_Proposal__Proposal__c = proposal.id
        );
        INSERT ProposalLineItemBI;
        
        //create  Affilations
        List<Account> accountList1 = SLTC_TestDataFactory.createAccounts('SLTC','AccountTestPartner','MDM Approved','Partner_Account','Customer',1);
        INSERT accountList1;
        
        Id AccountId1 = accountList1[0].id;
        Account updateAcc1 = [Select Id,Amadeus_BP_ID__c from Account where Id =:AccountId1  ORDER BY CreatedDate DESC limit 1];
        updateAcc1.Amadeus_BP_ID__c = '56327';
        update updateAcc1;
        
        Account getTestCorporateAccount=[SELECT Id FROM Account WHERE Name LIKE '%AccountTestPartner' ];
        Account getTestPropertyAccount=[SELECT Id FROM Account WHERE Name LIKE '%AccountTest' ];
        
        List<SLTC_Account_Affiliation__c> accAffReturnList= SLTC_TestDataFactory.createAccountAffiliation(getTestCorporateAccount.Id,getTestPropertyAccount.Id,'Management Company',TRUE,1,NULL);
        INSERT accAffReturnList;
        
        //create Asset LineItem
        Apttus_Config2__AssetLineItem__c AssetLineItem = new Apttus_Config2__AssetLineItem__c(
            Name='SLTC Account Test',
            Apttus_QPConfig__ProposalId__c= proposal.id,
            Apttus_Config2__ProductId__c= productListBI[0].id
        );
        INSERT AssetLineItem;
        
        
        
        
        
        //Call Campaign Event
        //List<ID> proposalid = new List<ID>{proposal.ID};
        SLTC_Event_CallCampaingEvent.publishAccountCampaignEvent(proposal.ID);
        
        
        Test.startTest();
        Test.getEventBus().deliver();
       
        System.assertEquals(1,[select count() from SLTC_Account_Captured_Event__c where EventType__c = 'Create Account Campaign']);
        
        Test.stopTest();
    }
    // =======================================================================================================================================
    // = TEST METHOD 1: Call Create Account Campaign event flow
    // =======================================================================================================================================    
    @isTest static void callCampaignEventTest2() 
    {   
        // CREATE TEST ACCOUNT RECORD
        Test.startTest();
        //create Account
        List<Account> accountList = SLTC_TestDataFactory.createAccounts('SLTC','AccountTest','MDM Rejected','SLTC_Property','Customer',1);
        INSERT accountList;
        //create Contact
        List<Contact> contactList=SLTC_TestDataFactory.createcontact('SLTC Account Test','Contact',accountList[0].id,1);
        INSERT contactList;
        //create Opportunity
        //List<Opportunity> opportunityList = SLTC_TestDataFactory.createopportunity('Customer Validation','New Business', accountList[0], 1, 'SLTC_Opportunity');
        List<Opportunity> opportunityList = SLTC_TestDataFactory.createopportunity('Initial Interest','New Business', accountList[0], 1, 'SLTC_Opportunity');
        INSERT opportunityList;
        
        //create Proposal 
        Apttus_Proposal__Proposal__c proposal= SLTC_TestDataFactory.createProposal(accountList[0].id, contactList[0].id,opportunityList[0].id,'Proposal'); 
        INSERT proposal;
        
        
        // create Product
        List<Product2> productList= SLTC_TestDataFactory.createProduct('GDS -',1);
        INSERT productList;
        
        Apttus_Proposal__Proposal_Line_Item__c ProposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Product__c = productList[0].id,
            Apttus_Proposal__Proposal__c = proposal.id
        );
        INSERT ProposalLineItem;
        
        //create  Affilations
        List<Account> accountList1 = SLTC_TestDataFactory.createAccounts('SLTC','AccountTestPartner','MDM Rejected','Partner_Account','Customer',1);
        INSERT accountList1;
        
        Account getTestCorporateAccount=[SELECT Id FROM Account WHERE Name LIKE '%AccountTestPartner' ];
        Account getTestPropertyAccount=[SELECT Id FROM Account WHERE Name LIKE '%AccountTest' ];
        
        List<SLTC_Account_Affiliation__c> accAffReturnList= SLTC_TestDataFactory.createAccountAffiliation(getTestCorporateAccount.Id,getTestPropertyAccount.Id,'Management Company',TRUE,1,NULL);
        INSERT accAffReturnList;
        
        //create Asset LineItem
        Apttus_Config2__AssetLineItem__c AssetLineItem = new Apttus_Config2__AssetLineItem__c(
            Name='SLTC Account Test',
            Apttus_QPConfig__ProposalId__c= proposal.id,
            Apttus_Config2__ProductId__c= productList[0].id
        );
        INSERT AssetLineItem;
        
        Id AccountId = accountList[0].id;
        Account updateAcc = [Select Id,Amadeus_BP_ID__c from Account where Id =:AccountId  ORDER BY CreatedDate DESC limit 1];
        updateAcc.CurrencyIsoCode = 'INR';
        update updateAcc;
        
        //Call Campaign Event
        //List<ID> proposalid = new List<ID>{proposal.ID};
        SLTC_Event_CallCampaingEvent.publishAccountCampaignEvent(proposal.ID);
        
        
        
        Test.getEventBus().deliver();
        
        System.assertEquals(0,[select count() from SLTC_Account_Captured_Event__c where EventType__c = 'Create Account Campaign']);
        
        Test.stopTest();
    }
    @isTest static void testInvalidEvent() {
        // CREATE TEST ACCOUNT RECORD
        Test.startTest();
        List<AccountEvent__e> liste = new List<AccountEvent__e>();
        
        AccountEvent__e accountEvent = new AccountEvent__e();
        //Create Platform Event
        liste.add(accountEvent);
        
        //Publish Platform Event
        SLTC_Event_CommonUtils.PublishAccountplatformEvent (liste,'SLTC_Event_CampaignAccount','Campaign');
        
        Test.getEventBus().deliver();
        System.assertEquals(0,[select count() from SLTC_Account_Captured_Event__c where EventType__c = 'Create Account Assetlines']);  
        
        Test.stopTest();
    }
}