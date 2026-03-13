codeunit 50151 WHChargeIDAssignmentWorkflow
{
    Permissions = TableData "Approval Entry" = ird;
    trigger OnRun()
    var
        lrec_AppEntry: Record "Approval Entry";
    begin

    end;

    var
        WFMngt: Codeunit "Workflow Management";
        AppMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        SendChargeAssignmentReq: TextConst ENU = 'Approval Request for WH Charge Assignment is requested', ENG = 'Approval Request for WH Charge Assignment is requested';
        AppReqChargeAssignment: TextConst ENU = 'Approval Request for WH Charge Assignment is approved', ENG = 'Approval Request for WH Charge Assignment is approved';
        RejReqChargeAssignment: TextConst ENU = 'Approval Request for WH Charge Assignment is rejected', ENG = 'Approval Request for WH Charge Assignment is rejected';
        DelReqChargeAssignment: TextConst ENU = 'Approval Request for WH Charge Assignment is delegated', ENG = 'Approval Request for WH Charge Assignment is delegated';
        CanReqChargeAssignment: TextConst ENU = 'Approval Request for WH Charge Assignment is cancelled', ENG = 'Approval Request for WH Charge Assignment is cancelled';
        SendForPendAppTxt: TextConst ENU = 'Status of WH Charge Assignment changed to Pending approval', ENG = 'Status of WH Charge Assignment changed to Pending approval';
        ReleaseChargeAssignmentTxt: TextConst ENU = 'Release WH Charge Assignment', ENG = 'Release WH Charge Assignment';
        ReOpenChargeAssignmentTxt: TextConst ENU = 'ReOpen  WHCharge Assignment', ENG = 'ReOpen WH Charge Assignment';

    procedure RunWorkflowOnCancelWHChargeAssignmentApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelWHChargeAssignmentApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Warehouse Event Handler", 'OnSendWHChargeAssignmentforCancel', '', false, false)]
    procedure RunWorkflowOnSendWHChargeAssignmentCancel(var WHChargeAssignment: Record "Warehouse ChargeID Assignment")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelWHChargeAssignmentApprovalCode(), WHChargeAssignment);
    end;


    procedure RunWorkflowOnSendWHChargeAssignmentApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendWHChargeAssignmentApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Warehouse Event Handler", 'OnSendWHChargeAssignmentforApproval', '', false, false)]
    procedure RunWorkflowOnSendWHChargeAssignmentApproval(var WHChargeAssignment: Record "Warehouse ChargeID Assignment")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendWHChargeAssignmentApprovalCode(), WHChargeAssignment);
    end;

    procedure RunWorkflowOnApproveWHChargeAssignmentApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveWHChargeAssignmentApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    procedure RunWorkflowOnApproveWHChargeAssignmentApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveWHChargeAssignmentApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure RunWorkflowOnRejectWHChargeAssignmentApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectWHChargeAssignmentApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    procedure RunWorkflowOnRejectWHChargeAssignmentApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectWHChargeAssignmentApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure RunWorkflowOnDelegateWHChargeAssignmentApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateWHChargeAssignmentApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    procedure RunWorkflowOnDelegateWHChargeAssignmentApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateWHChargeAssignmentApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    procedure SetStatusToPendingApprovalCodeWHChargeAssignment(): Code[128]
    begin
        exit(UpperCase('SetStatusToPendingApprovalWHChargeAssignment'));
    end;

    procedure SetStatusToPendingApprovalWHChargeAssignment(var Variant: Variant)
    var
        RecRef: RecordRef;
        WHChargeAssignment: Record "Warehouse ChargeID Assignment";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Warehouse ChargeID Assignment":
                begin
                    RecRef.SetTable(WHChargeAssignment);
                    WHChargeAssignment.Validate("Assignment Status", WHChargeAssignment."Assignment Status"::"Pending Approval");
                    WHChargeAssignment.Modify();
                    Variant := WHChargeAssignment;
                end;
        end;
    end;

    procedure ReleaseWHChargeAssignmentCode(): Code[128]
    begin
        exit(UpperCase('ReleaseWarehouseChargeAssignment'));
    end;

    procedure ReleaseWarehouseChargeAssignment(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        WarehouseChargeAssignment: Record "Warehouse ChargeID Assignment";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReleaseWarehouseChargeAssignment(Variant);
                end;
            DATABASE::"Warehouse ChargeID Assignment":
                begin
                    RecRef.SetTable(WarehouseChargeAssignment);
                    WarehouseChargeAssignment.Validate("Assignment Status", WarehouseChargeAssignment."Assignment Status"::Released);
                    WarehouseChargeAssignment.Modify();
                    Variant := WarehouseChargeAssignment;
                end;
        end;
    end;

    procedure ReOpenwareHouseChargeAssignmentCode(): Code[128]
    begin
        exit(UpperCase('ReOpenWareHouseChargeAssignment'));
    end;

    procedure ReOpenWareHouseChargeAssignment(var Variant: Variant)
    var
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        WareHouseChargeAssignment: Record "Warehouse ChargeID Assignment";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number() of
            DATABASE::"Approval Entry":
                begin
                    ApprovalEntry := Variant;
                    TargetRecRef.Get(ApprovalEntry."Record ID to Approve");
                    Variant := TargetRecRef;
                    ReOpenWareHouseChargeAssignment(Variant);
                end;
            DATABASE::"Warehouse ChargeID Assignment":
                begin
                    RecRef.SetTable(WareHouseChargeAssignment);
                    WareHouseChargeAssignment.Validate("Assignment Status", WareHouseChargeAssignment."Assignment Status"::Open);
                    WareHouseChargeAssignment.Modify();
                    Variant := WareHouseChargeAssignment;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddWHChargeAssignmentEventToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendWHChargeAssignmentApprovalCode(), Database::"Warehouse ChargeID Assignment", SendChargeAssignmentReq, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveWHChargeAssignmentApprovalCode(), Database::"Approval Entry", AppReqChargeAssignment, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectWHChargeAssignmentApprovalCode(), Database::"Approval Entry", RejReqChargeAssignment, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegateWHChargeAssignmentApprovalCode(), Database::"Approval Entry", DelReqChargeAssignment, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelWHChargeAssignmentApprovalCode(), Database::"Warehouse ChargeID Assignment", CanReqChargeAssignment, 0, false);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    procedure AddWHChargeAssignmentRespToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodeWHChargeAssignment(), 0, SendForPendAppTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReleaseWHChargeAssignmentCode(), 0, ReleaseChargeAssignmentTxt, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReOpenwareHouseChargeAssignmentCode(), 0, ReOpenChargeAssignmentTxt, 'GROUP 0');

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExeRespForWHChargeAssignment(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
    begin
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN
            case WorkflowResponse."Function Name" of
                SetStatusToPendingApprovalCodeWHChargeAssignment():
                    begin
                        SetStatusToPendingApprovalWHChargeAssignment(Variant);
                        ResponseExecuted := true;
                    end;
                ReleaseWHChargeAssignmentCode():
                    begin
                        ReleaseWarehouseChargeAssignment(Variant);
                        ResponseExecuted := true;
                    end;
                ReOpenwareHouseChargeAssignmentCode():
                    begin
                        ReOpenWareHouseChargeAssignment(Variant);
                        ResponseExecuted := true;
                    end;
            end;
    end;
}
