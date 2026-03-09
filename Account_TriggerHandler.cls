/**
 * CLASS:   Account_TriggerHandler
 * AUTHOR:  Dev Team
 * PURPOSE: Handles Account trigger events — before/after insert and update.
 *
 * CS-01 VIOLATION: CHANGE CONTROL, DEPENDENCIES, and TEST CLASS fields
 * are missing from this header block.
 */
public with sharing class Account_TriggerHandler {

    // =========================================================
    //  PUBLIC ENTRY METHODS
    //  TF-04 VIOLATION: 'processRecords' and 'syncWithExternal'
    //  are public but not named after a trigger event.
    //  Allowed names: beforeInsert, afterInsert, beforeUpdate,
    //  afterUpdate, beforeDelete, afterDelete, afterUndelete.
    //
    //  TF-05 VIOLATION: No bypass switch — no reference to
    //  Trigger_Settings__c, bypass, or .getInstance() anywhere.
    // =========================================================

    public void beforeInsert(List<Account> newRecords) {
        // CS-07 VIOLATION: System.debug without LoggingLevel
        System.debug('Account_TriggerHandler.beforeInsert called, count=' + newRecords.size());
        setDefaultValues(newRecords);
    }

    public void afterInsert(List<Account> newRecords, Map<Id, Account> newMap) {
        System.debug('Account_TriggerHandler.afterInsert called');
        syncWithExternal(newRecords);
    }

    public void beforeUpdate(List<Account> newRecords, Map<Id, Account> oldMap) {
        System.debug('Account_TriggerHandler.beforeUpdate count=' + newRecords.size());
        validateChanges(newRecords, oldMap);
    }

    // TF-04 VIOLATION: public method that is not an event-entry method
    public void processRecords(List<Account> records) {
        for (Account acc : records) {
            if (String.isBlank(acc.Phone)) {
                acc.Phone = 'N/A';
            }
        }
    }

    // TF-04 VIOLATION: second public non-event method
    public void syncWithExternal(List<Account> records) {
        // Placeholder for external sync logic
        System.debug('Syncing ' + records.size() + ' accounts externally');
    }

    // =========================================================
    //  PRIVATE HELPERS
    // =========================================================

    private void setDefaultValues(List<Account> records) {
        for (Account acc : records) {
            if (String.isBlank(acc.Type)) {
                acc.Type = 'Prospect';
            }
            if (acc.NumberOfEmployees == null) {
                acc.NumberOfEmployees = 0;
            }
        }
    }

    private void validateChanges(List<Account> newRecords, Map<Id, Account> oldMap) {
        for (Account acc : newRecords) {
            Account oldAcc = oldMap.get(acc.Id);
            if (acc.AnnualRevenue != null && oldAcc.AnnualRevenue != null) {
                if (acc.AnnualRevenue < oldAcc.AnnualRevenue * 0.5) {
                    acc.addError('Annual revenue cannot drop by more than 50% in one update.');
                }
            }
        }
    }
}
