/**
 * @description Base class for all trigger handlers.
 * @author Harpreet Singh
 * @date 13.SEP.2022
 */
public virtual class skedTriggerHandler {

    private String handlerName { get; set; }
    private TriggerContext context;

    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT,
        BEFORE_UPDATE,
        BEFORE_DELETE,
        AFTER_INSERT,
        AFTER_UPDATE,
        AFTER_DELETE,
        AFTER_UNDELETE
    }

    // constructor
    public skedTriggerHandler() {
        this.setTriggerContext();
    }
    public skedTriggerHandler(String handlerName) {
        this.handlerName = handlerName;
        this.setTriggerContext();
    }

    /***************************************
     * private instancemethods
     ***************************************/
    /**
    * @description Sets context of running trigger.
    * @author Harpreet Singh
    * @date 13.SEP.2022
    */
    private void setTriggerContext() {
        if (Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
            this.context = TriggerContext.BEFORE_INSERT;
        } else if (Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
            this.context = TriggerContext.BEFORE_UPDATE;
        } else if (Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) {
            this.context = TriggerContext.BEFORE_DELETE;
        } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
            this.context = TriggerContext.AFTER_INSERT;
        } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
            this.context = TriggerContext.AFTER_UPDATE;
        } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) {
            this.context = TriggerContext.AFTER_DELETE;
        } else if (Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }

    /**
    * @description Validates whether Trigger execution should continue or not.
    * @author Harpreet Singh
    * @date 13.SEP.2022
    */
    private Boolean validateRun() {
        // Can be used later to bypass trigger run for
        // specific users / classes using custom settings
        return true;
    }

    /***************************************
     * public instance methods
     ***************************************/
    /**
    * @description main method that will be called during execution.
    * @author Harpreet Singh
    * @date 13.SEP.2022
    */
    public void run() {
        if (!validateRun()) {
            return;
        }

        // dispatch to the correct handler method
        if (this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        } else if (this.context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        } else if (this.context == TriggerContext.BEFORE_DELETE) {
            this.beforeDelete();
        } else if (this.context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        } else if (this.context == TriggerContext.AFTER_UPDATE) {
            this.afterUpdate();
        } else if (this.context == TriggerContext.AFTER_DELETE) {
            this.afterDelete();
        } else if (this.context == TriggerContext.AFTER_UNDELETE) {
            this.afterUndelete();
        }
    }

    /***************************************
     * context methods
     ***************************************/

    // context-specific methods for override
    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void beforeInsert() {
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void beforeUpdate() {
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void beforeDelete() {
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void afterInsert() {
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void afterUpdate() {
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void afterDelete() {
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    protected virtual void afterUndelete() {
    }

}
