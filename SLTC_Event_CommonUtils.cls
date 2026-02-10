/*******************************************
Name : SLTC_Event_CommonUtils
Author : Ganesh Bora
Created Date : 23 Nov 2022
Last Mod Date : 7 July 2023
Last Mod By : Ganesh Bora
NICC Reference : 
Description : 
***********************************************************/
public class SLTC_Event_CommonUtils 
{
    //=============================
    // Publish AccountplatformEvent 
    //=============================
    public static void PublishAccountplatformEvent(list<AccountEvent__e> liste,String EventName,String Action)
    {   
        //Publish Platform Event
        List<Database.SaveResult> results = EventBus.publish(liste);
        List<DTS_Integration_Log__c> logs = new list<DTS_Integration_Log__c>();
        
        for (Database.SaveResult sr : results) 
        {
            DTS_Integration_Log__c log = new DTS_Integration_Log__c();
            log.Date_Time__c = system.now();
            log.Integration_Name__c = 'SLTC Boomi Platform Events';
            log.Integration_Status__c = 'Active';            
            if (sr.isSuccess())
            {
                log.Type__c = 'Success';
                log.Summary__c = 'Successfully Published Event '+ Action +' Account';
                log.Details__c = '';
                log.Issue_Severity__c = '4 - Minor'; 
                //AH_DTS_Integration_Logger.writeToDTSLog(system.now(), 'SLTC Boomi Platform Events', 'Active', 'Success', 'Successfully Published Event '+ Action +' Account', '','4 - Minor', UserInfo.getUserName(), EventName, 'Platform Event', 'Salesforce', true, false);
            }
            else 
            {
                for(Database.Error err : sr.getErrors()) 
                {
                    // AH_DTS_Integration_Logger.writeToDTSLog(system.now(), 'SLTC Boomi Platform Events', 'Active', 'Error', 'Error Publishing Platform Event '+ Action +' Account', err.getMessage(), '3 - Medium', UserInfo.getUserName(), EventName, 'Platform Event', 'Salesforce', true, false);
                    log.Type__c = 'Error';
                    log.Summary__c = 'Error Publishing Platform Event '+ Action +' Account';
                    log.Details__c = err.getMessage();
                    log.Issue_Severity__c = '3 - Medium'; 
                }
            }
            
            log.Job_Process_ID__c = UserInfo.getUserName(); 
            log.Job_Process_Name__c = EventName;
            log.Job_Process_Type__c = 'Platform Event';
            log.Host_Name_IP__c = 'Salesforce';    
            log.Requires_Business_Assistance_to_Resolve__c = true;
            log.Will_Resolve_Upon_Next_Execution__c = false;       
            
            logs.add(log);
            
        }
        insert logs;
    }
    
    
    //=============================
    // Publish AssestPlatformEvent  
    //=============================
    public static void PublishAssestPlatformEvent(list<AssetEvent__e> liste,String EventName,String Action)
    { 
        system.debug('EventName === > '+EventName);
        //Publish Platform Event
        List<Database.SaveResult> results = EventBus.publish(liste);
        List<DTS_Integration_Log__c> logs = new list<DTS_Integration_Log__c>();
        
        for (Database.SaveResult sr : results) 
        {
            DTS_Integration_Log__c log = new DTS_Integration_Log__c();
            log.Date_Time__c = system.now();
            log.Integration_Name__c = 'SLTC Boomi Platform Events';
            log.Integration_Status__c = 'Active';            
            if (sr.isSuccess())
            {
                log.Type__c = 'Success';
                log.Summary__c = 'Successfully Published Event '+ Action +' Asset lines';
                log.Details__c = '';
                log.Issue_Severity__c = '4 - Minor'; 
                //AH_DTS_Integration_Logger.writeToDTSLog(system.now(), 'SLTC Boomi Platform Events', 'Active', 'Success', 'Successfully Published Event '+ Action +' Asset lines', '', '4 - Minor', UserInfo.getUserName(), EventName, 'Platform Event', 'Salesforce', true, false);
            }
            else 
            {
                for(Database.Error err : sr.getErrors()) 
                {
                    log.Type__c = 'Error';
                    log.Summary__c = 'Error Publishing Platform Event '+ Action +' Asset lines';
                    log.Details__c = err.getMessage();
                    log.Issue_Severity__c = '3 - Medium'; 
                    // AH_DTS_Integration_Logger.writeToDTSLog(system.now(), 'SLTC Boomi Platform Events', 'Active', 'Error', 'Error Publishing Platform Event '+ Action +' Asset lines', err.getMessage(), '3 - Medium', UserInfo.getUserName(), EventName, 'Platform Event', 'Salesforce', true, false);
                }
            }
            
            log.Job_Process_ID__c = UserInfo.getUserName(); 
            log.Job_Process_Name__c = EventName;
            log.Job_Process_Type__c = 'Platform Event';
            log.Host_Name_IP__c = 'Salesforce';    
            log.Requires_Business_Assistance_to_Resolve__c = true;
            log.Will_Resolve_Upon_Next_Execution__c = false;       
            
            logs.add(log);
            
        }
         system.debug('logs === > '+logs);
        insert logs;
    }
    
    
    //=============================
    // Get Products from QuotesId
    //=============================
    public static string getProducts(ID proposalId)
    {
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalAndLineItems = [SELECT Id, 
                                                                             Apttus_Proposal__Product__c,
                                                                             Apttus_Proposal__Product__r.Name,
                                                                             Apttus_Proposal__Product__r.Family,
                                                                             Apttus_QPConfig__BillToAccountId__c,
                                                                             Apttus_QPConfig__ShipToAccountId__c,
                                                                             Apttus_QPConfig__ProductOptionId__c,
                                                                             Apttus_QPConfig__ChargeType__c,
                                                                             Apttus_Proposal__Description__c,
                                                                             Apttus_QPConfig__LineNumber__c,
                                                                             Apttus_QPConfig__OptionId__c,
                                                                             Apttus_QPConfig__ClassificationId__r.Name,
                                                                             Apttus_QPConfig__AttributeValueId__r.SLTC_Need_By_Date__c,
                                                                             Apttus_QPConfig__AttributeValueId__r.SLTC_Campaign__c  
                                                                             FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                                             where Apttus_Proposal__Proposal__c =:proposalId 
                                                                             and (Apttus_Proposal__Product__r.Name like '%GDS%' 
                                                                                  OR Apttus_Proposal__Product__r.Name like 'Single Media Agency' 
                                                                                  OR Apttus_Proposal__Product__r.Name like 'Single Media Subscription')
                                                                            ];
        
        
        Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> productLineMap = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
        
        for(Apttus_Proposal__Proposal_Line_Item__c pli : proposalAndLineItems)
        {
            String uniqueId = pli.Apttus_Proposal__Product__c + ':' + pli.Apttus_QPConfig__LineNumber__c;
            //Map of Product and Line Item
            if(productLineMap.containsKey(uniqueId))
            {
                List<Apttus_Proposal__Proposal_Line_Item__c> l = productLineMap.get(uniqueId);
                l.add(pli);
                productLineMap.put(uniqueId,l);
            } 
            else
            {
                List<Apttus_Proposal__Proposal_Line_Item__c> l = new List<Apttus_Proposal__Proposal_Line_Item__c>();
                l.add(pli);
                productLineMap.put(uniqueId,l);
            }
        }
        //create proposal object structure with products information
        proposalWrapper proposal = new proposalWrapper();
        proposal.proposalId = proposalId;
        proposal.products = new ProductWrapper();
        List<product> mediaProducts = new List<product>();
        
        for(String plId : productLineMap.KeySet()) 
        {
            Product p = new Product();
            p.lineOptions = new MAP<string,string>();
            MAP<string,channel> dummyChannels = new MAP<string,channel>();
            p.channels = new LIST<channel>();
            for(Apttus_Proposal__Proposal_Line_Item__c pli : productLineMap.get(plId)) 
            {
                if(p.Type == NULL)
                {
                    p.Type = pli.Apttus_Proposal__Product__r.Name; 
                    p.LineItemId = pli.Id;
                    p.ProductId = pli.Apttus_Proposal__Product__c;
                    p.BillToAccount = pli.Apttus_QPConfig__BillToAccountId__c;
                    p.ShipToAccount = pli.Apttus_QPConfig__ShipToAccountId__c;
                    p.Description = pli.Apttus_Proposal__Description__c;
                    p.CampaignNumber = String.valueOf(pli.Apttus_QPConfig__AttributeValueId__r.SLTC_Campaign__c);  
                    p.Need_By_Date = String.valueOf(pli.Apttus_QPConfig__AttributeValueId__r.SLTC_Need_By_Date__c);
                    
                }
                if(pli.Apttus_QPConfig__ProductOptionId__c == NULL) 
                {
                    string lineOption = pli.Apttus_QPConfig__ChargeType__c;
                    lineOption = lineOption.deleteWhitespace();
                    p.lineOptions.put(lineOption,pli.Id);
                }
                if(pli.Apttus_QPConfig__ProductOptionId__c != NULL) 
                {
                    string uniqueOptionId = pli.Apttus_QPConfig__ProductOptionId__c;
                    if(dummyChannels.containsKey(uniqueOptionId))
                    {
                        channel c = dummyChannels.get(uniqueOptionId);
                        string lineOption = pli.Apttus_QPConfig__ChargeType__c;
                        lineOption = lineOption.deleteWhitespace();
                        c.Data.put(lineOption,pli.Id);
                        dummyChannels.put(uniqueOptionId,c);
                    } 
                    else
                    {
                        channel c = new channel();
                        c.Name = pli.Apttus_Proposal__Description__c;
                        c.ProductOptionId = pli.Apttus_QPConfig__ProductOptionId__c;
                        c.Data = new MAP<string,string>();
                        string lineOption = pli.Apttus_QPConfig__ChargeType__c;
                        lineOption = lineOption.deleteWhitespace();
                        c.Data.put(lineOption,pli.Id);
                        dummyChannels.put(uniqueOptionId,c);
                    }
                }
                
            }
            
            for(String ChannelId : dummyChannels.KeySet()) 
            {
                channel c2 = dummyChannels.get(ChannelId);
                p.channels.add(c2);
            }
            mediaProducts.add(p);
        }
        proposal.products.mediaProducts = mediaProducts;
        proposal.products.metasearchProducts = getMEProducts(proposalId);
        proposal.products.channelManagerProducts = getCMProducts(proposalId);
        proposal.products.iHotelierProducts = getiHProducts(proposalId);
        proposal.products.BIProducts = getBIProducts(proposalId);
        
        
        return JSON.serialize(proposal);
    }
    
