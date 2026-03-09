/**
 * Trigger: Account_BeforeInsert
 * TF-01 VIOLATION: Handles BOTH before insert AND after insert events.
 *                  Amadeus standard requires ONE event type per trigger file.
 * TF-02 VIOLATION: Contains SOQL query, if statement, and for loop directly
 *                  in the trigger body — all logic must be in the handler class.
 */
trigger Account_BeforeInsert on Account (before insert, after insert) {

    // TF-02 VIOLATION: if statement in trigger body
    if (Trigger.isBefore) {

        // TF-02 VIOLATION: for loop in trigger body
        for (Account acc : Trigger.new) {
            if (String.isBlank(acc.Description)) {
                acc.Description = 'Auto-set by trigger';
            }
        }
    }

    if (Trigger.isAfter) {
        // TF-02 VIOLATION: SOQL query directly in trigger body
        List<Account> existing = [SELECT Id, Name FROM Account WHERE CreatedDate = TODAY LIMIT 100];
        System.debug('Accounts created today: ' + existing.size());
    }

    // This is what the trigger body SHOULD contain (handler is also present below)
    // but the violations above mean it still fails TF-02.
    Account_TriggerHandler handler = new Account_TriggerHandler();

    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isInsert) {
        handler.afterInsert(Trigger.new, Trigger.newMap);
    }
}
