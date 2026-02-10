/****************************************************************************************
Name            : SLTC_Event_CommonUtils_Test 
Author          : Ganesh Bora
Created Date    : 11/25/2022
Last Mod Date   : 12/02/2022
Last Mod By     : Ganesh Bora
NICC Reference  : NICC-#########
Description     : Test Class for SLTC_Event_CommonUtils
:  
******************************************************************************************/
@isTest 
private class SLTC_Event_CommonUtils_Test 
{
    // ======================================================================================================================================= 
    // = Get Parent Affilations TEST DATA (2)
    // ======================================================================================================================================= 
    @isTest
    public static void CheckCommonUtilsTest() 
    {        
        // CREATE TEST RECORDS
        Test.startTest();
        
        //Create Account
        List<Account> accountList = SLTC_TestDataFactory.createAccounts('SLTC','AccountTest','MDM Approved','SLTC_Property','Customer',1);
        accountList[0].TC_BID__C = '23456';
        accountList[0].Amadeus_BP_ID__c = '23456';
        INSERT accountList;
        
        //Create Contact
        List<Contact> contactList=SLTC_TestDataFactory.createcontact('SLTC Account Test','Contact',accountList[0].id,1);
        INSERT contactList;
        
        //Create Opportunity
        List<Opportunity> opportunityList = SLTC_TestDataFactory.createopportunity('Initial Interest','New Business', accountList[0], 1, 'SLTC_Opportunity');
        INSERT opportunityList;
        
        // Create Product
        List<Product2> productListHI= SLTC_TestDataFactory.createProduct('HI-',3);
        INSERT productListHI;
        
        // Create Product
        List<Product2> productListBI= SLTC_TestDataFactory.createProduct('BI-',3);
        INSERT productListBI;
        
        // Create Product
        List<Product2> productListME= SLTC_TestDataFactory.createProduct('ME- GDS',3);
        productListME[0].Metasearch_Products__c= true;
        INSERT productListME;
        
        //Create GDS record
        Product2 gdsValue = new Product2(
            Name = 'GDS Test',
            Family = 'Travel Seller Media'
            
        );
        INSERT gdsValue;
        
        //Create Proposal 
        Apttus_Proposal__Proposal__c proposal= SLTC_TestDataFactory.createProposal(accountList[0].id, contactList[0].id,opportunityList[0].id,'Proposal'); 
        INSERT proposal;
        
        //Create  Affilations
        List<Account> accountList1 = SLTC_TestDataFactory.createAccounts('SLTC','AccountTestPartner','MDM Approved','Partner_Account','Customer',1);
        INSERT accountList1;
        
        Account getTestCorporateAccount=[SELECT Id FROM Account WHERE Name LIKE '%AccountTestPartner' ];
        Account getTestPropertyAccount=[SELECT Id FROM Account WHERE Name LIKE '%AccountTest' ];
        
        List<SLTC_Account_Affiliation__c> accAffReturnList= SLTC_TestDataFactory.createAccountAffiliation(getTestCorporateAccount.Id,getTestPropertyAccount.Id,'Management Company',TRUE,1,NULL);
        INSERT accAffReturnList;
        
        //Create Proposal Line Item 
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemListHI=SLTC_TestDataFactory.createProposalLineItem(proposal.id, productListHI,'New');
        INSERT proposalLineItemListHI;
        
        //Create Proposal Line Item 
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemListBI=SLTC_TestDataFactory.createProposalLineItem(proposal.id, productListBI,'New');
        INSERT proposalLineItemListBI;
        
        //Create Proposal Line Item 
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemListME=SLTC_TestDataFactory.createProposalLineItem(proposal.id, productListME,'New');
        INSERT proposalLineItemListME;
        
        //Create Group
        pse__Grp__c groups = new pse__Grp__c(
            Name = 'RES'
            //pse__Group_Name_Chain__c = getgroups[0].pse__Group_Name_Chain__c,
            //pse__Group_Head__c = getgroups[0].pse__Group_Head__c,
            //pse__Top_Level_Group__c=getgroups[0].pse__Top_Level_Group__c,
            //pse__Parent_Group__c = getgroups[0].pse__Parent_Group__c
        );
        INSERT groups;
        
        //Create Project
        pse__Proj__c projectItem = new pse__Proj__c(
            Name='SLTC ProjectItem Test',
            pse__Account__c=accountList[0].id,
            Customer_Project_Contact__c = contactList[0].id,
            pse__Group__c = groups.id
        );
        INSERT projectItem;
        
        //Create Asset Line Item
        Apttus_Config2__AssetLineItem__c AssetLineItemHI = new Apttus_Config2__AssetLineItem__c(
            Name='SLTC AssetLineItem Test HI',
            Apttus_QPConfig__ProposalId__c= proposal.id,
            Apttus_Config2__ShipToAccountId__c = accountList[0].id,
            Apttus_Config2__Description__c = 'test',
            Apttus_Config2__BillToAccountId__c = accountList[0].id, 
            Apttus_Config2__ProductType__c = 'Subscription',
            Apttus_Config2__ProductId__c= productListHI[0].id,
            Apttus_Config2__OptionId__c = productListHI[0].id,
            SLTC_Zuora_Subscription_Number__c = 'A-S00007919'
        );
        INSERT AssetLineItemHI;
        
        //Create Asset Line Item2
        Apttus_Config2__AssetLineItem__c AssetLineItemBI = new Apttus_Config2__AssetLineItem__c(
            Name='SLTC AssetLineItem Test BI', 
            Apttus_QPConfig__ProposalId__c= proposal.id,
            Apttus_Config2__ShipToAccountId__c = accountList[0].id,
            Apttus_Config2__Description__c = 'test',
            Apttus_Config2__BillToAccountId__c = accountList[0].id, 
            Apttus_Config2__ProductType__c = 'Subscription',
            Apttus_Config2__ProductId__c= productListBI[0].id,
            Apttus_Config2__OptionId__c = productListBI[0].id,
            SLTC_Zuora_Subscription_Number__c = 'A-S00007919'
        );
        INSERT AssetLineItemBI;
        
        //Create Asset Line Item3
        Apttus_Config2__AssetLineItem__c AssetLineItemME = new Apttus_Config2__AssetLineItem__c(
            Name='SLTC AssetLineItem Test ME',
            Apttus_QPConfig__ProposalId__c= proposal.id,
            Apttus_Config2__ShipToAccountId__c = accountList[0].id,
            Apttus_Config2__Description__c = 'test',
            Apttus_Config2__BillToAccountId__c = accountList[0].id, 
            Apttus_Config2__ProductType__c = 'Subscription',
            Apttus_Config2__ProductId__c= productListME[0].id,
            Apttus_Config2__OptionId__c = productListME[0].id,
            SLTC_Zuora_Subscription_Number__c = 'A-S00007919'
        );
        INSERT AssetLineItemME;
        
        Id AccId = accountList[0].id;
        Account accRec = [Select Id,SLTC_Credit_Hold__c,Not_In_GDS__c from Account  where Id =: AccId  limit 1];
        Id ProposalId = proposal.id;
        Id AccountId = accountList[0].id;
        boolean creditHold = accRec.SLTC_Credit_Hold__c;
        boolean GDS = accRec.Not_In_GDS__c;
        
        // Test Get Products 
        string getProducts = SLTC_Event_CommonUtils.getProducts(ProposalId);
        System.assert(getProducts != '');
        
        // Test Get Parent Affilations 
        string getParentAffilations = SLTC_Event_CommonUtils.getParentAffilations(AccountId);
        System.assert(getParentAffilations != '');
        
        // Test Get Parent Affilations 
        string getChildAffilations = SLTC_Event_CommonUtils.getChildAffilations(AccountId);
        System.assert(getChildAffilations != '');
        
        // Test Get ShiptoBilltoAccount
        string getShiptoBilltoAccount = SLTC_Event_CommonUtils.getShiptoBilltoAccountDetails(AccountId);
        System.assert(getShiptoBilltoAccount != '');
        
        // Test Get Project 
        string getProject = SLTC_Event_CommonUtils.getProjects(ProposalId);
        System.assert(getProject != '');
        
        // Test Get HI Products 
        List<Apttus_Config2__AssetLineItem__c> getHIProducts = SLTC_Event_CommonUtils.getHIProducts(ProposalId);
        System.assert(getHIProducts.size() != 0);
        
        // Test Get credit Hold 
        string FormatCreditHoldValue = SLTC_Event_CommonUtils.FormatCreditHoldValue(creditHold);
        System.assert(FormatCreditHoldValue != '');
        
        // Test Get GDS 
        Decimal FormatGdsValue = SLTC_Event_CommonUtils.FormatGdsValue(GDS);
        System.assert(FormatGdsValue != null);
        
        // Test Get AssetLines 
        string getAssetLinesList = SLTC_Event_CommonUtils.getAssetLinesList(ProposalId);
        System.assert(getAssetLinesList != '');
        
        // Test Get AssetLines 
        map<string,list<SLTC_Event_CommonUtils.AssetLine>> groupedAssetLines = new map<string,list<SLTC_Event_CommonUtils.AssetLine>>();
        groupedAssetLines = SLTC_Event_CommonUtils.getAssetLinesByProductCode(ProposalId);
        System.assert(groupedAssetLines.size() != 0);
        Test.stopTest();
    }
    
