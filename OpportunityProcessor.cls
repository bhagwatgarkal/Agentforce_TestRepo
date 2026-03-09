/**
 * CLASS:   OpportunityProcessor
 * AUTHOR:  Dev Team
 * PURPOSE: Processes Opportunity records and syncs with Account data.
 *
 * NOTE: CHANGE CONTROL and DEPENDENCIES intentionally omitted
 *       so CS-01 fires for missing required header fields.
 */
public with sharing class OpportunityProcessor {

    /****************************************************
     *  CS-04 VIOLATION: block comment style /****/ used
     *  inside the class body (line > 5).
     *  Amadeus standard requires // === dividers only.
     ****************************************************/

    // =========================================================
    //  CONSTANTS
    // =========================================================
    private static final String STATUS_OPEN   = 'Open';
    private static final String STATUS_CLOSED = 'Closed';
    private static final String STATUS_WON    = 'Closed Won';
    private static final Integer BATCH_SIZE   = 200;

    // =========================================================
    //  PUBLIC ENTRY — process a list of Opportunities
    // =========================================================
    public static void processOpportunities(List<Opportunity> opps) {

        List<Opportunity> toUpdate = new List<Opportunity>();

        for (Opportunity opp : opps) {

            // CS-03 VIOLATION: ternary operator used instead of if/else
            String label = opp.StageName == STATUS_WON ? 'Winner' : 'Pending';

            // CS-05 VIOLATION: inline if without curly braces
            if (opp.Amount == null) opp.Amount = 0;

            // CS-07 VIOLATION: System.debug without LoggingLevel
            System.debug('Processing opp: ' + opp.Name + ' label=' + label);

            // Categorise by stage — CS-06 VIOLATION: else-if chain of 4 blocks
            String category;
            if (opp.StageName == 'Prospecting') {
                category = 'EARLY';
            } else if (opp.StageName == 'Qualification') {
                category = 'QUALIFY';
            } else if (opp.StageName == 'Proposal/Price Quote') {
                category = 'PROPOSAL';
            } else if (opp.StageName == STATUS_WON) {
                category = 'WON';
            } else {
                category = 'OTHER';
            }

            opp.Description = category + ' | ' + label;
            toUpdate.add(opp);
        }

        // EH-01 VIOLATION: DML (update) outside try-catch block
        update toUpdate;

        // EH-02 VIOLATION: empty catch block — exception is swallowed silently
        try {
            List<Account> accs = [SELECT Id, Name FROM Account LIMIT 10];
            insert accs;
        } catch (Exception e) {
        }
    }

    // =========================================================
    //  HELPER — build summary string for reporting
    // =========================================================
    public static String buildSummary(List<Opportunity> opps) {
        Integer wonCount  = 0;
        Integer openCount = 0;

        for (Opportunity o : opps) {
            if (o.StageName == STATUS_WON) {
                wonCount++;
            } else {
                openCount++;
            }
        }

        // CS-03 VIOLATION: another ternary operator
        String result = wonCount > 0 ? 'Has wins' : 'No wins';

        // CS-07 VIOLATION: another debug without LoggingLevel
        System.debug('Summary won=' + wonCount + ' open=' + openCount);

        return result + ' | Won:' + wonCount + ' Open:' + openCount;
    }

    // =========================================================
    //  HELPER — validate stage value
    // =========================================================
    private static Boolean isValidStage(String stage) {
        // CS-05 VIOLATION: inline if without braces
        if (String.isBlank(stage)) return false;

        return stage == STATUS_OPEN
            || stage == STATUS_CLOSED
            || stage == STATUS_WON;
    }

    // =========================================================
    //  HELPER — fetch related account name
    // =========================================================
    private static String getAccountName(Id accountId) {
        String name = '';
        try {
            Account acc = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];
            name = acc.Name;
        } catch (Exception e) {
            // EH-02 VIOLATION: catch block contains no logging or re-throw
        }
        return name;
    }

    // =========================================================
    //  HELPER — format currency
    // =========================================================
    private static String formatAmount(Decimal amount) {
        // CS-03 VIOLATION: ternary used for null guard
        Decimal safe = amount != null ? amount : 0;
        return '$' + safe.setScale(2);
    }
}
