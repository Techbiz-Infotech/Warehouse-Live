page 50227 ItemListforProforma
{
    Caption = 'Item List for Proforma';
    //PageType = List;
    PageType = Worksheet;
    SourceTable = "Warehouse Item Ledger Entry";
    //Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Editable = false;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customs No. field.';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weight field.';
                    Editable = false;
                }
                field("Chargable CBM/Weight"; Rec."Chargable CBM/Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CBM field.';
                    Editable = false;
                }
                field(CBM; Rec.CBM)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CBM field.';
                    Editable = false;
                }
                field("Invoicing Quantity"; Rec."Invoicing Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the qty field.';
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if Rec."Invoicing Quantity" > Rec."Remaining Quantity" then
                            error('Invoicing Quantity must be Less than the Remaining Quantity');
                    end;
                }
                field("Invoicing CBM/Weight"; Rec."Invoicing CBM/Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CBM field.';
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if rec."Invoicing CBM/Weight" > Rec."Remaining CBM/Weight" then
                            error('Invoicing CBM/Weight must be Less than the Remaining CBM/Weight');
                    end;
                }
                field("Remaining CBM/Weight"; Rec."Remaining CBM/Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Weight field.';
                    Editable = false;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CBM field.';
                    Editable = false;
                }


                field("Consignment Value"; Rec."Consignment Value")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Consignment Value field.';
                }
                field("Location Type"; Rec."Location Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location Type field.';
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ChargeGroupHead: Record "Charge ID Group Header";
        ChargeGroupLine3, ChargeGroupLine2, ChargeGroupLine : Record "Charge ID Group Line";
        IMSSetup: Record "IMS Setup";
        ChargeID: Code[20];
        RecItem: Record Item;
        BondWHLedger, WHLedger : Record "Warehouse Item Ledger Entry";
        RecSalesLine, Salesline : Record "Sales Line";
        PostedSalesInvLine: Record "Sales Invoice Line";
        PostedSalesCrLine: Record "Sales Cr.Memo Line";
        WHouseAddCharges: Record "WareHouse Additional Charges";
        LineNo1, StorageDays, LineNo : Integer;
        StorageStartDate, GateInDate : Date;
        CalculatedPeriod, ActualChargeAmount, RemainingStock, RemainingCBM, MinimumChargeAmount, InvCBM : Decimal;
        ChargableStorageDays: Integer;
        InvoicingGateIns: Record "Invoicing Gate Ins";
        SalesLineAmount, PerWeekAmount : Decimal;
        SuccessMessage: TextConst ENU = 'Calculated Successfully';
        lrec_SalesInvLine: Record "Sales Invoice Line";
        lrec_SalesCrMemoLine: record "Sales Cr.Memo Line";
        LNo, l_LineNo : Integer;
        GateInNo1, GateInNo2 : Code[20];
        RemarshallingExist, AlreadyInvoiced, AlreadyExist : Boolean;
        ChargedWHPeriods, ChargeableWHperiods, ChargedRewarehousePeriods, ChargableRewarehousePeriods : Integer;
        CustomsEntryFound: Boolean;
        WHLedgerEntry: Record "Warehouse Item Ledger Entry";






    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            CurrPage.SETSELECTIONFILTER(WHLedger);
            if WHLedger.FINDSET then
                repeat
                    TempWHLedger := WHLedger;
                    TempWHLedger.INSERT;
                    TempWHLedger.Modify();
                until WHLedger.NEXT = 0;
            Salesline.Reset();
            Salesline.SetRange("Document Type", Salesline."Document Type"::Order);
            Salesline.SetRange("Document No.", SalesOrderNo);
            IF Salesline.FindSet() then begin
                IF Confirm('Do you want to delete the existing lines?', true) then begin
                    InvoicingGateIns.Reset();
                    InvoicingGateIns.SetRange("Proforma Invoice No.", Salesline."Document No.");
                    if InvoicingGateIns.FindFirst() then
                        repeat
                            InvoicingGateIns.Delete();
                        until InvoicingGateIns.Next() = 0;
                    Salesline.DeleteAll()
                end else
                    exit;
            end;
            RemainingStock := 0;
            InvCBM := 0;
            TempWHLedger.Reset();
            if TempWHLedger.FindSet() then
                repeat
                    GetSalesHeader();
                    if Rec."Location Type" = Rec."Location Type"::"Bonded Warehouse" then begin
                        if TempWHLedger."Invoicing CBM/Weight" = 0 then
                            Error('Invoicing CBM/Weight must have a value');
                        if TempWHLedger."Invoicing Quantity" = 0 then
                            Error('Invoicing Quantity must have a value');
                    end;
                    StorageDays := SalesHead."Posting Date" - TempWHLedger."Posting Date";
                    ChargeID := GetChargeID(TempWHLedger, CustNo);
                    IMSSetup.Get();
                    IMSSetup.UpdateWHValues();
                    ChargeGroupLine.Reset();
                    ChargeGroupLine.SetRange("Charge ID Group Code", ChargeID);
                    ChargeGroupLine.SetRange("Active/In-Active", ChargeGroupLine."Active/In-Active"::Active);
                    ChargeGroupLine.CalcFields("Charge Category");
                    if StorageDays < IMSSetup."Re WareHousing Days" then
                        ChargeGroupLine.SetFilter("Charge Category", '<>%1', IMSSetup."Category for Re-Warehouse");
                    if SalesHead."Invoice Type" = SalesHead."Invoice Type"::"Gate Out" then
                        ChargeGroupLine.SetFilter("CalCulation Type", '%1|%2', ChargeGroupLine."CalCulation Type"::"Gate out", ChargeGroupLine."CalCulation Type"::Both);
                    ChargeGroupLine.SetFilter("Charge Category", '<>%1', IMSSetup."Category for Bond Cancellation");
                    // //if TempWHLedger."Container Size" = TempWHLedger."Container Size"::"20FT" then
                    //     ChargeGroupLine.SetFilter("Container Size", '<>%1', ChargeGroupLine."Container Size"::"40FT");
                    // //if TempWHLedger."Container Size" = TempWHLedger."Container Size"::"40FT" then
                    //     ChargeGroupLine.SetFilter("Container Size", '<>%1', ChargeGroupLine."Container Size"::"20FT");
                    IF ChargeGroupLine.FindFirst() then begin
                        repeat
                            Clear(ActualChargeAmount);
                            clear(MinimumChargeAmount);
                            Clear(StorageDays);
                            clear(ChargableStorageDays);
                            clear(CalculatedPeriod);
                            Clear(StorageStartDate);
                            Clear(SalesLineAmount);
                            Clear(ChargeableWHperiods);
                            Clear(ChargableRewarehousePeriods);
                            Clear(ChargedRewarehousePeriods);
                            Clear(ChargedWHPeriods);
                            Clear(SOPostingDate);
                            //IMSSetup.Get();
                            //IMSSetup.UpdateWHValues();
                            StorageStartDate := TempWHLedger."Posting Date";
                            SOPostingDate := SalesHead."Posting Date";
                            ChargeGroupLine.CalcFields("Charge Category");
                            // IF CheckIFInvoiced(ChargeGroupLine.Charge, TempWHLedger."Document No.", TempWHLedger."Document Line No.", TempWHLedger."Customs No.") THEN BEGIN
                            //     Message('Charges for Gate In No. %1 have already been calculated.', TempWHLedger."Document No.");
                            //     EXIT;
                            // END;
                            IF ChargeGroupLine."Based On CBM/ Weight" = false then begin
                                // AlreadyInvoiced := false;
                                // AlreadyExist := false;
                                StorageDays := SalesHead."Posting Date" - TempWHLedger."Posting Date";
                                ChargableStorageDays := StorageDays;
                                // AlreadyInvoiced := CheckIFInvoiced(ChargeGroupLine.Charge, TempWHLedger."Document No.", TempWHLedger."Document Line No.");
                                // if AlreadyInvoiced then
                                //     AlreadyExist := true
                                // else
                                //     AlreadyExist := false;
                                // if not AlreadyInvoiced then begin
                                AlreadyExist := false;
                                AlreadyExist := CheckSalesLineExist(TempWHLedger, ChargeGroupLine);
                                SalesLineAmount := ChargeGroupLine."First Interval";
                                if ChargeGroupLine."Charge Category" = IMSSetup."Category for Bond Acceptance" then begin
                                    IF GateInNo1 <> TempWHLedger."Document No." then begin
                                        SalesLineAmount := CalculateBondWHCharges(1, TempWHLedger, ChargeGroupLine);
                                    end;
                                end;
                                Imssetup.Get();
                                if IMSSetup."Re WareHousing Days" > 0 then
                                    CalculatedPeriod := Round((ChargableStorageDays / IMSSetup."Re WareHousing Days"), 1, '<');
                                ChargedRewarehousePeriods := CheckPostedStoragePeriodsCount(TempWHLedger."Document No.", ChargeGroupLine.Charge);
                                ChargableRewarehousePeriods := CalculatedPeriod - ChargedRewarehousePeriods;
                                ///  12/09/2024
                                if ChargableRewarehousePeriods > 0 then begin
                                    if ChargeGroupLine."Charge Category" = IMSSetup."Category for Re-Warehouse" then begin
                                        if ChargableStorageDays >= IMSSetup."Re WareHousing Days" then begin
                                            SalesLineAmount := CalculateBondWHCharges(2, TempWHLedger, ChargeGroupLine) * ChargableRewarehousePeriods;
                                            Message(Format(StorageDays));
                                        end;
                                    end;
                                end else
                                    AlreadyExist := true;

                            end;
                            // IMSSetup.Get();
                            // if ChargeGroupLine."Charge Category" = IMSSetup."Category for Customs Exam" then begin
                            //     AlreadyExist := false;
                            //     IF GateInNo1 <> TempWHLedger."Document No." then begin
                            //         SalesLineAmount := ChargeGroupLine."First Interval";
                            //     end else
                            //         AlreadyExist := true;
                            // end;
                            //Customs Start

                            IMSSetup.Get();
                            if ChargeGroupLine."Charge Category" = IMSSetup."Category for Customs Exam" then begin
                                AlreadyExist := false;
                                CustomsEntryFound := false;
                                WHLedgerEntry.Reset();

                                WHLedgerEntry.SetRange("Customs No.", SalesHead."Customs Entry No.");
                                WHLedgerEntry.SetRange("Warehouse Entry Type", WHLedgerEntry."Warehouse Entry Type"::Outward);
                                if WHLedgerEntry.FindFirst() then
                                    CustomsEntryFound := true
                                else
                                    CustomsEntryFound := false;
                                IF GateInNo1 <> TempWHLedger."Document No." then begin
                                    if not CustomsEntryFound then begin
                                        SalesLineAmount := ChargeGroupLine."First Interval";
                                    end else begin
                                        AlreadyExist := true; // Customs charge is not applied as entry exists
                                    end;
                                end else
                                    AlreadyExist := true;
                            end;
                            //Customs End
                            //Storage Charges Start
                            IF (ChargeGroupLine."Based On CBM/ Weight" = true) and (ChargeGroupLine."Rely On Storage" = true) then begin
                                AlreadyExist := false;
                                StorageDays := SOPostingDate - StorageStartDate;
                                if StorageDays = 0 then
                                    ChargableStorageDays := 1
                                else
                                    ChargableStorageDays := StorageDays;
                                if ChargeGroupLine."WH Calculation Days" <> 0 then
                                    CalculatedPeriod := Round((ChargableStorageDays / ChargeGroupLine."WH Calculation Days"), 1, '>')
                                else
                                    Error('Please setup Warehouse Calculation Days in Charge group %1 and Line No. %2 and recalculate the charges', ChargeGroupLine."Charge ID Group Code", ChargeGroupLine."Line No.");
                                //message('period %1', CalculatedPeriod);

                                // ChargeAmount := ChargeGroupLine."First Interval" * CalculatedPeriod * TempWHLedger."Invoicing CBM/Weight";
                                ///  12/09/2024
                                ChargedWHPeriods := CheckPostedPeriodsCount(TempWHLedger."Document No.", TempWHLedger."Document Line No.");
                                if TempWHLedger."Location Type" = TempWHLedger."Location Type"::"Bonded Warehouse" then
                                    ChargeableWHperiods := CalculatedPeriod - ChargedWHPeriods
                                else
                                    if TempWHLedger."Location Type" = TempWHLedger."Location Type"::"Free Warehouse" then
                                        ChargeableWHperiods := CalculatedPeriod;
                                ///  12/09/2024
                                //Message(Format(ChargedWHPeriods));
                                if ChargeableWHperiods <> 0 then begin
                                    //11-13-2025//for bonded warehouse charges calculation
                                    if TempWHLedger."Location Type" = TempWHLedger."Location Type"::"Bonded Warehouse" then
                                        ActualChargeAmount := ChargeGroupLine."First Interval" * TempWHLedger."Chargable CBM/Weight" * ChargeableWHperiods;
                                    //11-13-2025//for bonded warehouse chrges calculation End
                                    //11-13-2025 //for free warehouse chrges calculation
                                    if TempWHLedger."Location Type" = TempWHLedger."Location Type"::"Free Warehouse" then
                                        ActualChargeAmount := ChargeGroupLine."First Interval" * TempWHLedger."Invoicing CBM/Weight" * ChargeableWHperiods;
                                    //11-13-2025 //for free warehouse charges calculation End

                                    //Message(Format(ActualChargeAmount));
                                    //MinimumChargeAmount := ChargeGroupLine."Storage Minimum Charges" * ChargeableWHperiods * TempWHLedger.TEUs; //052125 changed based on James discussion. no need to use TEUs
                                    MinimumChargeAmount := ChargeGroupLine."Storage Minimum Charges" * ChargeableWHperiods;
                                    //Message(Format(MinimumChargeAmount));
                                    if ActualChargeAmount < MinimumChargeAmount then
                                        SalesLineAmount := MinimumChargeAmount
                                    else
                                        SalesLineAmount := ActualChargeAmount;
                                    // if ActualChargeAmount < ChargeGroupLine."Storage Minimum Charges" then
                                    //     SalesLineAmount := ChargeGroupLine."Storage Minimum Charges" * ChargeableWHperiods
                                    // else
                                    //     SalesLineAmount := ActualChargeAmount * ChargeableWHperiods;
                                    AlreadyExist := false;
                                end else
                                    AlreadyExist := true;
                            end;
                            //handling Charges Start
                            IF (ChargeGroupLine."Based On CBM/ Weight" = true) and (ChargeGroupLine."Rely On Storage" = false) then begin
                                AlreadyExist := false;
                                StorageDays := SOPostingDate - StorageStartDate;
                                ChargableStorageDays := StorageDays;
                                ActualChargeAmount := ChargeGroupLine."First Interval" * TempWHLedger."Invoicing CBM/Weight";
                                if ActualChargeAmount < ChargeGroupLine."Storage Minimum Charges" then
                                    SalesLineAmount := ChargeGroupLine."Storage Minimum Charges"
                                else
                                    SalesLineAmount := ActualChargeAmount;
                            end;
                            //handling Charges End
                            if not AlreadyExist then begin
                                LineNo := GetLineNo();
                                Salesline.Init;
                                Salesline.validate("Document Type", Salesline."Document Type"::Order);
                                Salesline.VAlidate("Document No.", SalesOrderNo);
                                Salesline.Validate("Line No.", LineNo);
                                Salesline.Insert();
                                Salesline.validate(Type, Salesline.Type::Item);
                                Salesline.Validate("No.", ChargeGroupLine.Charge);
                                Salesline.Description := ChargeGroupLine."Charge Description ";
                                Salesline.validate("Charge ID", ChargeID);
                                Salesline.validate("Gate In No.", TempWHLedger."Document No.");
                                Salesline.validate("Gate In Line No.", TempWHLedger."Document Line No.");
                                Salesline.validate(Warehouse, true);
                                Salesline.validate("Invoicing Quantity", TempWHLedger."Invoicing Quantity");
                                Salesline.validate("Invoicing CBM/Weight", TempWHLedger."Invoicing CBM/Weight");
                                Salesline.Validate("Container Size", TempWHLedger."Container Size");
                                Salesline.validate("Clearing Agent", TempWHLedger."Clearing Agent");
                                Salesline.validate("Clearing Agent Name", TempWHLedger."Clearing Agent Name");
                                Salesline.Validate(Quantity, 1);
                                Salesline.Validate("Unit Price", SalesLineAmount);
                                if TempWHLedger."Location Type" = TempWHLedger."Location Type"::"Free Warehouse" then
                                    Salesline.Validate("Business Type", Salesline."Business Type"::"Free Warehouse");
                                if TempWHLedger."Location Type" = TempWHLedger."Location Type"::"Bonded Warehouse" then
                                    Salesline.Validate("Business Type", Salesline."Business Type"::"Bonded Warehouse");
                                Salesline."Auto Calculated" := true;
                                Salesline."Storage Days" := StorageDays;
                                Salesline."Storage Start Date" := StorageStartDate;
                                Salesline."Chargable Storage Days" := StorageDays;
                                Salesline."Chargeable warehouse Periods" := ChargeableWHperiods;
                                Salesline."Chargeable ReWarehouse Periods" := ChargableRewarehousePeriods;
                                Salesline."Invoice Type" := SalesHead."Invoice Type";
                                Salesline."Customs Entry No." := SalesHead."Customs Entry No.";
                                Salesline."Consignment Value" := SalesHead."Consignment Value";
                                Salesline.Modify();
                            end;
                        until ChargeGroupLine.Next() = 0;
                    end;
                    WHouseAddCharges.Reset();
                    WHouseAddCharges.SetRange("Gate In No.", TempWHLedger."Document No.");
                    WHouseAddCharges.SetFilter("Charges Code", '<>%1', '');
                    WHouseAddCharges.SetRange("Invoice Type", WHouseAddCharges."Invoice Type"::"Gate Out");
                    IF WHouseAddCharges.FindFirst() then begin
                        repeat
                            if WHouseAddCharges.Rate = 0 then
                                Error('Please mention additional charge rate for %1 Gate In %2', WHouseAddCharges."Charges Code", WHouseAddCharges."Gate In No.");
                            PostedSalesInvLine.Reset();
                            PostedSalesInvLine.SetRange("Gate In No.", WHouseAddCharges."Gate In No.");
                            PostedSalesInvLine.SetRange(Type, PostedSalesInvLine.Type::Item);
                            PostedSalesInvLine.SetRange("Invoice Type", PostedSalesInvLine."Invoice Type"::"Gate Out");
                            PostedSalesInvLine.SetRange("No.", WHouseAddCharges."Charges Code");
                            if postedsalesinvline.findfirst then begin
                                PostedSalesCrLine.Reset();
                                PostedSalesCrLine.SetRange("Gate In No.", WHouseAddCharges."Gate In No.");
                                PostedSalesCrLine.SetRange(Type, PostedSalesCrLine.Type::Item);
                                PostedSalesCrLine.SetRange("No.", PostedSalesInvLine."No.");
                                if PostedSalesCrLine.findfirst then begin
                                    RecSalesLine.Reset();
                                    RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                                    RecSalesLine.SetRange("Document No.", SalesOrderNo);
                                    IF RecSalesLine.FindLast() then
                                        LineNo1 := RecSalesLine."Line No." + 10000;
                                    RecSalesLine.init;
                                    RecSalesLine."Document Type" := RecSalesLine."Document Type"::Order;
                                    RecSalesLine."Document No." := SalesOrderNo;
                                    RecSalesLine."Line No." := LineNo1;
                                    RecSalesLine.Type := RecSalesLine.Type::Item;
                                    RecSalesLine.validate("No.", WHouseAddCharges."Charges Code");
                                    RecSalesLine.Validate("Gate In Line No.", TempWHLedger."Document Line No.");
                                    RecSalesLine.Validate("Gate In No.", TempWHLedger."Document No.");
                                    RecSalesline.validate("Charge ID", ChargeID);
                                    RecSalesline.Validate(Quantity, 1);
                                    RecSalesLine.Validate("Unit Price", WHouseAddCharges.Rate);
                                    RecSalesLine.Validate("Invoice Type", WHouseAddCharges."Invoice Type");
                                    RecSalesLine.Validate("Storage Start Date", StorageStartDate);
                                    RecSalesLine.validate("Invoicing Quantity", TempWHLedger."Remaining Quantity");
                                    RecSalesLine.validate("Invoicing CBM/Weight", TempWHLedger."Remaining CBM/Weight");
                                    RecSalesline."Auto Calculated" := true;
                                    RecSalesLine.Warehouse := true;
                                    RecSalesLine.insert;
                                    LineNo1 += 10000;
                                end;
                            end else begin
                                RecSalesLine.Reset();
                                RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                                RecSalesLine.SetRange("Document No.", SalesOrderNo);
                                IF RecSalesLine.FindLast() then
                                    LineNo1 := RecSalesLine."Line No." + 10000;
                                RecSalesLine.init;
                                RecSalesLine."Document Type" := RecSalesLine."Document Type"::Order;
                                RecSalesLine."Document No." := SalesOrderNo;
                                RecSalesLine."Line No." := LineNo1;
                                RecSalesLine.Type := RecSalesLine.Type::Item;
                                RecSalesLine.validate("No.", WHouseAddCharges."Charges Code");
                                RecSalesLine.Validate("Gate In Line No.", TempWHLedger."Document Line No.");
                                RecSalesLine.Validate("Gate In No.", TempWHLedger."Document No.");
                                RecSalesline.validate("Charge ID", ChargeID);
                                RecSalesline.Validate(Quantity, 1);
                                RecSalesLine.Validate("Unit Price", WHouseAddCharges.Rate);
                                RecSalesLine.Validate("Invoice Type", WHouseAddCharges."Invoice Type");
                                RecSalesLine.Validate("Storage Start Date", StorageStartDate);
                                RecSalesLine.validate("Invoicing Quantity", TempWHLedger."Remaining Quantity");
                                RecSalesLine.validate("Invoicing CBM/Weight", TempWHLedger."Remaining CBM/Weight");
                                RecSalesline."Auto Calculated" := true;
                                RecSalesLine.Warehouse := true;
                                RecSalesLine.insert;
                                LineNo1 += 10000;
                            end;
                        until WHouseAddCharges.next = 0;
                    end;
                    GateInNo1 := TempWHLedger."Document No.";
                    GateInNo2 := TempWHLedger."Document No.";
                    CreateInvoicingGateIns(TempWHLedger);
                    RemainingStock += TempWHLedger."Remaining CBM/Weight" - TempWHLedger."Invoicing CBM/Weight";
                    InvCBM += TempWHLedger."Invoicing CBM/Weight";

                until TempWHLedger.NEXT = 0;

            //BondCancellation Code
            IMSSetup.Get();
            ChargeGroupLine.Reset();
            ChargeGroupLine.SetRange("Charge ID Group Code", ChargeID);
            ChargeGroupLine.SetRange("Active/In-Active", ChargeGroupLine."Active/In-Active"::Active);
            // Message(Format(RemainingStock));
            RemainingCBM := 0;
            BondWHLedger.Reset();
            BondWHLedger.SetRange("Document No.", SalesHead."Gate In No.");
            if BondWHLedger.FindFirst() then
                repeat
                    RemainingCBM += BondWHLedger."Remaining CBM/Weight";
                until BondWHLedger.Next() = 0;
            RemainingStock := RemainingCBM - InvCBM;
            // Message(Format(RemainingCBM));
            // Message(Format(InvCBM));
            // Message(Format(RemainingStock));
            if RemainingStock = 0 then
                ChargeGroupLine.SetRange("Charge Category", IMSSetup."Category for Bond Cancellation");
            IF ChargeGroupLine.FindFirst() then begin
                if RemainingStock = 0 then begin
                    RecSalesLine.Reset();
                    RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                    RecSalesLine.SetRange("Document No.", SalesOrderNo);
                    IF RecSalesLine.FindLast() then
                        //LineNo1 := RecSalesLine."Line No." + 10000;
                        RecSalesLine.init;
                    RecSalesLine."Document Type" := RecSalesLine."Document Type"::Order;
                    RecSalesLine."Document No." := SalesOrderNo;
                    RecSalesLine."Line No." := GetLineNo();
                    RecSalesLine.Type := RecSalesLine.Type::Item;
                    RecSalesLine.validate("No.", ChargeGroupLine.Charge);
                    // RecSalesLine.Validate("Gate In Line No.", TempWHLedger."Document Line No.");
                    RecSalesLine.Validate("Gate In No.", SalesHead."Gate In No.");
                    RecSalesline.validate("Charge ID", ChargeGroupLine."Charge ID Group Code");
                    RecSalesline.Validate(Quantity, 1);
                    RecSalesLine.Validate("Unit Price", ChargeGroupLine."First Interval");
                    RecSalesLine.Validate("Container Size", ChargeGroupLine."Container Size");
                    RecSalesLine.Validate("Invoice Type", SalesHead."Invoice Type");
                    RecSalesline."Auto Calculated" := true;
                    RecSalesLine.Warehouse := true;
                    RecSalesLine.insert;
                    //LineNo1 += 10000;
                end;
            end;
            // //BondCancellation Code
        end;
        message(SuccessMessage);
        RecSalesLine.Reset();
        CurrPage.UPDATE(false);
    END;



    procedure GetChargeID(var
                              WHL: Record "Warehouse Item Ledger Entry";
                              NewCustNo: Code[20]) returnvalue: code[20]
    var
        WHChargeIDAssRec: Record "Warehouse ChargeID Assignment";
    begin
        WHChargeIDAssRec.reset();
        WHChargeIDAssRec.SetRange("Customer No.", NewCustNo);

        if WHL."Location Type" = WHL."Location Type"::"Free Warehouse" then
            WHChargeIDAssRec.SetRange(WHChargeIDAssRec."Business Type", WHChargeIDAssRec."Business Type"::"Free Warehouse");
        if WHL."Location Type" = WHL."Location Type"::"Bonded Warehouse" then begin
            WHChargeIDAssRec.SetRange(WHChargeIDAssRec."Business Type", WHChargeIDAssRec."Business Type"::"Bonded Warehouse");
            WHChargeIDAssRec.SetRange(WHChargeIDAssRec."Clearing Agent Code", WHL."Clearing Agent");
        end;
        WHChargeIDAssRec.SetFilter("Effective From Date", '<=%1', WHL."Posting Date");
        WHChargeIDAssRec.SetFilter("Effective To Date", '>=%1', WHL."Posting Date");
        IF WHChargeIDAssRec.FindFirst() then begin
            WHChargeIDAssRec.CalcFields(Status);
            if (WHChargeIDAssRec.Status <> WHChargeIDAssRec.Status::Released) or (WHChargeIDAssRec."Assignment Status" <> WHChargeIDAssRec."Assignment Status"::Released) then
                Error('Charge Group: %1 Approval Status is %2. \ Charge ID Assignment Approval Status is %3. \ for Container ID: %4. Please contact Group Audit.', WHChargeIDAssRec."Charge Id Group Code", WHChargeIDAssRec.Status, WHChargeIDAssRec."Assignment Status", WHL."Document No.")
            else
                exit(WHChargeIDAssRec."Charge Id Group Code");
        end
        else
            error('Charge Group or Charge ID Assignment does not exist with the mentioned specifications for Container  %1. \ Please check Charge ID assignment and try again', WHL."Document No.");
    end;

    procedure GetSalesOrderNo(var NewSalesHeadNo: Code[20]; Var NewCustNo: Code[20])

    begin
        SalesOrderNo := NewSalesHeadNo;
        CustNo := NewCustNo;
    end;

    procedure CheckIFInvoiced(ItemNo: code[20]; GateInNo: Code[20]; GateInLineNo: Integer; CustomsEntryNo: Code[20]) lAlreadyInvoiced: Boolean;
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrLine: Record "Sales Cr.Memo Line";
    begin
        lAlreadyInvoiced := false;
        SalesInvLine.Reset();
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        SalesInvLine.SetRange("No.", ItemNo);
        SalesInvLine.SetRange("Gate In No.", GateInNo);
        SalesInvLine.SetRange("Invoice Type", SalesInvLine."Invoice Type"::"Gate Out");
        SalesInvLine.SetRange("Gate In Line No.", GateInLineNo);
        SalesInvLine.SetRange("Customs Entry No.", CustomsEntryNo);
        if SalesInvLine.FindFirst() then
            lAlreadyInvoiced := true;

        SalesCrLine.Reset();
        SalesCrLine.SetRange(Type, SalesCrLine.Type::Item);
        SalesCrLine.SetRange("No.", ItemNo);
        SalesCrLine.SetRange("Gate In No.", GateInNo);
        SalesCrLine.SetRange("Invoice Type", SalesCrLine."Invoice Type"::"Gate Out");
        SalesCrLine.SetRange("Gate In Line No.", GateInLineNo);
        SalesCrLine.SetRange("Customs Entry No.", CustomsEntryNo);
        if SalesCrLine.FindFirst() then
            lAlreadyInvoiced := false;
        exit(lAlreadyInvoiced);
    end;

    procedure CalculateBondWHCharges(Category: Integer; TemWHL: Record "Warehouse Item Ledger Entry"; CGL: Record "Charge ID Group Line"): Decimal
    var
        BACAmounttemp, BACAmount : Decimal;
        RewarehouseAmounttemp, RewarehouseAmount : decimal;
        ImseSetup: Record "IMS Setup";
    begin
        ImseSetup.Get();
        BACAmounttemp := TemWHL."Consignment Value" * ImseSetup.BIF / 100;
        if BACAmounttemp < CGL."Storage Minimum Charges" then
            BACAmount := CGL."Storage Minimum Charges"
        else
            BACAmount := BACAmounttemp;
        RewarehouseAmounttemp := ImseSetup."Rewarehouse Per Entry Charge" + BACAmount;
        if RewarehouseAmounttemp < CGL."Storage Minimum Charges" then
            RewarehouseAmount := CGL."Storage Minimum Charges"
        else
            RewarehouseAmount := RewarehouseAmounttemp;
        if Category = 1 then
            exit(BACAmount);
        if Category = 2 then
            exit(RewarehouseAmount);
    end;

    procedure CheckSalesLineExist(TemWHL: Record "Warehouse Item Ledger Entry"; CGL: Record "Charge ID Group Line"): Boolean
    var
        Salesline2: Record "Sales Line";
    begin
        Salesline2.Reset();
        Salesline2.SetRange("Document No.", SalesOrderNo);
        Salesline2.SetRange("Gate In No.", TemWHL."Document No.");
        Salesline2.SetRange(Type, Salesline2.Type::Item);
        Salesline2.SetRange("No.", CGL.Charge);
        if Salesline2.FindFirst() then
            exit(true)
        else
            exit(false);
    end;

    procedure CheckIfGateInCharges()
    var
    begin


    end;

    procedure CheckPostedPeriodsCount(GateInNo: Code[20]; GateInLineNo: Integer) PostedPeriodCount: Integer
    var
        PSIVLine: Record "Sales Invoice Line";
        PSCRLine: Record "Sales Cr.Memo Line";
        InvCount, CrCount : Integer;
    begin
        Clear(InvCount);
        Clear(CrCount);
        Clear(PostedPeriodCount);
        PSIVLine.Reset();
        PSIVLine.SetRange("Gate In No.", GateInNo);
        PSIVLine.SetRange("Gate In Line No.", GateInLineNo);
        if PSIVLine.FindFirst() then
            repeat
                InvCount += PSIVLine."Chargeable warehouse Periods";
            until PSIVLine.Next() = 0;
        PSCRLine.Reset();
        PSCRLine.SetRange("Gate In No.", GateInNo);
        PSCRLine.SetRange("Gate In Line No.", GateInLineNo);
        if PSCRLine.FindFirst() then
            repeat
                CrCount += PSCRLine."Chargeable warehouse Periods";
            until PSCRLine.Next() = 0;
        PostedPeriodCount := InvCount - CrCount;
        exit(PostedPeriodCount);
    end;

    procedure CheckPostedStoragePeriodsCount(GateInNo: Code[20]; RWChargeCode: code[20]) PostedStoragePeriodsCount: Integer
    var
        PSIVLine: Record "Sales Invoice Line";
        PSCRLine: Record "Sales Cr.Memo Line";
        InvDaysCount, CrDaysCount : Integer;
    begin
        Clear(InvDaysCount);
        Clear(CrDaysCount);
        Clear(PostedStoragePeriodsCount);
        PSIVLine.Reset();
        PSIVLine.SetRange("Gate In No.", GateInNo);
        PSIVLine.SetRange("No.", RWChargeCode);
        if PSIVLine.FindFirst() then
            repeat
                InvDaysCount += PSIVLine."Chargeable ReWarehouse Periods";
            until PSIVLine.Next() = 0;
        PSCRLine.Reset();
        PSCRLine.SetRange("Gate In No.", GateInNo);
        PSCRLine.SetRange("No.", RWChargeCode);
        if PSCRLine.FindFirst() then
            repeat
                CrDaysCount += PSCRLine."Chargeable ReWarehouse Periods";
            until PSCRLine.Next() = 0;
        PostedStoragePeriodsCount := InvDaysCount - CrDaysCount;
        exit(PostedStoragePeriodsCount);
    end;



    procedure GetSalesHeader()
    var
    begin
        SalesHead.Reset();
        SalesHead.SetRange("Document Type", SalesHead."Document Type"::Order);
        SalesHead.SetRange("No.", SalesOrderNo);
        IF SalesHead.FindFirst() then;
    end;

    procedure GetLineNo() l_LineNo: Integer
    var
        Salesline: Record "Sales Line";
    begin
        l_LineNo := 0;
        Salesline.Reset();
        Salesline.SetRange("Document Type", Salesline."Document Type"::Order);
        Salesline.SetRange("Document No.", SalesOrderNo);
        IF Salesline.Findlast() then
            l_LineNo := Salesline."Line No." + 10000
        else
            l_LineNo := 10000;
        exit(l_LineNo);
    end;



    local procedure CreateInvoicingGateIns(g_WHLedger: Record "Warehouse Item Ledger Entry")
    var
        InvoicingGatein: Record "Invoicing Gate Ins";
        EntryNo: Integer;
    begin
        InvoicingGatein.Reset();
        if InvoicingGatein.FindLast() then
            EntryNo := InvoicingGatein."Entry No." + 1
        else
            EntryNo := 1;
        InvoicingGatein.Init();
        InvoicingGatein."Entry No." := EntryNo;
        InvoicingGatein."Activity Date" := SalesHead."Posting Date";
        InvoicingGatein."Gate In No." := g_WHLedger."Document No.";
        InvoicingGatein."Location Type" := g_WHLedger."Location Type";
        InvoicingGatein."Gate In Line No." := g_WHLedger."Document Line No.";
        InvoicingGatein."Proforma Invoice No." := SalesOrderNo;
        InvoicingGatein."Description Of The Goods" := g_WHLedger."Description Of The Goods";
        InvoicingGatein."Warehouse Entry No." := g_WHLedger."Entry No.";
        InvoicingGatein."Invoicing Quantity" := g_WHLedger."Invoicing Quantity";
        InvoicingGatein."Invoicing CBM/Weight" := g_WHLedger."Invoicing CBM/Weight";
        InvoicingGatein."Location Code" := g_WHLedger."Location Code";
        InvoicingGatein."Consignee No." := g_WHLedger."Consignee No.";
        InvoicingGatein."Consignee Name" := g_WHLedger."Consignee Name";
        InvoicingGatein."Container Size" := g_WHLedger."Container Size";
        InvoicingGatein."Invoice Type" := InvoicingGatein."Invoice Type"::"Gate Out";
        InvoicingGatein."Customs Entry No." := SalesHead."Customs Entry No.";
        InvoicingGatein."Consignment Value Released" := SalesHead."Consignment Value";
        InvoicingGatein.Insert();
    end;

    trigger OnOpenPage()
    var
        IMSSetup: Record "IMS Setup";
    begin
        CurrPage.Editable(true);
        if Rec.FindFirst() then
            repeat
                Rec."Invoicing CBM/Weight" := 0;
                Rec."Invoicing Quantity" := 0;
                Rec.Modify();
            until rec.Next() = 0;
        IMSSetup.Get();
        IMSSetup.UpdateWHValues();
    end;

    var
        SalesHead: Record "Sales Header";
        SalesOrderNo, CustNo : Code[20];
        SOPostingDate: Date;
        Category: Code[20];
        TempWHLedger: Record "Warehouse Item Ledger Entry" temporary;
        Desc: Text[200];
        InvQty, InvCBMWeight : Decimal;
        Gatein: Record "WH Gate In Header";
}
