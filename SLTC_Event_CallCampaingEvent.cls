/*******************************************
Name : SLTC_Event_CallCampaingEvent
Author : Ganesh Bora
Created Date : 23 Nov 2022
Last Mod Date : 31 Jan 2024
Last Mod By : Mohanish Upase
NICC Reference : 
Description : 
***********************************************************/
public with sharing class SLTC_Event_CallCampaingEvent 
{
    @AuraEnabled
    // ========================================
    // Method is called to Publish Account Campaign
    // ======================================== 
    public static List<String> publishAccountCampaignEvent(Id proposalId)
    {
        List<String> errors = new List<String>();
        List<string> status = new List<string>();
        List<String> AccountIds = new List<String>();
        List<String> pplErrors  = new list<String>();
        try
        {
            Apttus_Proposal__Proposal__c ProposalRecord = [SELECT Id, 
                                                           //ConfigurationFinalizedDate__c,
                                                           Apttus_Proposal__Account__r.SLTC_Account_Validation_Status__c,
                                                           Apttus_Proposal__Account__r.Amadeus_BP_ID__c,
                                                           Apttus_QPConfig__BillToAccountId__r.Amadeus_BP_ID__c,
                                                           Apttus_QPConfig__ShipToAccountId__r.Amadeus_BP_ID__c,
                                                           Apttus_Proposal__Account__r.id,
                                                           Apttus_QPConfig__BillToAccountId__r.id,
                                                           Apttus_QPConfig__ShipToAccountId__r.id,
                                                           Apttus_Proposal__Opportunity__r.CurrencyIsoCode
                                                           FROM Apttus_Proposal__Proposal__c 
                                                           where Id =: proposalId 
                                                          ];
            string AccountId = ProposalRecord.Apttus_Proposal__Account__r.id;
            //string BillToAccountId = ProposalRecord.Apttus_QPConfig__BillToAccountId__r.id;
            //string ShipToAccountId = ProposalRecord.Apttus_QPConfig__ShipToAccountId__r.id;
            AccountIds.add(AccountId);
            //AccountIds.add(BillToAccountId);
            // AccountIds.add(ShipToAccountId);
            
            
            LIST <SLTC_Account_Affiliation__c> Account_Affiliations = [SELECT Id
                                                                       FROM SLTC_Account_Affiliation__c
                                                                       where SLTC_Account_Affliation__c IN :AccountIds
                                                                       and SLTC_Active__c = true
                                                                      ];
            
            for(SLTC_Account_Affiliation__c acc : Account_Affiliations)
            {
                AccountIds.add(acc.Id);
            } 
            
            LIST <SLTC_Account_Affiliation__c> Account_Affiliation = [SELECT Id
                                                                      FROM SLTC_Account_Affiliation__c
                                                                      where SLTC_Account_Affliation__c IN :AccountIds
                                                                      and SLTC_Account__r.Amadeus_BP_ID__c = null
                                                                      and SLTC_Active__c = true
                                                                     ];
            
            
            // List Added to check Media product for Proposal
            List<Apttus_Proposal__Proposal_Line_Item__c> ProductMediaList = [SELECT Id FROM Apttus_Proposal__Proposal_Line_Item__c
                                                                             where Apttus_Proposal__Proposal__c =:proposalId 
                                                                             and (Apttus_Proposal__Product__r.Name like '%GDS%' 
                                                                                  OR Apttus_Proposal__Product__r.Name like 'Single Media Agency' 
                                                                                  OR Apttus_Proposal__Product__r.Name like 'Single Media Subscription') ];
            
            string CurrencyIsoCode = ProposalRecord.Apttus_Proposal__Opportunity__r.CurrencyIsoCode;
            
            if(ProductMediaList.size() > 0)
            {
                
                if(CurrencyIsoCode != 'USD' && CurrencyIsoCode != 'EUR')
                {
                    errors.add('You are trying to sync a media product to InSite which can only be in USD or EUR. Please change the opportunity currency and create a new primary proposal.');
                }
            }
            
            if(Account_Affiliation.size() > 0)
            {
                errors.add('Amadeus BP ID not present on one or more affiliated accounts.');
            }
            
            if(ProposalRecord.Apttus_Proposal__Account__r.Amadeus_BP_ID__c == null )
            {
                errors.add('Account BP Id is not set.');
            }
            //Commented till further discussion to view Proposal Bill To & Ship  To.
            /*
            if(ProposalRecord.Apttus_QPConfig__BillToAccountId__r.Amadeus_BP_ID__c == null )
            {
            	errors.add('Account BP Id is not set for Bill To.');
            }
            
            if(ProposalRecord.Apttus_QPConfig__ShipToAccountId__r.Amadeus_BP_ID__c == null )
            {
            	errors.add('Account BP Id is not set for Ship To.');
            }*/
            
            if(ProposalRecord.Apttus_Proposal__Account__r.SLTC_Account_Validation_Status__c != 'MDM Approved')
            {
                errors.add('Account Validation Status is not MDM approved.'); 
            }
            
            pplErrors = SLTC_Event_CommonUtils.getProposalLineItems(proposalId);
            
            if(errors.isEmpty() && pplErrors.isEmpty())
            {
                List<ID> proposalIdSet = new List<ID>{proposalId};
                    SLTC_Event_CampaignAccount.publishAccountCampaign(proposalIdSet);
                status.add('Confirm::Create Account Campaign Event published successfully.');
            } 
        }
        catch(Exception e)
        {
            status.add('Error::'+e.getMessage());
        }
        
        if(!errors.isEmpty() || !pplErrors.isEmpty()){
            errors.addall(pplErrors);
            string errorMsg = string.join(errors,'\n');
            //string errorMsgppl = string.join(pplErrors,'\n');
            status.add('Proposal Error::'+errorMsg);
        }
       
        return status;
    }
}