    //======================================
    //Get Parent Affilations
    //======================================
    public static string getParentAffilations(ID AccountId)
    {
        LIST <SLTC_Account_Affiliation__c> Account_Affiliation = [SELECT Id,                                                                  
                                                                  SLTC_Affiliation_Type__c,
                                                                  SLTC_Future_Date__c,
                                                                  SLTC_Active__c,
                                                                  SLTC_Account_Affliation__r.TC_BID__c,
                                                                  SLTC_Account__c,
                                                                  SLTC_Account__r.Amadeus_BP_ID__c
                                                                  FROM SLTC_Account_Affiliation__c
                                                                  where SLTC_Account_Affliation__c =:AccountId
                                                                  and SLTC_Active__c = true
                                                                  and SLTC_Account__r.Amadeus_BP_ID__c <> null
                                                                 ];
        List <Affilation> affilations = new List<Affilation>();
        for(SLTC_Account_Affiliation__c line : Account_Affiliation)
        {
            
            if(line.SLTC_Account__r.Amadeus_BP_ID__c == null)
            {
                return null;
            }
        }
        
        for(SLTC_Account_Affiliation__c af : Account_Affiliation)
        {
            Affilation a = new Affilation();
            a.Id = af.id;
            a.Type = af.SLTC_Affiliation_Type__c;
            a.Account = af.SLTC_Account__c;
            affilations.add(a);
        }
        return JSON.serialize(affilations);
    }
    
