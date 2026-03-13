report 50200 "IMS WH Copy Sales Document"
{
    Caption = 'Copy WH Proforma Document';
    ProcessingOnly = true;

    dataset
    {
    }
    requestpage
    {
        //SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DocumentType; FromDocType)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Document Type';
                        ToolTip = 'Specifies the type of document that is processed by the report or batch job.';
                        Editable = false;
                        trigger OnValidate()
                        begin
                            FromDocNo := '';
                            ValidateDocNo;
                        end;
                    }
                    field(DocumentNo; FromDocNo)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Document No.';
                        ShowMandatory = true;
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookupDocNo;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateDocNo;
                        end;
                    }
                    field(FromDocNoOccurrence; FromDocNoOccurrence)
                    {
                        ApplicationArea = Suite;
                        BlankZero = true;
                        Caption = 'Doc. No. Occurrence';
                        Editable = false;
                        ToolTip = 'Specifies the number of times the No. value has been used in the number series.';
                    }
                    field(FromDocVersionNo; FromDocVersionNo)
                    {
                        ApplicationArea = Suite;
                        BlankZero = true;
                        Caption = 'Version No.';
                        Editable = false;
                        ToolTip = 'Specifies the version of the document to be copied.';
                    }
                    field(SellToCustNo; FromSalesHeader."Sell-to Customer No.")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Sell-to Customer No.';
                        Editable = false;
                        ToolTip = 'Specifies the sell-to customer number that will appear on the new sales document.';
                    }
                    field(SellToCustName; FromSalesHeader."Sell-to Customer Name")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Sell-to Customer Name';
                        Editable = false;
                        ToolTip = 'Specifies the sell-to customer name that will appear on the new sales document.';
                    }
                    field(IncludeHeader_Options; IncludeHeader)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Include Header';
                        ToolTip = 'Specifies if you also want to copy the information from the document header. When you copy quotes, if the posting date field of the new document is empty, the work date is used as the posting date of the new document.';
                        Editable = false;
                        Visible = false;

                        trigger OnValidate()
                        begin
                            ValidateIncludeHeader;
                        end;
                    }
                    field(RecalculateLines; RecalculateLines)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Recalculate Lines';
                        ToolTip = 'Specifies that lines are recalculate and inserted on the sales document you are creating. The batch job retains the item numbers and item quantities but recalculates the amounts on the lines based on the customer information on the new document header. In this way, the batch job accounts for item prices and discounts that are specifically linked to the customer on the new header.';
                        Editable = false;
                        Visible = false;
                        trigger OnValidate()
                        begin

                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            FromDocType := FromDocType::Order;

            if FromDocNo <> '' then begin
                case FromDocType of
                    FromDocType::Order:
                        if FromSalesHeader.Get(FromSalesHeader."Document Type"::Order, FromDocNo) then
                            ;
                end;
                if FromSalesHeader."No." = '' then
                    FromDocNo := '';
            end;
            ValidateDocNo;
            IncludeHeader := true;
            RecalculateLines := false;

            OnAfterOpenPage;
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            SalesHead: Record "Sales Header";
        begin
            if CloseAction = ACTION::OK then begin
                if FromDocNo = '' then
                    Error(DocNoNotSerErr)
                else begin
                    SalesHead.Reset();
                    SalesHead.SetRange("Document Type", SalesHead."Document Type"::Order);
                    SalesHead.SetRange("No.", FromDocNo);
                    If SalesHead.FindFirst() then begin
                        // SalesHead.Closed := true;
                        // SalesHead.Modify();
                    end;
                end;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        ExactCostReversingMandatory: Boolean;
    begin
        OnBeforePreReport();

        SalesSetup.Get();
        ExactCostReversingMandatory := SalesSetup."Exact Cost Reversing Mandatory";

        OnPreReportOnBeforeCopyDocMgtSetProperties(FromDocType, FromDocNo, SalesHeader, ExactCostReversingMandatory);
        CopyDocMgt.SetProperties(
          IncludeHeader, RecalculateLines, false, false, false, ExactCostReversingMandatory, false);
        CopyDocMgt.SetArchDocVal(FromDocNoOccurrence, FromDocVersionNo);

        OnPreReportOnBeforeCopySalesDoc(CopyDocMgt, FromDocType.AsInteger(), FromDocNo, SalesHeader, CurrReport.UseRequestPage(), IncludeHeader, RecalculateLines, ExactCostReversingMandatory);

        CopyDocMgt.CopySalesDoc(FromDocType, FromDocNo, SalesHeader);
    end;

    var
        FromSalesShptHeader: Record "Sales Shipment Header";
        FromSalesInvHeader: Record "Sales Invoice Header";
        FromReturnRcptHeader: Record "Return Receipt Header";
        FromSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        FromSalesHeaderArchive: Record "Sales Header Archive";
        SalesSetup: Record "Sales & Receivables Setup";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        IncludeHeader: Boolean;
        RecalculateLines: Boolean;
        Text000: Label 'The price information may not be reversed correctly, if you copy a %1. If possible copy a %2 instead or use %3 functionality.';
        Text001: Label 'Undo Shipment';
        Text002: Label 'Undo Return Receipt';
        DocNoNotSerErr: Label 'Select a document number to continue, or choose Cancel to close the page.';

    protected var
        SalesHeader: Record "Sales Header";
        FromSalesHeader: Record "Sales Header";
        FromDocType: Enum "Sales Document Type From";
        FromDocNo: Code[20];
        FromDocNoOccurrence: Integer;
        FromDocVersionNo: Integer;

    procedure SetSalesHeader(var NewSalesHeader: Record "Sales Header")
    begin
        NewSalesHeader.TestField("No.");
        SalesHeader := NewSalesHeader;
    end;

    local procedure ValidateDocNo()
    var
        FromDocType2: Enum "Sales Document Type From";
    begin
        if FromDocNo = '' then begin
            FromSalesHeader.Init();
            FromDocNoOccurrence := 0;
            FromDocVersionNo := 0;
        end else
            if FromSalesHeader."No." = '' then begin
                FromSalesHeader.Init();
                // case FromDocType of
                //     FromDocType::Order:
                //         FromSalesHeader.Get(CopyDocMgt.GetSalesDocumentType(FromDocType), FromDocNo);
                // end;
                FromSalesHeader.reset;
                FromSalesHeader.SetRange("Document Type", FromDocType);
                FromSalesHeader.SetRange("No.", FromDocNo);
                FromSalesHeader.SetRange(Closed, false);
                FromSalesHeader.SetRange(Warehouse,true);
                FromSalesHeader.FindFirst();
            end;
        FromSalesHeader."No." := '';


        OnBeforeValidateIncludeHeader(IncludeHeader, FromSalesHeader);
        ValidateIncludeHeader;
        OnAfterValidateIncludeHeader(IncludeHeader, RecalculateLines);
    end;

    local procedure FindFromSalesHeaderArchive()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindFromSalesHeaderArchive(FromSalesHeaderArchive, FromDocType, FromDocNo, FromDocNoOccurrence, FromDocVersionNo, IsHandled);
        if IsHandled then
            exit;

        if not FromSalesHeaderArchive.Get(
             CopyDocMgt.GetSalesDocumentType(FromDocType), FromDocNo, FromDocNoOccurrence, FromDocVersionNo)
        then begin
            FromSalesHeaderArchive.SetRange("No.", FromDocNo);
            if FromSalesHeaderArchive.FindLast then begin
                FromDocNoOccurrence := FromSalesHeaderArchive."Doc. No. Occurrence";
                FromDocVersionNo := FromSalesHeaderArchive."Version No.";
            end;
        end;
    end;

    local procedure LookupDocNo()
    begin
        OnBeforeLookupDocNo(SalesHeader);

        case FromDocType of
            FromDocType::Order:
                LookupSalesDoc();
        end;

        ValidateDocNo();
    end;

    local procedure LookupSalesDoc()
    begin
        OnBeforeLookupSalesDoc(FromSalesHeader, SalesHeader);

        FromSalesHeader.FilterGroup := 0;

        FromSalesHeader.SetRange("Document Type", CopyDocMgt.GetSalesDocumentType(FromDocType));
        FromSalesHeader.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        FromSalesHeader.SetRange(Closed, false);
        FromSalesHeader.SetRange(Status, FromSalesHeader.Status::Released);
        FromSalesHeader.SetRange(Warehouse,true);
        if SalesHeader."Document Type" = CopyDocMgt.GetSalesDocumentType(FromDocType) then
            FromSalesHeader.SetFilter("No.", '<>%1', SalesHeader."No.");
        FromSalesHeader.FilterGroup := 2;
        FromSalesHeader."Document Type" := CopyDocMgt.GetSalesDocumentType(FromDocType);
        FromSalesHeader."No." := FromDocNo;
        if (FromDocNo = '') and (SalesHeader."Sell-to Customer No." <> '') then
            if FromSalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.") then begin
                FromSalesHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                if FromSalesHeader.Find('=><') then;
            end;
        if PAGE.RunModal(0, FromSalesHeader) = ACTION::LookupOK then
            FromDocNo := FromSalesHeader."No.";
    end;

    local procedure LookupSalesArchive()
    begin
        FromSalesHeaderArchive.Reset();
        OnLookupSalesArchiveOnBeforeSetFilters(FromSalesHeaderArchive, SalesHeader);
        FromSalesHeaderArchive.FilterGroup := 0;
        FromSalesHeaderArchive.SetRange("Document Type", CopyDocMgt.GetSalesDocumentType(FromDocType));
        FromSalesHeaderArchive.FilterGroup := 2;
        FromSalesHeaderArchive."Document Type" := CopyDocMgt.GetSalesDocumentType(FromDocType);
        FromSalesHeaderArchive."No." := FromDocNo;
        FromSalesHeaderArchive."Doc. No. Occurrence" := FromDocNoOccurrence;
        FromSalesHeaderArchive."Version No." := FromDocVersionNo;
        if (FromDocNo = '') and (SalesHeader."Sell-to Customer No." <> '') then
            if FromSalesHeaderArchive.SetCurrentKey("Document Type", "Sell-to Customer No.") then begin
                FromSalesHeaderArchive."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                if FromSalesHeaderArchive.Find('=><') then;
            end;
        if PAGE.RunModal(0, FromSalesHeaderArchive) = ACTION::LookupOK then begin
            FromDocNo := FromSalesHeaderArchive."No.";
            FromDocNoOccurrence := FromSalesHeaderArchive."Doc. No. Occurrence";
            FromDocVersionNo := FromSalesHeaderArchive."Version No.";
            RequestOptionsPage.Update(false);
        end;
    end;

    local procedure LookupPostedShipment()
    begin
        OnBeforeLookupPostedShipment(FromSalesShptHeader, SalesHeader);

        FromSalesShptHeader."No." := FromDocNo;
        if (FromDocNo = '') and (SalesHeader."Sell-to Customer No." <> '') then
            if FromSalesShptHeader.SetCurrentKey("Sell-to Customer No.") then begin
                FromSalesShptHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                if FromSalesShptHeader.Find('=><') then;
            end;
        if PAGE.RunModal(0, FromSalesShptHeader) = ACTION::LookupOK then
            FromDocNo := FromSalesShptHeader."No.";
    end;

    local procedure LookupPostedInvoice()
    begin
        OnBeforeLookupPostedInvoice(FromSalesInvHeader, SalesHeader);

        FromSalesInvHeader."No." := FromDocNo;
        if (FromDocNo = '') and (SalesHeader."Sell-to Customer No." <> '') then
            if FromSalesInvHeader.SetCurrentKey("Sell-to Customer No.") then begin
                FromSalesInvHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                if FromSalesInvHeader.Find('=><') then;
            end;
        FromSalesInvHeader.FilterGroup(2);
        FromSalesInvHeader.SetRange("Prepayment Invoice", false);
        FromSalesInvHeader.FilterGroup(0);
        if PAGE.RunModal(0, FromSalesInvHeader) = ACTION::LookupOK then
            FromDocNo := FromSalesInvHeader."No.";
    end;

    local procedure LookupPostedCrMemo()
    begin
        OnBeforeLookupPostedCrMemo(FromSalesCrMemoHeader, SalesHeader);

        FromSalesCrMemoHeader."No." := FromDocNo;
        if (FromDocNo = '') and (SalesHeader."Sell-to Customer No." <> '') then
            if FromSalesCrMemoHeader.SetCurrentKey("Sell-to Customer No.") then begin
                FromSalesCrMemoHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                if FromSalesCrMemoHeader.Find('=><') then;
            end;
        FromSalesCrMemoHeader.FilterGroup(2);
        FromSalesCrMemoHeader.SetRange("Prepayment Credit Memo", false);
        FromSalesCrMemoHeader.FilterGroup(0);
        if PAGE.RunModal(0, FromSalesCrMemoHeader) = ACTION::LookupOK then
            FromDocNo := FromSalesCrMemoHeader."No.";
    end;

    local procedure LookupPostedReturn()
    begin
        OnBeforeLookupPostedReturn(FromReturnRcptHeader, SalesHeader);

        FromReturnRcptHeader."No." := FromDocNo;
        if (FromDocNo = '') and (SalesHeader."Sell-to Customer No." <> '') then
            if FromReturnRcptHeader.SetCurrentKey("Sell-to Customer No.") then begin
                FromReturnRcptHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                if FromReturnRcptHeader.Find('=><') then;
            end;
        if PAGE.RunModal(0, FromReturnRcptHeader) = ACTION::LookupOK then
            FromDocNo := FromReturnRcptHeader."No.";
    end;

    local procedure ValidateIncludeHeader()
    begin
        OnAfterValidateIncludeHeaderProcedure(IncludeHeader, RecalculateLines);
    end;

    procedure SetParameters(NewFromDocType: Enum "Sales Document Type From"; NewFromDocNo: Code[20]; NewIncludeHeader: Boolean; NewRecalcLines: Boolean)
    begin
        FromDocType := NewFromDocType;
        FromDocNo := NewFromDocNo;
        IncludeHeader := NewIncludeHeader;
        RecalculateLines := NewRecalcLines;
    end;

