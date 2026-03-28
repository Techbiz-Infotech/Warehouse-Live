codeunit 50150 "Warehouse Event Handler"
{
    Permissions = tabledata "G/L Entry" = rmid;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLine', '', true, true)]
    local procedure "Sales-Post_OnAfterPostSalesLine"(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var SalesInvLine: Record "Sales Invoice Line"; var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var xSalesLine: Record "Sales Line")
    var
        InvoicingGateIns: Record "Invoicing Gate Ins";
        WarehouseLedgerEntry, WLE : Record "Warehouse Item Ledger Entry";
        wareGateOutHeader: Record "WH Gate Out Header";
        WareHouseInvoiceDetails: Record WarehouseinvoiceDetails;
        IMSSetup: record "IMS Setup";
        SalesHead: Record "Sales Header";
        EntryNo: Integer;
    begin
        IMSSetup.Get();
        if IMSSetup."Warehouse Activated" = true then begin
            if (SalesLine."Document Type" = SalesLine."Document Type"::Invoice) AND (SalesLine.Warehouse = true) then begin
                InvoicingGateIns.Reset();
                InvoicingGateIns.SetRange(Posted, false);
                InvoicingGateIns.SetRange("Proforma Invoice No.", SalesHeader."Proforma No.");
                InvoicingGateIns.SetRange("Gate In No.", SalesLine."Gate In No.");
               // InvoicingGateIns.SetRange("Gate In Line No.", SalesLine."Gate In Line No.");//01-21-2026  
                if InvoicingGateIns.FindFirst() then
                    repeat
                        InvoicingGateIns.Posted := true;
                        InvoicingGateIns."Posted Invoice No." := SalesInvLine."Document No.";
                        InvoicingGateIns."Customs Entry No." := SalesInvLine."Customs Entry No.";
                        if SalesLine."Item Category Code" = IMSSetup."Category for Warehouse Storage" then
                            //12-09-2024
                            InvoicingGateIns."Chargeable warehouse Periods" := SalesInvLine."Chargeable warehouse Periods";
                        InvoicingGateIns."Chargeable Rewarehouse Periods" := SalesInvLine."Chargeable Rewarehouse Periods";
                        //12-09-2024
                        if InvoicingGateIns."Invoice Type" = InvoicingGateIns."Invoice Type"::"Gate In" then
                            InvoicingGateIns."Gate In Charges" := true;
                        if InvoicingGateIns."Invoice Type" = InvoicingGateIns."Invoice Type"::"Gate Out" then
                            InvoicingGateIns."Gate Out Charges" := true;

                        InvoicingGateIns.Modify();
                    until InvoicingGateIns.Next() = 0;
                SalesHead.Reset();
                SalesHead.SetRange("Document Type", SalesHead."Document Type"::Order);
                SalesHead.SetRange("No.", SalesHeader."Proforma No.");
                if SalesHead.FindFirst() then begin
                    SalesHead.Closed := true;
                    SalesHead.Modify();
                end;
                // WareHouseInvoiceDetails.Init();
                // WareHouseInvoiceDetails."Entry No." := EntryNo;
                // WareHouseInvoiceDetails."Document Type" := WareHouseInvoiceDetails."Document Type"::Invoice;
                // WareHouseInvoiceDetails."Document No." := SalesLine."Document No.";
                // WareHouseInvoiceDetails."Gate In No." := SalesLine."Gate In No.";
                // WareHouseInvoiceDetails."Gate In Line No." := SalesLine."Gate In Line No.";
                // WareHouseInvoiceDetails."Unit Price" := SalesLine."Unit Price";
                // WareHouseInvoiceDetails.Quantity := SalesLine.Quantity;
                // WareHouseInvoiceDetails."Line Amount" := SalesLine."Line Amount";
                // WareHouseInvoiceDetails."Line Discount Amount" := SalesLine."Line Discount Amount";
                // WareHouseInvoiceDetails."Posting Date" := SalesHeader."Posting Date";
                // WareHouseInvoiceDetails."Charge ID" := SalesLine."Charge ID";
                // WareHouseInvoiceDetails."Invoicing Qty" := SalesLine."Invoicing Quantity";
                // WareHouseInvoiceDetails."Invoicing CBM" := SalesLine."Invoicing CBM/Weight";
                // WareHouseInvoiceDetails."Invoice Type" := SalesLine."Invoice Type";
                // WareHouseInvoiceDetails.Insert();
            end;


            //WareHouse Credit Memo
            if (SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo") and (SalesLine.Warehouse = true) then begin

                InvoicingGateIns.Reset();
                InvoicingGateIns.SetRange(Posted, true);
                InvoicingGateIns.SetRange("Proforma Invoice No.", SalesHeader."Proforma No.");
                InvoicingGateIns.SetRange("Posted Invoice No.", SalesHeader."Applies-to Doc. No.");
                InvoicingGateIns.SetRange("Gate In No.", SalesLine."Gate In No.");
                InvoicingGateIns.SetRange("Gate In Line No.", SalesLine."Gate In Line No.");
                if InvoicingGateIns.FindFirst() then
                    repeat
                        IMSSetup.Get();
                        if (SalesLine."Item Category Code" = IMSSetup."Category for Warehouse Storage") and (InvoicingGateIns."Gated Out" = true) then begin
                            WLE.Reset();
                            if WLE.FindLast() then
                                EntryNo := WLE."Entry No." + 1
                            else
                                EntryNo := 1;
                            WarehouseLedgerEntry.Init();
                            WarehouseLedgerEntry."Entry No." := EntryNo;
                            WarehouseLedgerEntry."Posting Date" := SalesCrMemoLine."Posting Date";
                            WarehouseLedgerEntry."Warehouse Entry Type" := WarehouseLedgerEntry."Warehouse Entry Type"::"Credit Memo";
                            WarehouseLedgerEntry."Document No." := SalesCrMemoLine."Document No.";
                            WarehouseLedgerEntry."Location Code" := SalesCrMemoLine."Location Code";
                            WarehouseLedgerEntry.Quantity := SalesCrMemoLine."Invoicing Quantity";
                            WarehouseLedgerEntry."Weight/CBM" := SalesCrMemoLine."Invoicing CBM/Weight";
                            WarehouseLedgerEntry."Invoicing WH Stripped Qty" := SalesCrMemoLine."Invoicing WH Stripped Qty";
                            WarehouseLedgerEntry."Consignee No." := SalesCrMemoLine."Sell-to Customer No.";
                            WarehouseLedgerEntry."Clearing Agent" := SalesCrMemoLine."Clearing Agent";
                            WarehouseLedgerEntry."Consignment Value" := InvoicingGateIns."Consignment Value Released";
                            WarehouseLedgerEntry."Location Type" := InvoicingGateIns."Location Type";
                            WarehouseLedgerEntry."Applied Document No." := SalesLine."Gate In No.";
                            WarehouseLedgerEntry."Applied Document Line No." := SalesLine."Gate In Line No.";
                            if wareGateOutHeader.Get(InvoicingGateIns."Gate Out No.") then begin
                                wareGateOutHeader.Reversed := true;
                                wareGateOutHeader.Modify();
                                WarehouseLedgerEntry."Consignment Value" := wareGateOutHeader."Consignment Value to Release";
                            end;
                            WarehouseLedgerEntry.Insert();


                            IMSSetup.Get();
                            IMSSetup.UpdateWHValues();
                        end;
                        InvoicingGateIns.Reversed := true;
                        InvoicingGateIns."Posted Credit Memo No." := SalesCrMemoLine."Document No.";
                        //12-09-2024
                        InvoicingGateIns."Chargeable warehouse Periods" := SalesCrMemoLine."Chargeable warehouse Periods";
                        InvoicingGateIns."Chargeable Rewarehouse Periods" := SalesCrMemoLine."Chargeable Rewarehouse Periods";
                        //12-09-2024
                        InvoicingGateIns.Modify();
                    until InvoicingGateIns.Next() = 0;
                // WareHouseInvoiceDetails.Init();
                // WareHouseInvoiceDetails."Entry No." := EntryNo;
                // WareHouseInvoiceDetails."Document Type" := WareHouseInvoiceDetails."Document Type"::"Credit Memo";
                // WareHouseInvoiceDetails."Document No." := SalesLine."Document No.";
                // WareHouseInvoiceDetails."Gate In No." := SalesLine."Gate In No.";
                // WareHouseInvoiceDetails."Gate In Line No." := SalesLine."Gate In Line No.";
                // WareHouseInvoiceDetails."Unit Price" := -SalesLine."Unit Price";
                // WareHouseInvoiceDetails.Quantity := -SalesLine.Quantity;
                // WareHouseInvoiceDetails."Line Amount" := -SalesLine."Line Amount";
                // WareHouseInvoiceDetails."Line Discount Amount" := -SalesLine."Line Discount Amount";
                // WareHouseInvoiceDetails."Posting Date" := SalesHeader."Posting Date";
                // WareHouseInvoiceDetails."Charge ID" := SalesLine."Charge ID";
                // WareHouseInvoiceDetails."Invoicing Qty" := SalesLine."Invoicing Quantity";
                // WareHouseInvoiceDetails."Invoicing CBM" := SalesLine."Invoicing CBM/Weight";
                // WareHouseInvoiceDetails."Invoice Type" := SalesLine."Invoice Type";
                // WareHouseInvoiceDetails.Insert();

            end;
        end;
    end;
    //*********////SH 10-18-2024 
    /****Ware House ChargeIDAssignment ***********/
    [IntegrationEvent(false, false)]
    PROCEDURE OnSendWHChargeAssignmentforApproval(VAR WHChargeAssignment: Record "Warehouse ChargeID Assignment");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendWHChargeAssignmentforCancel(VAR WHChargeAssignment: Record "Warehouse ChargeID Assignment");
    begin
    end;

    procedure IsChargeAssignmentEnabled(var WHChargeAssignemnt: Record "Warehouse ChargeID Assignment"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit WHChargeIDAssignmentWorkflow;
    begin
        exit(WFMngt.CanExecuteWorkflow(WHChargeAssignemnt, WFCode.RunWorkflowOnSendWHChargeAssignmentApprovalCode()));

    end;

    local procedure CheckWHChargeAssignmentWorkflowEnabled(): Boolean
    var
        WHChargeAssignemnt: Record "Warehouse ChargeID Assignment";
        NoWorkflowEnb: TextConst ENU = 'No workflow Enabled for this Record type', ENG = 'No workflow Enabled for this Record type';
    begin
        if not IsChargeAssignmentEnabled(WHChargeAssignemnt) then
            Error(NoWorkflowEnb);
    end;
    /****WH ChargeIDAssignment end************/

    //*********////SH 10-18-2024 


}