    //======================================
    //Get Parent Affilations new
    //======================================
    public static Map<String,String> getParentAffilationsInMap(List<Account> accountIdList)
    {
        Map<String,String> mapOfParentAffilations = new Map<String,String>();
        
        if(!accountIdList.isEmpty())
        {
            Map<String,List<SLTC_Account_Affiliation__c>> mapOfAffilations = new Map<String,List<SLTC_Account_Affiliation__c>>();
            for(SLTC_Account_Affiliation__c accountAffiliation : [SELECT Id,SLTC_Affiliation_Type__c,SLTC_Future_Date__c,
                                                                  SLTC_Account_Affliation__r.TC_BID__c,SLTC_Account__c,SLTC_Active__c 
                                                                  FROM SLTC_Account_Affiliation__c 
                                                                  where SLTC_Account_Affliation__c IN : accountIdList
                                                                  and SLTC_Active__c = true
                                                                  and SLTC_Account__r.Amadeus_BP_ID__c <> null
                                                                 ])
            {
                if(mapOfAffilations != null && mapOfAffilations.containsKey(accountAffiliation.SLTC_Account_Affliation__c))
                {
                    mapOfAffilations.get(accountAffiliation.SLTC_Account_Affliation__c).add(accountAffiliation);
                }
                else
                {
                    mapOfAffilations.put(accountAffiliation.SLTC_Account_Affliation__c, new List<SLTC_Account_Affiliation__c>{accountAffiliation});    
                }
            }
            
            for(String accId :mapOfAffilations.keySet())
            {
                List <Affilation> affilations = new List<Affilation>();
                for(SLTC_Account_Affiliation__c af :mapOfAffilations.get(accId))
                {
                    Affilation a = new Affilation();
                    a.Id = af.id;
                    a.Type = af.SLTC_Affiliation_Type__c;
                    a.Account = af.SLTC_Account__c;
                    affilations.add(a);
                }
                
                mapOfParentAffilations.put(accId,JSON.serialize(affilations));
                
            }
            
            return mapOfParentAffilations;
        }    
        return null;
    }
    
