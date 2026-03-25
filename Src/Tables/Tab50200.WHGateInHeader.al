table 50200 "WH Gate In Header"
{
    Caption = 'WH Gate In Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                GateInHead: Record "WH Gate In Header";
            begin

                if "Gate In No." <> xRec."Gate In No." then
                    if not GateInHead.Get(Rec."Gate In No.") then begin
                        IMSSetup.Get();
                        NoSeries.TestManual(IMSSetup."Gate In NoS.");
                        "No. series" := '';
                    end;
            end;
        }
        field(2; "Activity Date"; Date)
        {
            Caption = 'Activity Date';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if "Activity Date" > Today then
                    Error('Future Date is not Allowed');
            end;
            //Editable = false;
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
                CustomerRec: Record Customer;
                WHLedger: Record "Warehouse Item Ledger Entry";
            begin
                if CustomerRec.Get("Consignee No.") then
                    "Consignee Name" := CustomerRec.Name
                else
                    "Consignee Name" := '';


            end;
        }
        field(6; "Consignee Name"; Text[100])
        {
            Caption = 'Consignee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Consignment Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                IMSSetup.Get();
                IMSSetup.UpdateWHValues();
                if rec."Consignment Value" > IMSSetup."Warehouse Available Limit" then
                    Error('There is no Available limit. Please contact Group Audit')

            end;
        }
        field(9; "Clearing Agent"; Code[20])
        {
            Caption = 'Clearing Agent';
            TableRelation = "Clearing Agent";
            DataClassification = ToBeClassified;
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
        }
        field(11; "Customs No."; Code[20])
        {
            Caption = 'Customs No.';
            DataClassification = ToBeClassified;
        }
        field(12; "Truck No."; Code[20])
        {
            Caption = 'Truck No.';
            DataClassification = ToBeClassified;
        }
        field(14; "Location Type"; enum "Location Type")
        {
            Caption = 'Location Type';
            DataClassification = ToBeClassified;
        }
        field(13; "No. series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(19; "Additional Remarks"; Text[250])
        {
            Caption = 'Additional Remarks';
            DataClassification = ToBeClassified;
        }
        field(15; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(16; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
        }
    }
    keys
    {
        key(PK; "Gate In No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        GateinHead: Record "WH Gate In Header";
    begin
        if "Gate In No." = '' then begin
            IMSSetup.Get();
            IMSSetup.TestField("Gate In Nos.");
            "No. Series" := IMSSetup."Gate In Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Gate In No." := NoSeries.GetNextNo("No. Series");
            GateinHead.ReadIsolation(IsolationLevel::ReadUncommitted);
            GateinHead.SetLoadFields("Gate In No.");
            while GateinHead.Get("Gate In No.") do
                "Gate In No." := NoSeries.GetNextNo("No. Series");
            // if "Activity Date" > Today then
            //     Error('Future date is not allowed');
            //rec."Activity Date" := Today();
            rec."Activity Time" := Time;
        end;

    end;


    var
        IMSSetup: Record "IMS Setup";
        NoSeries: Codeunit "No. Series";

    procedure AssistEdit(var OldGateInRec: Record "WH Gate In Header"): Boolean
    var
        GateIn: Record "WH Gate In Header";
    begin
        GateIn := Rec;
        IMSSetup.Get();
        IMSSetup.TestField("Gate In Nos.");
        if NoSeries.LookupRelatedNoSeries(IMSSetup."Gate In Nos.", OldGateInRec."No. Series", GateIn."No. Series") then begin
            GateIn."Gate In No." := NoSeries.GetNextNo(GateIn."No. Series");
            Rec := GateIn;
            exit(true);
        end;
    end;

    procedure UpdatePostedWarehouseGateIn()
    var
        WHLedgerEntry1, WHLedgerEntry : Record "Warehouse Item Ledger Entry";
        GateInLine: Record "WH Gate In Line";
        EntryNo: Integer;
    begin
        if rec.Posted then begin
            WHLedgerEntry.Reset();
            WHLedgerEntry.SetRange("Document No.", rec."Gate In No.");
            WHLedgerEntry.SetRange("Warehouse Entry Type", WHLedgerEntry."Warehouse Entry Type"::Inward);
            if WHLedgerEntry.FindFirst() then begin
                GateInLine.Reset();
                GateInLine.SetRange("Gate In No.", WHLedgerEntry."Document No.");
                if GateInLine.FindFirst() then begin
                    repeat
                        WHLedgerEntry.Validate("Posting Date", Rec."Activity Date");
                        WHLedgerEntry.Validate("Document Line No.", GateInLine."Line No.");
                        WHLedgerEntry.Validate("Description Of The Goods", GateInLine."Description Of The Goods");
                        WHLedgerEntry.Validate("Location Code", GateInLine."Location Code");
                        WHLedgerEntry.Validate("Consignee No.", Rec."Consignee No.");
                        WHLedgerEntry.Validate("Consignee Name", Rec."Consignee Name");
                        WHLedgerEntry.Validate("Consignment Value", Rec."Consignment Value");
                        WHLedgerEntry.Validate("Clearing Agent", Rec."Clearing Agent");
                        WHLedgerEntry.Validate("Clearing Agent Name", Rec."Clearing Agent Name");
                        WHLedgerEntry.Validate("Location Type", Rec."Location Type");
                        WHLedgerEntry.Validate("Shelf No.", GateInLine."Shelf No.");
                        WHLedgerEntry.Validate("Customs No.", Rec."Customs No.");
                        WHLedgerEntry.Validate(Quantity, GateInLine.Quantity);
                        WHLedgerEntry.Validate(Weight, GateInLine.Weight);
                        WHLedgerEntry.Validate(CBM, GateInLine.CBM);
                        WHLedgerEntry.Validate("Weight/CBM", GateInLine."Weight/CBM");
                        WHLedgerEntry.Validate("Container Size", GateInLine."Container Size");
                        WHLedgerEntry.Validate(TEUs, GateInLine.TEUs);
                        WHLedgerEntry.Validate("Chargable CBM/Weight", GateInLine."Chargable CBM/Weight");
                        WHLedgerEntry.Modify();
                    until GateInLine.Next() = 0;

                end;
            end;
        end;
    end;

    procedure PostWarehouseGateIn()
    var
        WHLedgerEntry1, WHLedgerEntry : Record "Warehouse Item Ledger Entry";
        GateInLine: Record "WH Gate In Line";
        EntryNo: Integer;

    begin
        if "Location Type" = "Location Type"::"Bonded Warehouse" then begin
            TestField("Consignment Value");
            TestField("Clearing Agent");
        end;

        if Confirm('Do you want to post Warehouse Gate In Order?', false) then begin
            GateInLine.Reset();
            GateInLine.SetRange("Gate In No.", Rec."Gate In No.");
            if GateInLine.FindFirst() then begin
                repeat
                    WHLedgerEntry1.Reset();
                    if WHLedgerEntry1.FindLast() then
                        EntryNo := WHLedgerEntry1."Entry No." + 1
                    else
                        EntryNo := 1;
                    WHLedgerEntry.Init();
                    WHLedgerEntry.Validate("Entry No.", EntryNo);
                    WHLedgerEntry.Validate("Warehouse Entry Type", WHLedgerEntry."Warehouse Entry Type"::Inward);
                    WHLedgerEntry.Validate("Posting Date", Rec."Activity Date");
                    WHLedgerEntry.Validate("Document No.", Rec."Gate In No.");
                    WHLedgerEntry.Validate("Document Line No.", GateInLine."Line No.");
                    WHLedgerEntry.Validate("Description Of The Goods", GateInLine."Description Of The Goods");
                    WHLedgerEntry.Validate("Location Code", GateInLine."Location Code");
                    WHLedgerEntry.Validate("Consignee No.", Rec."Consignee No.");
                    WHLedgerEntry.Validate("Consignee Name", Rec."Consignee Name");
                    WHLedgerEntry.Validate("Consignment Value", Rec."Consignment Value");
                    WHLedgerEntry.Validate("Clearing Agent", Rec."Clearing Agent");
                    WHLedgerEntry.Validate("Clearing Agent Name", Rec."Clearing Agent Name");
                    WHLedgerEntry.Validate("Location Type", Rec."Location Type");
                    WHLedgerEntry.Validate("Shelf No.", GateInLine."Shelf No.");
                    WHLedgerEntry.Validate("Customs No.", Rec."Customs No.");
                    WHLedgerEntry.Validate(Quantity, GateInLine.Quantity);
                    WHLedgerEntry.Validate(Weight, GateInLine.Weight);
                    WHLedgerEntry.Validate(CBM, GateInLine.CBM);
                    WHLedgerEntry.Validate("Weight/CBM", GateInLine."Weight/CBM");
                    WHLedgerEntry.Validate("Container Size", GateInLine."Container Size");
                    WHLedgerEntry.Validate(TEUs, GateInLine.TEUs);
                    WHLedgerEntry.Validate("Chargable CBM/Weight", GateInLine."Chargable CBM/Weight");
                    WHLedgerEntry.Validate(Open, true);
                    WHLedgerEntry.Validate(Positive, true);
                    //WHLedgerEntry.Validate("Applied Document No.", GateInLine."Gate In No.");
                    //WHLedgerEntry.Validate("Applied Document Line No.", GateInLine."Line No.");
                    WHLedgerEntry.Insert();
                until GateInLine.Next() = 0;
                Rec.Posted := true;
                Rec.Modify();
                Message('Warehouse Gate In Order posted successfully');
            end;
        end;
    end;
}