    @isTest static void commonUtilsCreateAccTest() 
    {   
        // CREATE TEST RECORDS
        Test.startTest();
        //create Account
        List<Account> accountList = SLTC_TestDataFactory.createAccounts('SLTC','AccountTest','MDM Approved','SLTC_Property','Customer',1);
        accountList[0].TC_BID__C = '23456';
        accountList[0].Amadeus_BP_ID__c = '23456';
        INSERT accountList;
        
        //create Contact
        List<Contact> contactList=SLTC_TestDataFactory.createcontact('SLTC Account Test','Contact',accountList[0].id,1);
        INSERT contactList;
        
        //create Opportunity
        List<Opportunity> opportunityList = SLTC_TestDataFactory.createopportunity('Initial Interest','New Business', accountList[0], 1, 'SLTC_Opportunity');
        INSERT opportunityList;
        
        //new contactRoleList
        List<OpportunityContactRole> contactRoleList = SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Customer Project Contact');
        contactRoleList.addAll(SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Bill To'));
        contactRoleList.addAll(SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Sold To'));
        contactRoleList.addAll(SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Authorizer'));
        INSERT contactRoleList;
        
        //create Proposal 
        Apttus_Proposal__Proposal__c proposal= SLTC_TestDataFactory.createProposal(accountList[0].id, contactList[0].id,opportunityList[0].id,'Proposal'); 
        INSERT proposal;
        
        // create Product
        List<Product2> productList= SLTC_TestDataFactory.createProduct('HI-',3);
        INSERT productList;
        
        //create  Affilations
        List<Account> accountList1 = SLTC_TestDataFactory.createAccounts('SLTC','AccountTestPartner','MDM Approved','Partner_Account','Customer',1);
        accountList1[0].TC_BID__C = '234536';
        accountList1[0].Amadeus_BP_ID__c = '234536';
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
        
        //Agreement
        Apttus__APTS_Agreement__c agreement_data = SLTC_TestDataFactory.createAgreement(accountList[0].Id, opportunityList[0].Id, contactList[0].Id, proposal.Id,'Order_Form'); 
        agreement_data.Apttus__Status_Category__c = 'In Effect';
        agreement_data.Apttus__Status__c = 'Activated';
        INSERT agreement_data;
        
        //Create Order
        Apttus_Config2__Order__c Parent_order_data = SLTC_TestDataFactory.createApttusOrder(accountList[0].Id, opportunityList[0].Id, contactList[0].Id, proposal.Id,agreement_data.Id);
        insert Parent_order_data;
        
        Apttus_Config2__Order__c order_data = SLTC_TestDataFactory.createApttusOrder(accountList[0].Id, opportunityList[0].Id, contactList[0].Id, proposal.Id,agreement_data.Id);
        order_data.Apttus_Config2__OrderStartDate__c=Date.today();
        order_data.Apttus_Config2__ParentOrderId__c = Parent_order_data.Id;
        INSERT order_data;
        
        
        //Update Stage Name and opportunity
        Id optId = opportunityList[0].id;
        Opportunity OptRec = [Select Id,StageName from Opportunity  where Id =: optId limit 1];
        OptRec.StageName  = 'Closed Won';
        update OptRec;
        
        Test.getEventBus().deliver();
        
        System.assertEquals(1,[select count() from SLTC_Account_Captured_Event__c where EventType__c = 'Create Account']);
        
        Test.stopTest();
    }
    // =======================================================================================================================================
    // = TEST METHOD 2: 
    // ======================================================================================================================================= 
    @isTest static void testcommonUtilsInvalidEvent() {
        
        // CREATE TEST ACCOUNT RECORD
        Test.startTest();
        List<AccountEvent__e> liste = new List<AccountEvent__e>();
        
        AccountEvent__e accountEvent = new AccountEvent__e();
        //Create Platform Event
        liste.add(accountEvent);
        
        //Publish Platform Event
        SLTC_Event_CommonUtils.PublishAccountplatformEvent(liste,'SLTC_Event_CreateAccount','Create');
        
        Test.getEventBus().deliver();
        System.assertEquals(0,[select count() from SLTC_Account_Captured_Event__c where EventType__c = 'Create Account']);  
        
        Test.stopTest();
    }
    // =======================================================================================================================================
    // = TEST METHOD 2: Creating Testdata to call createAssetLineItem Platform event.
    // ======================================================================================================================================= 
    @isTest static void commonUtilsCreateAssetLineItemTest() 
    {      
        // CREATE TEST RECORDS
        Test.startTest();
        //create Account
        List<Account> accountList = SLTC_TestDataFactory.createAccounts('SLTC','Test','MDM Approved','SLTC_Property','Customer',1);
        accountList[0].TC_BID__C = '234536';
        accountList[0].Amadeus_BP_ID__c = '234536';
        INSERT accountList;
        
        system.debug(accountList);       
        //create Contact
        List<Contact> contactList=SLTC_TestDataFactory.createcontact('SLTC AssetLines Test','Contact',accountList[0].id,1);
        INSERT contactList;
        
        //create Opportunity
        List<Opportunity> opportunityList = SLTC_TestDataFactory.createopportunity('Initial Interest','New Business', accountList[0], 1, 'SLTC_Opportunity');
        INSERT opportunityList;
        
        Id LastOptyId = opportunityList[0].id;
        
        //new contactRoleList
        List<OpportunityContactRole> contactRoleList = SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Customer Project Contact');
        contactRoleList.addAll(SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Bill To'));
        contactRoleList.addAll(SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Sold To'));
        contactRoleList.addAll(SLTC_TestDataFactory.createOpportunityContactRole(opportunityList[0].Id, contactList[0].Id,'Authorizer'));
        INSERT contactRoleList;
        
        //create Proposal 
        Apttus_Proposal__Proposal__c proposal= SLTC_TestDataFactory.createProposal(accountList[0].id, contactList[0].id,opportunityList[0].id,'Proposal'); 
        INSERT proposal;
        
        
        //Agreement
        Apttus__APTS_Agreement__c agreement_data = SLTC_TestDataFactory.createAgreement(accountList[0].Id, opportunityList[0].Id, contactList[0].Id, proposal.Id,'Order_Form'); 
        agreement_data.Apttus__Status_Category__c = 'In Effect';
        agreement_data.Apttus__Status__c = 'Activated';
        INSERT agreement_data;
        
        //Create Order
        Apttus_Config2__Order__c Parent_order_data = SLTC_TestDataFactory.createApttusOrder(accountList[0].Id, opportunityList[0].Id, contactList[0].Id, proposal.Id,agreement_data.Id);
        insert Parent_order_data;
        
        Apttus_Config2__Order__c order_data = SLTC_TestDataFactory.createApttusOrder(accountList[0].Id, opportunityList[0].Id, contactList[0].Id, proposal.Id,agreement_data.Id);
        order_data.Apttus_Config2__OrderStartDate__c=Date.today();
        order_data.Apttus_Config2__ParentOrderId__c = Parent_order_data.Id;
        INSERT order_data;
        
        //Update Stage Name and opportunity
        Id optId = opportunityList[0].id;
        Opportunity OptRec = [Select Id,StageName,Zuora_Subscription_Number__c from Opportunity  where Id =: optId limit 1];
        OptRec.StageName  = 'Closed Won';
        update OptRec;
        
        // create Product
        List<Product2> productList= SLTC_TestDataFactory.createProduct('BI-',1);
        INSERT productList;
        Product2 Product = [Select Id,ProductCode from Product2 where Id =: productList[0].id  ORDER BY CreatedDate DESC limit 1];
        
        // create Option Product
        List<Product2> productListOption= SLTC_TestDataFactory.createProduct('BI -',1);
        INSERT productListOption;
        Product2 Products = [Select Id,ProductCode from Product2 where Id =: productListOption[0].id  ORDER BY CreatedDate DESC limit 1];
        
        //create Proposal Line Item 
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList=SLTC_TestDataFactory.createProposalLineItem(proposal.id, productList,'New');
        INSERT proposalLineItemList;
        
        // Add Product code for Options
        Id productId = productListOption[0].id;
        Product2 productRec = [Select Id,ProductCode from Product2  where Id =: productId  limit 1];
        productRec.ProductCode = 'BI-000019';
        update productRec;
        
        //Add AssetLineItem fields
        Apttus_Config2__AssetLineItem__c AssetLineItem = new Apttus_Config2__AssetLineItem__c( 
            Name='SLTC AssetLineItem Test',
            Apttus_QPConfig__ProposalId__c= proposal.id,
            SLTC_Related_Opportunity__c = opportunityList[0].id,
            Apttus_Config2__OptionId__c = productListOption[0].id,
            Apttus_Config2__ChargeType__c = 'Standard Price',
            Apttus_Config2__ProductId__c= productList[0].id
        );
        INSERT AssetLineItem;
        
        Id LastAssetId = AssetLineItem.id;
        Apttus_Config2__AssetLineItem__c assetLine = [Select Id,SLTC_Zuora_Subscription_Number__c from Apttus_Config2__AssetLineItem__c  where Id =: LastAssetId and SLTC_Related_Opportunity__c =:LastOptyId limit 1];
        assetLine.SLTC_Zuora_Subscription_Number__c = 'A-S00007919';
        update assetLine;
        
        
        //Update Subscription_Number
        Id optId1 = opportunityList[0].id;
        Opportunity OptRec1 = [Select Id,StageName,Zuora_Subscription_Number__c from Opportunity  where Id =: optId1 limit 1];
        OptRec1.Zuora_Subscription_Number__c = 'A-S00007919';
        update OptRec1;
        
        Test.getEventBus().deliver();
        
        System.assertEquals(1,[select count() from SLTCAssetCapturedEvent__c where EventType__c = 'Create Account Assetlines']);  
        
        // For Repush button on SLTC_Event_CreateAssetlines_Repush class
        OptRec1.Repush_Create_Assestline_Event_Date__c = Date.today();
        update OptRec1;
        
        Test.getEventBus().deliver();
        
        System.assertEquals(2,[select count() from SLTCAssetCapturedEvent__c where EventType__c = 'Create Account Assetlines']);
        
        Test.stopTest();
    }
    // =======================================================================================================================================
    // = TEST METHOD 2
    // ======================================================================================================================================= 
    @isTest static void testcommonUtilsAssetInvalidEvent() {
        // CREATE TEST ACCOUNT RECORD
        Test.startTest();
        List<AssetEvent__e> liste = new List<AssetEvent__e>();
        
        AssetEvent__e assetEvent = new AssetEvent__e();
        //Create Platform Event
        liste.add(assetEvent);
        
        //Publish Platform Event
        SLTC_Event_CommonUtils.PublishAssestPlatformEvent(liste,'SLTC_Event_CreateAssetlines','Create');
        
        Test.getEventBus().deliver();
        System.assertEquals(0,[select count() from SLTCAssetCapturedEvent__c where EventType__c = 'Create Account Assetlines']);  
        
        Test.stopTest();
    }
}