    //======================================
    //Get Child Affilations
    //======================================
    public static string getChildAffilations(ID AccountId)
    {
        
        LIST <SLTC_Account_Affiliation__c> Account_Affiliation = [SELECT Id,
                                                                  SLTC_Affiliation_Type__c,
                                                                  SLTC_Future_Date__c,
                                                                  SLTC_Account_Affliation__c,
                                                                  SLTC_Account_Affliation__r.TC_BID__c
                                                                  FROM SLTC_Account_Affiliation__c
                                                                  where SLTC_Account__c =:AccountId 
                                                                 ];
        
        List <Affilation> affilations = new List<Affilation>();
        for(SLTC_Account_Affiliation__c af : Account_Affiliation)
        {
            Affilation a = new Affilation();
            a.Id = af.id;
            a.Type = af.SLTC_Affiliation_Type__c;
            a.Account = af.SLTC_Account_Affliation__c;
            affilations.add(a);
        }
        return JSON.serialize(affilations);		
    }
    
    //======================================
    //Get Shipto Billto AccountDetails
    //======================================
    public static string getShiptoBilltoAccountDetails(ID AccountId)
    {
        LIST <Account> Account_Details = [select Id,TC_BID__c,Amadeus_BP_ID__c  from Account where Id =:AccountId ];
        
        List <AccDetails> accDetails = new List<AccDetails>();
        for(Account af : Account_Details)
        {
            AccDetails a = new AccDetails();
            a.insiteId = af.TC_BID__c;
            a.businessProcessId = af.Amadeus_BP_ID__c;
            accDetails.add(a);
        }
        return JSON.serialize(accDetails);		
    }
    
    
    
    //======================================
    //Get Projects
    //======================================
    public static string getProjects(ID AccountId)
    {
        
        LIST <pse__Proj__c> projects = [SELECT Id,
                                        Customer_Project_Contact__r.Name,
                                        Customer_Project_Contact__r.Title,
                                        Customer_Project_Contact__r.Phone,
                                        Customer_Project_Contact__r.Email,
                                        pse__Project_Manager__r.psa_report__Resource_Name__c
                                        FROM pse__Proj__c 
                                        where 
                                        pse__Account__c =: AccountId AND 
                                        pse__Group__r.Name = 'RES'
                                       ];
        
        
        List <project> ProjectsList = new List<Project>();
        for(pse__Proj__c pr : projects)
        {
            Project p = new Project();
            
            p.Name = pr.Customer_Project_Contact__r.Name;
            p.Phone = pr.Customer_Project_Contact__r.Phone;
            p.Title = pr.Customer_Project_Contact__r.Title;
            p.ResourceName = pr.pse__Project_Manager__r.psa_report__Resource_Name__c;
            p.Email = pr.Customer_Project_Contact__r.Email;
            
            ProjectsList.add(p);
        }
        return JSON.serialize(ProjectsList);
    }
    
