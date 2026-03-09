/**
 * CLASS:   OpportunityScheduler
 * AUTHOR:  Dev Team
 * PURPOSE: Schedules the OpportunityBatch job to run nightly at midnight.
 * CHANGE CONTROL: CR-2024-016
 * DEPENDENCIES: OpportunityBatch
 * TEST CLASS: OpportunityScheduler_Test
 *
 * NC-02 VIOLATION: This class implements Schedulable but the filename is
 *                  'OpportunityScheduler' — Amadeus standard requires the
 *                  suffix '_Schedule', making the correct name
 *                  'Opportunity_Schedule'.
 */
public with sharing class OpportunityScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        OpportunityBatch batch = new OpportunityBatch();
        Database.executeBatch(batch, 200);
    }

    /**
     * Utility to schedule this job programmatically from Developer Console:
     *   OpportunityScheduler.scheduleNightly();
     */
    public static void scheduleNightly() {
        String cronExpr = '0 0 0 * * ?';
        String jobName  = 'Opportunity Stale Closer — Nightly';
        System.schedule(jobName, cronExpr, new OpportunityScheduler());
    }
}
