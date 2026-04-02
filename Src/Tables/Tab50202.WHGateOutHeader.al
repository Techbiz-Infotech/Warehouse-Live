table 50202 "WH Gate Out Header"
{
    Caption = 'Warehouse Gate Out Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Gate Out No."; Code[20])
        {
            Caption = 'Gate Out No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "Gate Out No." <> xRec."Gate Out No." THEN BEGIN
                    IMSSetup.GET;
                    NoSeriesMngnt.TestManual(IMSSetup."Gate Out Nos.");
                    "No.Series" := '';
                END;
            end;
        }
        field(2; "Activity Date"; Date)
        {
            Caption = 'Activity Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Activity Time"; Time)
        {
            Caption = 'Activity Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Gate Out Status"; Enum "Active/In-Active Enum")
        {
            Caption = 'Gate Out Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Consignee No."; Code[20])
        {
            Caption = 'Consignee No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if Cust.get(Rec."Consignee No.") then
                    "Consignee Name" := Cust.Name
                else
                    "Consignee Name" := '';
            end;
        }
        field(6; "Consignee Name"; Text[100])
        {
            Caption = 'Consignee Name ';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Consignment Value to Release"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Imssetup: Record "IMS Setup";
                PostedgateInheader: Record "WH Gate In Header";
                PostedGateoutheader: Record "WH Gate Out Header";
                GateInConsigneValue: Decimal;
            begin
                Imssetup.Get();
                PostedgateInheader.Reset();
                PostedgateInheader.SetRange("Location Type", PostedgateInheader."Location Type"::"Bonded Warehouse");
                PostedgateInheader.SetRange(Posted, true);
                if PostedgateInheader.FindFirst() then
                    repeat
                        GateInConsigneValue := PostedgateInheader."Consignment Value";
                    until PostedgateInheader.Next() = 0;
                "Remaining Bond value" := Imssetup."Warehouse Allowed Limit" - GateInConsigneValue + "Consignment Value to Release";
                //Message('remaining value %1', "Remaining Bond value");
            end;
        }
        field(9; "Clearing Agent"; Code[20])
        {
            Caption = 'Clearing Agent';
            DataClassification = ToBeClassified;
            TableRelation = "Clearing Agent";
            trigger OnValidate()
            var
                ClearingAgent: Record "Clearing Agent";
            begin
                if ClearingAgent.get("Clearing Agent") then
                    "Clearing Agent Name" := ClearingAgent."Clearing Agent Name"
                else
                    "Clearing Agent Name" := '';
            end;
        }
        field(10; "Clearing Agent Name"; Text[100])
        {
            Caption = 'Clearing Agent Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Customs No."; Code[20])
        {
            Caption = 'Customs No.';
            DataClassification = ToBeClassified;
        }
        field(12; Transporter; Code[20])
        {
            Caption = 'Transporter';
            DataClassification = ToBeClassified;
        }
        field(13; "No.series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(15; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }

        field(16; "Location Type"; enum "Location Type")
        {
            Caption = 'Location Type';
            DataClassification = ToBeClassified;
        }
        field(17; "Printed"; Boolean)
        {
            Caption = 'Printed';
            DataClassification = ToBeClassified;
        }
        field(19; "Additional Remarks"; Text[250])
        {
            Caption = 'Additional Remarks';
            DataClassification = ToBeClassified;
        }
        field(20; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            // Editable = false;

        }
        field(21; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversed';
        }
        field(22; Approved; Boolean)
        {
            Caption = 'Approved';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            DataClassification = ToBeClassified;
            TableRelation = User;
            Editable = false;
        }
        field(24; "Approved Date Time"; DateTime)
        {
            Caption = 'Approved Date Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(25; "Remaining Bond value"; Decimal)
        {
            Caption = 'Remaining Bond value';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Gate Out No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Gate Out No." = '' then
            IMSSetup.Get();
        IMSSetup.TestField("Gate Out Nos.");
        //NoSeriesMngnt.InitSeries(IMSSetup."Gate Out Nos.", xRec."No.series", 0D, "Gate Out No.", "No.series");
        "No.Series" := Imssetup."Gate Out Nos.";
        if NoSeriesMngnt.AreRelated(Imssetup."Vehicle Nos", xRec."No.Series") then
            "No.Series" := xRec."No.Series";
        "Gate Out No." := NoSeriesMngnt.GetNextNo("No.Series");
        rec."Activity Date" := Today();
        rec."Activity Time" := Time;
    end;

    var
        IMSSetup: Record "IMS Setup";
        NoSeriesMngnt: Codeunit "No. Series";

    procedure AssistEdit(var GateOutRec: Record "WH Gate Out Header"): Boolean
    var
        GateOutNo: Record "WH Gate Out Header";
    begin
        with GateOutNo do begin
            GateOutNo := Rec;
            IMSSetup.Get();
            IMSSetup.TestField("Gate Out Nos.");
            if NoSeriesMngnt.LookupRelatedNoSeries(IMSSetup."Gate Out Nos.", GateOutRec."No.series", "No.series") then begin
                NoSeriesMngnt.GetNextNo("Gate Out No.");
                Rec := GateOutNo;
                exit(true);
            end;
        end;
    end;

    procedure GetGateOutLines()
    var
        InvoicingGateIns: Record "Invoicing Gate Ins";
        LineNo: Integer;
        GateOutLine2, GateOutLine : Record "WH Gate Out Line";
        WarehouseLedger: Record "Warehouse Item Ledger Entry";
        WHGateInLine: Record "WH Gate In Line";
        Receiptno: code[20];
    begin
        TestField("Location Type");
        if "Location Type" = "Location Type"::"Bonded Warehouse" then
            TestField("Consignment Value to Release");
        TestField("Clearing Agent");
        GateOutLine2.Reset();
        GateOutLine2.SetRange("Gate Out No.", Rec."Gate Out No.");
        IF GateOutLine2.FindSet() then begin
            IF Confirm('Do you want to delete the existing lines?', true) then
                GateOutLine2.DeleteAll()
            else
                exit;
        end;
        InvoicingGateIns.Reset();
        InvoicingGateIns.SetRange(Posted, true);
        InvoicingGateIns.SetRange("Consignee No.", Rec."Consignee No.");
        InvoicingGateIns.SetRange("Location Type", Rec."Location Type");
        InvoicingGateIns.SetRange(Reversed, false);
        InvoicingGateIns.SetRange("Gated Out", false);
        InvoicingGateIns.SetRange("Gate Out Charges", true);
        if InvoicingGateIns.FindFirst() then begin
            repeat
                clear(Receiptno);
                if WarehouseLedger.get(InvoicingGateIns."Warehouse Entry No.") then;
                Receiptno := GetReceiptNo(InvoicingGateIns."Posted Invoice No.");
                LineNo += 10000;
                // if not Rec.Approved then begin
                if Receiptno <> '' then begin
                    GateOutLine.Init();
                    GateOutLine.Validate("Gate Out No.", Rec."Gate Out No.");
                    GateOutLine.validate("Line No.", LineNo);
                    GateOutLine.Validate("Activity Date", Rec."Activity Date");
                    GateOutLine.Validate("Activity Time", Rec."Activity Time");
                    GateOutLine.validate("Gate In Reference Line No.", InvoicingGateIns."Gate In Line No.");
                    GateOutLine.Validate("Gate In Reference No.", InvoicingGateIns."Gate In No.");
                    GateOutLine.validate("Description Of The Goods", WarehouseLedger."Description Of The Goods");
                    GateOutLine.Validate("Gate In CBM", WarehouseLedger.CBM);
                    GateOutLine.Validate("Gate In Quantity", WarehouseLedger.Quantity);
                    GateOutLine.Validate("Gate In Weight", WarehouseLedger.Weight);
                    GateOutLine.Validate("Invoiced CBM/Weight", InvoicingGateIns."Invoicing CBM/Weight");
                    GateOutLine.Validate("Invoiced Quantity", InvoicingGateIns."Invoicing Quantity");
                    GateOutLine.Validate("Invoiced WH Stripped Qty", InvoicingGateIns."Invoicing WH Stripped Qty");
                    GateOutLine.Validate("Invoice No.", InvoicingGateIns."Posted Invoice No.");
                    GateOutLine.Validate("Invoice Date", InvoicingGateIns."Activity Date");
                    GateOutLine.Validate("Location Code", InvoicingGateIns."Location Code");
                    GateOutLine.Validate("Shelf No.", WarehouseLedger."Shelf No.");
                    GateOutLine.Validate("Customs No.", InvoicingGateIns."Customs Entry No.");
                    GateOutLine.Validate("Consignment Value", InvoicingGateIns."Consignment Value Released");
                    GateOutLine.Validate("Chargeable warehouse Periods", InvoicingGateIns."Chargeable warehouse Periods");
                    GateOutLine.Validate("Receipt No.", Receiptno);
                    GateOutLine.Insert();
                end;
            // end;
            until InvoicingGateIns.Next() = 0;
        end else
            Error('Gate Out Invoiced Lines not found for the Consignee %1', Rec."Consignee Name");
    end;

    procedure GetReceiptNo(InvNo: code[20]) ReceiptNo: code[20];
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustLedgEntry: Record "Cust. Ledger Entry";
        GateOutLineRec: Record "WH Gate Out Line";
    begin
        clear(ReceiptNo);
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Document No.", InvNo);
        CustLedgEntry.SetRange(Open, false);
        IF CustLedgEntry.FindFirst() then begin
            ApplyCustLedgEntry.Reset();
            ApplyCustLedgEntry.SetRange("Entry No.", CustLedgEntry."Closed by Entry No.");
            if ApplyCustLedgEntry.FindFirst() then begin
                ReceiptNo := ApplyCustLedgEntry."Document No.";
            end;
        end else
            Message('Receipt not found');
        exit(ReceiptNo);
    end;

}