    //======================================
    // Format Credit hold value in required type
    //======================================    
    public static string FormatCreditHoldValue(boolean SLTCcreditHold)
    {
        String CreditHold = '';
        if(SLTCcreditHold == null || SLTCcreditHold == False)
        {
            CreditHold = 'N';
        }
        else
        {
            CreditHold = 'Y';
        }
        return CreditHold;
    }
    
    //======================================
    // Format GDS value in required type
    //======================================       
    
    public static Decimal FormatGdsValue(boolean SLTCgds)
    {
        Decimal GDS = null;
        if(SLTCgds == null || SLTCgds == False)
        {
            GDS = 0;
        }
        else
        {
            GDS = 1;
        }
        return GDS;
    }
    
    
    // ========================================
    // Method to get Asset LineItem List having Product code like HI
    // ======================================== 
    
    public static List<Apttus_Config2__AssetLineItem__c> getHIProducts(Id proposalId)
    {
        
        List<Apttus_Config2__AssetLineItem__c> AssetLineItemList = [SELECT Id,
                                                                    Apttus_Config2__ShipToAccountId__c, 
                                                                    Apttus_Config2__Description__c,
                                                                    Apttus_Config2__BillToAccountId__c, 
                                                                    Apttus_Config2__ProductId__c,
                                                                    Apttus_Config2__ProductType__c,
                                                                    Apttus_Config2__ProductId__r.ProductCode
                                                                    FROM Apttus_Config2__AssetLineItem__c
                                                                    where Apttus_QPConfig__ProposalId__c =:proposalId 
                                                                    and ( Apttus_Config2__ProductId__r.ProductCode like 'HI-%'
                                                                         or ( Apttus_Config2__ProductId__r.Metasearch_Products__c = true 
                                                                             and Apttus_Config2__ProductId__r.ProductCode like 'ME-%'))
                                                                   ];
        
        return AssetLineItemList;
    }
    
    // ========================================
    // Method retriving AssetLines having BI Products for proposal
    // ========================================    
    public static string getAssetLinesList(Id proposalId)
    {
        LIST <Apttus_Config2__AssetLineItem__c> assetLines = [SELECT Id
                                                              FROM Apttus_Config2__AssetLineItem__c
                                                              where Apttus_QPConfig__ProposalId__c =:proposalId 
                                                              and Apttus_Config2__ProductId__r.ProductCode like 'BI-%'
                                                              and Apttus_Config2__OptionId__c <> null 
                                                             ];
        
        List<AssetLine> assetLinesList = new List <AssetLine>();
        
        for(Apttus_Config2__AssetLineItem__c al : assetLines)
        {
            AssetLine a = new AssetLine();
            a.Line_ID = al.Id;
            assetLinesList.add(a);
        } 
        return JSON.serialize(assetLinesList);	
    } 
    