#if not CLEAN17
    [Obsolete('Replaced by SetParameters().', '17.0')]
    procedure InitializeRequest(NewDocType: Option; NewDocNo: Code[20]; NewIncludeHeader: Boolean; NewRecalcLines: Boolean)
    begin
        SetParameters("Sales Document Type From".FromInteger(NewDocType), NewDocNo, NewIncludeHeader, NewRecalcLines);
    end;
#endif

    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenPage()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterValidateIncludeHeader(var IncludeHeader: Boolean; var RecalculateLines: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterValidateIncludeHeaderProcedure(var IncludeHeader: Boolean; var RecalculateLines: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindFromSalesHeaderArchive(var FromSalesHeaderArchive: Record "Sales Header Archive"; DocType: Enum "Sales Document Type From"; DocNo: Code[20]; var DocNoOccurrence: Integer; var DocVersionNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupDocNo(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupSalesDoc(var FromSalesHeader: Record "Sales Header"; var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostedCrMemo(var FromSalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostedInvoice(var FromSalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostedShipment(var FromSalesShptHeader: Record "Sales Shipment Header"; var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostedReturn(var FromReturnRcptHeader: Record "Return Receipt Header"; var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePreReport()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeValidateIncludeHeader(var DoIncludeHeader: Boolean; FromSalesHeader: Record "Sales Header")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnLookupSalesArchiveOnBeforeSetFilters(var FromSalesHeaderArchive: Record "Sales Header Archive"; var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPreReportOnBeforeCopySalesDoc(var CopyDocumentMgt: Codeunit "Copy Document Mgt."; DocType: Integer; DocNo: Code[20]; SalesHeader: Record "Sales Header"; CurrReportUseRequestPage: Boolean; IncludeHeader: Boolean; RecalculateLines: Boolean; ExactCostReversingMandatory: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPreReportOnBeforeCopyDocMgtSetProperties(FromDocType: Enum "Sales Document Type From"; FromDocNo: Code[20]; SalesHeader: Record "Sales Header"; var ExactCostReversingMandatory: Boolean)
    begin
    end;
}


