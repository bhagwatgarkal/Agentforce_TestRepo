/**
 * CLASS:   OpportunityBatch
 * AUTHOR:  Dev Team
 * PURPOSE: Batch job to close stale Opportunity records older than 180 days.
 * CHANGE CONTROL: CR-2024-015
 * DEPENDENCIES: None
 * TEST CLASS: OpportunityBatch_Test
 *
 * NC-01 VIOLATION: This class implements Database.Batchable but the filename
 *                  is 'OpportunityBatch' — Amadeus standard requires the suffix
 *                  '_Batch', making the correct name 'Opportunity_Batch'.
 *                  (The word 'Batch' alone anywhere in the name is not enough —
 *                   the name must END with _Batch.)
 */
public with sharing class OpportunityBatch implements Database.Batchable<SObject> {

    private Date cutoffDate;

    public OpportunityBatch() {
        this.cutoffDate = Date.today().addDays(-180);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, StageName, CloseDate, OwnerId
            FROM   Opportunity
            WHERE  IsClosed      = false
            AND    CloseDate     < :cutoffDate
            ORDER BY CloseDate ASC
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        List<Opportunity> toClose = new List<Opportunity>();

        for (Opportunity opp : scope) {
            opp.StageName   = 'Closed Lost';
            opp.Description = 'Auto-closed by batch job — stale for 180+ days';
            toClose.add(opp);
        }

        try {
            update toClose;
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, 'OpportunityBatch.execute DML error: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO, 'OpportunityBatch complete. Job ID: ' + bc.getJobId());
    }
}