    // ========================================
    // Method retriving AssetLines having BI Products for proposal in grouped by ProductCode
    // ========================================    
    public static map<string,list<AssetLine>> getAssetLinesByProductCode(Id proposalId)
    {
        map<string,list<AssetLine>> records = new map<string,list<AssetLine>>();
        
        LIST <Apttus_Config2__AssetLineItem__c> assetLines = [SELECT Id,SLTC_Zuora_Subscription_Number__c,Apttus_Config2__ProductId__r.ProductCode,
                                                              Apttus_Config2__ShipToAccountId__c,
                                                              Apttus_Config2__BillToAccountId__c
                                                              FROM Apttus_Config2__AssetLineItem__c
                                                              where Apttus_QPConfig__ProposalId__c =:proposalId 
                                                              and Apttus_Config2__ProductId__r.ProductCode like 'BI-%'
                                                              and Apttus_Config2__OptionId__c <> null
                                                              and ((Apttus_Config2__ChargeType__c = 'Set Up Fee' and Apttus_Config2__ProductId__r.Sync_Setup_Fee_to_BI__c = true) 
                                                                   OR Apttus_Config2__ChargeType__c <> 'Set Up Fee') 
                                                              order by SLTC_Zuora_Subscription_Number__c];
        
        // Check Zuora_Subscription is Null for any AssetLines.
        for(Apttus_Config2__AssetLineItem__c line : assetLines)
        {
            if(line.SLTC_Zuora_Subscription_Number__c == null)
            {
                // return records;
            }
        }
        
        // Zuora_Subscription is not Null for any AssetLines.
        for(Apttus_Config2__AssetLineItem__c di : assetLines)
        {
            AssetLine a = new AssetLine();
            a.Line_ID = di.Id;
            //Create unique key for ProductCode and Account to create seprate event.
            string combinekey = di.Apttus_Config2__ProductId__r.ProductCode +'_'+ di.Apttus_Config2__ShipToAccountId__c;
            
            if(records.containskey(combinekey))
            {
                records.get(combinekey).add(a);
            }
            else
            {
                list<AssetLine> tmpacc = new list<AssetLine>();
                tmpacc.add(a);
                records.put(combinekey,tmpacc);
            }
        }
        
        return records;	
        
    } 
    
    
    //=============================
    // Get Products for channelManagerProducts from proposalId
    //=============================
    public static List<CMProduct> getCMProducts(ID proposalId)
    {
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalAndLineItems = [SELECT Id, 
                                                                             Apttus_Proposal__Product__c,
                                                                             Apttus_Proposal__Product__r.Name,
                                                                             Apttus_QPConfig__BillToAccountId__c,
                                                                             Apttus_QPConfig__ShipToAccountId__c
                                                                             FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                                             where Apttus_Proposal__Proposal__c =:proposalId 
                                                                             and ( Apttus_Proposal__Product__r.ProductCode like 'HI-%')
                                                                            ];
        
        
        
        List <CMProduct> CMProductList = new List<CMProduct>();
        for(Apttus_Proposal__Proposal_Line_Item__c pr : proposalAndLineItems)
        {
            CMProduct a = new CMProduct();
            a.lineItemId = pr.Id;
            a.ShipToAccount = pr.Apttus_QPConfig__ShipToAccountId__c;
            a.BillToAccount = pr.Apttus_QPConfig__BillToAccountId__c;
            a.ProductId = pr.Apttus_Proposal__Product__c;
            CMProductList.add(a);
        }
        return CMProductList;
    }
    
    //=============================
    // Get Products for iHotelierProducts from proposalId
    //=============================
    public static List <iHProduct> getiHProducts(ID proposalId)
    {
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalAndLineItems = [SELECT Id, 
                                                                             Apttus_Proposal__Product__c,
                                                                             Apttus_Proposal__Product__r.Name,
                                                                             Apttus_QPConfig__BillToAccountId__c,
                                                                             Apttus_QPConfig__ShipToAccountId__c
                                                                             FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                                             where Apttus_Proposal__Proposal__c =:proposalId 
                                                                             and (Apttus_Proposal__Product__r.ProductCode like 'HI-%')
                                                                            ];
        
        
        
        List <iHProduct> iHProductList = new List<iHProduct>();
        for(Apttus_Proposal__Proposal_Line_Item__c pr : proposalAndLineItems)
        {
            iHProduct a = new iHProduct();
            a.lineItemId = pr.Id;
            a.ShipToAccount = pr.Apttus_QPConfig__ShipToAccountId__c;
            a.BillToAccount = pr.Apttus_QPConfig__BillToAccountId__c;
            a.ProductId = pr.Apttus_Proposal__Product__c;
            iHProductList.add(a);
        }
        return iHProductList;
    }
    
