/**
 * CLASS:   OpportunityTests
 * AUTHOR:  Dev Team
 * PURPOSE: Test coverage for OpportunityProcessor.
 * CHANGE CONTROL: CR-2024-001
 * DEPENDENCIES: OpportunityProcessor
 * TEST CLASS: this file
 *
 * NC-04 VIOLATION: Test class annotated @isTest but filename is
 *                  'OpportunityTests' not 'OpportunityTests_Test'.
 *                  Amadeus standard requires _Test suffix.
 *
 * TC-02 VIOLATION: Class has 3 test methods but NO @testSetup method.
 *                  Shared test data should be created in @testSetup.
 */
@isTest
private class OpportunityTests {

    // TC-01 VIOLATION: testCreateOpportunity has no System.assert or Assert.
    @isTest
    static void testCreateOpportunity() {
        // TC-03 VIOLATION: direct SObject construction instead of DataFactory
        Opportunity opp = new Opportunity(
            Name        = 'Test Opp',
            StageName   = 'Prospecting',
            CloseDate   = Date.today().addDays(30),
            Amount      = 5000
        );
        insert opp;
        // No assertion — TC-01 fires
    }

    // TC-01 VIOLATION: testBuildSummary has no assertion
    @isTest
    static void testBuildSummary() {
        // TC-03 VIOLATION: direct SObject construction
        Opportunity opp1 = new Opportunity(
            Name      = 'Won Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount    = 10000
        );
        Opportunity opp2 = new Opportunity(
            Name      = 'Open Deal',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(60),
            Amount    = 2500
        );
        insert new List<Opportunity>{ opp1, opp2 };
        String summary = OpportunityProcessor.buildSummary(new List<Opportunity>{ opp1, opp2 });
        // No assertion — developer forgot to add System.assertEquals
    }

    // This test DOES have an assertion, so TC-01 will NOT fire for it.
    // TC-03 VIOLATION still fires because of direct SObject construction.
    @isTest
    static void testProcessOpportunities() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // TC-03 VIOLATION: direct new Opportunity() construction
        Opportunity opp = new Opportunity(
            Name        = 'Process Test',
            AccountId   = acc.Id,
            StageName   = 'Qualification',
            CloseDate   = Date.today().addDays(14),
            Amount      = 7500
        );
        insert opp;

        List<Opportunity> opps = [SELECT Id, Name, StageName, Amount, Description
                                  FROM Opportunity WHERE Id = :opp.Id];
        OpportunityProcessor.processOpportunities(opps);

        // This test DOES assert, so TC-01 does not fire here
        System.assertEquals(1, opps.size(), 'Should have 1 opportunity');
    }
}