    //=============================
    // Get Products for BIProductsProducts from proposalId
    //============================= 
    public static List <BIProduct> getBIProducts(ID proposalId)
    {
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalAndLineItems = [SELECT Id, 
                                                                             Apttus_Proposal__Product__c,
                                                                             Apttus_Proposal__Product__r.Name,
                                                                             Apttus_QPConfig__BillToAccountId__c,
                                                                             Apttus_QPConfig__ShipToAccountId__c
                                                                             FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                                             where Apttus_Proposal__Proposal__c =:proposalId 
                                                                             and Apttus_Proposal__Product__r.ProductCode like 'BI-%'
                                                                            ];
        
        
        
        List <BIProduct> BIProductList = new List<BIProduct>();
        for(Apttus_Proposal__Proposal_Line_Item__c pr : proposalAndLineItems)
        {
            BIProduct a = new BIProduct();
            a.lineItemId = pr.Id;
            a.ShipToAccount = pr.Apttus_QPConfig__ShipToAccountId__c;
            a.BillToAccount = pr.Apttus_QPConfig__BillToAccountId__c;
            a.ProductId = pr.Apttus_Proposal__Product__c;
            BIProductList.add(a);
        }
        return BIProductList;
    }
    
    //=============================
    // Get Products for Metasearch from proposalId
    //=============================
    public static List<MEProduct> getMEProducts(ID proposalId)
    {
        List<Apttus_Proposal__Proposal_Line_Item__c> proposalAndLineItems = [SELECT Id, 
                                                                             Apttus_Proposal__Product__c,
                                                                             Apttus_Proposal__Product__r.Name,
                                                                             Apttus_QPConfig__BillToAccountId__c,
                                                                             Apttus_QPConfig__ShipToAccountId__c
                                                                             FROM Apttus_Proposal__Proposal_Line_Item__c 
                                                                             where Apttus_Proposal__Proposal__c =:proposalId 
                                                                             and (  Apttus_Proposal__Product__r.Metasearch_Products__c = true and Apttus_Proposal__Product__r.ProductCode like 'ME-%')
                                                                            ];
        
        
        
        List <MEProduct> MEProductList = new List<MEProduct>();
        for(Apttus_Proposal__Proposal_Line_Item__c pr : proposalAndLineItems)
        {
            MEProduct a = new MEProduct();
            a.lineItemId = pr.Id;
            a.ShipToAccount = pr.Apttus_QPConfig__ShipToAccountId__c;
            a.BillToAccount = pr.Apttus_QPConfig__BillToAccountId__c;
            a.ProductId = pr.Apttus_Proposal__Product__c;
            MEProductList.add(a);
        }
        return MEProductList;
    }
    
    //THIS METHOD USED TO CHECK BP ID ON PROPOSAL LINE ITEMS
    public static List<String> getProposalLineItems(ID proposalId)
    {
        List <String> errors = new List<String>();
        map<string,string> mapofBPIdErrors = new map<string,string>();
        
        for(Apttus_Proposal__Proposal_Line_Item__c pr : [SELECT Id,Apttus_QPConfig__BillToAccountId__c,Apttus_QPConfig__BillToAccountId__r.Amadeus_BP_ID__c,Apttus_QPConfig__BillToAccountId__r.Name,
                                                         Apttus_QPConfig__BillToAccountId__r.Parent.Name,
                                                         Apttus_QPConfig__BillToAccountId__r.ParentId,Apttus_QPConfig__BillToAccountId__r.Parent.Amadeus_BP_ID__c,
                                                         Apttus_QPConfig__ShipToAccountId__c,Apttus_QPConfig__ShipToAccountId__r.Amadeus_BP_ID__c,
                                                         Apttus_QPConfig__ShipToAccountId__r.Parent.Name,Apttus_QPConfig__ShipToAccountId__r.Name,
                                                         Apttus_QPConfig__ShipToAccountId__r.ParentId,Apttus_QPConfig__ShipToAccountId__r.Parent.Amadeus_BP_ID__c
                                                         FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =:proposalId])
        {
            
            if((pr.Apttus_QPConfig__BillToAccountId__c != null && pr.Apttus_QPConfig__BillToAccountId__r.Amadeus_BP_ID__c == null) || (pr.Apttus_QPConfig__BillToAccountId__r.ParentId != null && pr.Apttus_QPConfig__BillToAccountId__r.Parent.Amadeus_BP_ID__c == null))
            {
                if(!mapofBPIdErrors.containskey(pr.Apttus_QPConfig__BillToAccountId__c))
                {
                    mapofBPIdErrors.put(pr.Apttus_QPConfig__BillToAccountId__c,'Proposal Line Items Bill To Account BP Id is not set on '+pr.Apttus_QPConfig__BillToAccountId__r.Name);
                }
                
                if(pr.Apttus_QPConfig__BillToAccountId__r.ParentId != null && !mapofBPIdErrors.containskey(pr.Apttus_QPConfig__BillToAccountId__r.ParentId))
                {
                    mapofBPIdErrors.put(pr.Apttus_QPConfig__BillToAccountId__r.ParentId,'Proposal Line Items Bill To Account BP Id is not set on '+pr.Apttus_QPConfig__BillToAccountId__r.Parent.Name);
                }
            }
            
            if((pr.Apttus_QPConfig__ShipToAccountId__c != null && pr.Apttus_QPConfig__ShipToAccountId__r.Amadeus_BP_ID__c == null) || (pr.Apttus_QPConfig__ShipToAccountId__r.ParentId != null && pr.Apttus_QPConfig__ShipToAccountId__r.Parent.Amadeus_BP_ID__c == null))
            {
                if(!mapofBPIdErrors.containskey(pr.Apttus_QPConfig__ShipToAccountId__c))
                {
                    mapofBPIdErrors.put(pr.Apttus_QPConfig__ShipToAccountId__c,'Proposal Line Items Ship To Account BP Id is not set on '+pr.Apttus_QPConfig__ShipToAccountId__r.Name);
                }
                
                if(pr.Apttus_QPConfig__ShipToAccountId__r.ParentId != null && !mapofBPIdErrors.containskey(pr.Apttus_QPConfig__ShipToAccountId__r.ParentId))
                {
                    mapofBPIdErrors.put(pr.Apttus_QPConfig__ShipToAccountId__r.ParentId,'Proposal Line Items Ship To Account BP Id is not set on '+pr.Apttus_QPConfig__ShipToAccountId__r.Parent.Name);
                }
            }
        }
        System.debug('mapofBPIdErrors==>'+mapofBPIdErrors);
        if(mapofBPIdErrors != null)
        {
            errors.addall(mapofBPIdErrors.Values());
        }
        System.debug('errors==>'+errors);
        
        return errors;
    }
    
    
    //======================================
    //Wrapper Class AssetLine
    //======================================
    public class AssetLine 
    {
        public string Line_ID;
    }
    
    //======================================
    //Wraper Classes For Proposal JSON data structure
    //======================================
    
    public class ProposalWrapper
    {
        public string ProposalId;
        public ProductWrapper products;
    }
    
    public class ProductWrapper
    {
        public list<Product> mediaProducts;
        public list<CMProduct> channelManagerProducts;
        public list<iHProduct> iHotelierProducts;
        public list<BIProduct> BIProducts;
        public list<MEProduct> metasearchProducts;
    }  
    
    public class Product 
    {
        public string Type;
        public string ProductId;
        public string LineItemId;
        public string BillToAccount;
        public string ShipToAccount;
        public string Description;
        public string CampaignNumber;
        public string Need_By_Date;
        public MAP<String,String> lineOptions;
        public LIST<channel> Channels;
    }
    
    public class channel
    {
        public string Name;
        public string ProductOptionId;
        public MAP<string,string> Data;
    }
    
    public class Affilation 
    {
        public string Id;
        public string Type;
        public string Account;
    }
    
    public class AccDetails
    {
        public string insiteId;
        public string businessProcessId;
    }
    
    public class CMProduct 
    {
        public string lineItemId;
        public string ShipToAccount;
        public string BillToAccount;
        public string ProductId;
    }
    
    public class iHProduct 
    {
        public string lineItemId;
        public string ShipToAccount;
        public string BillToAccount;
        public string ProductId;
    }
    
    public class BIProduct 
    {
        public string lineItemId;
        public string ShipToAccount;
        public string BillToAccount;
        public string ProductId;
    }
    
    public class MEProduct 
    {
        public string lineItemId;
        public string ShipToAccount;
        public string BillToAccount;
        public string ProductId;
    }
    
    public class AssestLine_IHProducts
    {
        public string AssetLineId;
        public string OrderId;
        public string ProductCode;
        public string Type;
        public string ShipToAccount;
        public string ProductId;
        public string OrderLineItemId;
        public string Description;
        public string BillToAccount;
    }
    
    public class Project 
    {
        public string Name;
        public string Phone;
        public string Title;
        public string ResourceName;
        public string Email;
    }
    
}