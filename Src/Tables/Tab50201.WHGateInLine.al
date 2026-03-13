table 50201 "WH Gate In Line"
{
    Caption = 'Warehouse Gate In Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Gate In No."; Code[20])
        {
            Caption = 'Gate In No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get("Item No.") then
                    "Description Of The Goods" := ItemRec.Description;
            end;
        }
        field(4; "Description Of The Goods"; Text[250])
        {
            Caption = 'Description Of The Goods';
            DataClassification = ToBeClassified;

        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(6; "Shelf No."; Code[20])
        {
            Caption = 'Shelf No.';
            DataClassification = ToBeClassified;
        }
        field(7; Weight; Decimal)
        {
            Caption = 'Weight';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                WtInTon: Decimal;
                IMSSetup: Record "IMS Setup";
            begin
                IMSSetup.Get();
                //052125
                GetHeader();
                if GateInHead."Location Type" = GateInHead."Location Type"::"Bonded Warehouse" then begin
                    if "Shortcut Dimension 5 Code" = '20FT' then
                        if CBM > IMSSetup."20FT" then
                            Error('CBM should not be more than 32 for 20FT Container');
                    if "Shortcut Dimension 5 Code" = '40FT' then
                        if CBM > 64 then
                            Error('CBM should not be more than 64 for 40FT Container');
                end;
                //052125


                if Weight = 0 then
                    "Weight/CBM" := 0;
                Clear(WtInTon);
                if (Weight <> 0) or (CBM <> 0) then begin
                    WtInTon := rec.Weight / 1000;

                    if rec.CBM >= WtInTon then
                        rec.Validate("Weight/CBM", CBM)
                    else
                        //if rec."CBM Tonage" <= rec.Weight then
                        Rec.Validate("Weight/CBM", WtInTon);
                end;
            end;
        }
        field(8; CBM; Decimal)
        {
            Caption = 'CBM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                WtInTon: Decimal;
                IMSSetup: Record "IMS Setup";
            begin
                IMSSetup.Get();
                //052125
                GetHeader();
                if GateInHead."Location Type" = GateInHead."Location Type"::"Bonded Warehouse" then begin
                    if "Shortcut Dimension 5 Code" = '20FT' then begin
                        Rec.TEUs := 1;
                        if CBM > IMSSetup."20FT" then
                            Error('CBM should not be more than 32 for 20FT Container');
                    end;
                    if "Shortcut Dimension 5 Code" = '40FT' then begin
                        Rec.TEUs := 2;
                        if CBM > 64 then
                            Error('CBM should not be more than 64 for 40FT Container');
                    end;
                    //052125
                end;
                if CBM = 0 then
                    "Weight/CBM" := 0;

                Clear(WtInTon);
                if (Weight <> 0) or (CBM <> 0) then begin
                    WtInTon := rec.Weight / 1000;
                    if rec.CBM >= WtInTon then
                        rec.Validate("Weight/CBM", CBM)
                    else
                        //if rec."CBM Tonage" <= rec.Weight then
                        Rec.Validate("Weight/CBM", WtInTon);

                end;

            end;
        }
        field(9; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(10; "Activity Date"; Date)
        {
            Caption = 'Activity Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Activity Time"; Time)
        {
            Caption = 'Activity Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Gate Out Status"; Enum "Active/In-Active Enum")
        {
            Caption = 'Gate Out Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Additional Remarks"; Text[250])
        {
            Caption = 'Additional Remarks';
            DataClassification = ToBeClassified;
        }
        field(20; "Truck No."; Code[20])
        {
            Caption = 'Truck No.';
            DataClassification = ToBeClassified;
        }
        field(21; "Tranporter/Driver Name"; Text[40])
        {
            Caption = 'Tranporter/Driver Name';
            DataClassification = ToBeClassified;
        }
        field(31; "Driver ID"; Text[20])
        {
            Caption = 'Driver ID';
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(32; "Unit Of Measure"; Code[20])
        {
            Caption = 'Unit Of measure';
            TableRelation = "Unit of Measure";
            DataClassification = ToBeClassified;
        }
        field(33; "Weight/CBM"; Decimal)
        {
            Caption = 'Weight/CBM';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Imssetup: Record "IMS Setup";
                CalculatedCBMweight: Decimal;

            begin
                GetHeader();
                Imssetup.Get();
                // if Imssetup."20FT" <> 0 then
                //     Rec.Validate(TEUs, Round(("Weight/CBM" / Imssetup."20FT"), 1, '>'));
                if GateInHead."Location Type" = GateInHead."Location Type"::"Bonded Warehouse" then
                    rec."Chargable CBM/Weight" := ROUND("Weight/CBM" / Imssetup."20FT", 1, '>') * Imssetup."20FT";
                if GateInHead."Location Type" = GateInHead."Location Type"::"Free Warehouse" then
                    rec."Chargable CBM/Weight" := "Weight/CBM";


                // if Imssetup."40FT CBM" <> 0 then
                //     Rec.Validate(TEUs, Round(("Weight/CBM" / Imssetup."40FT CBM"), 1, '>'));
                //Message('TUS %1', TEUs);


            end;
        }
        field(34; TEUs; Integer)
        {
            Caption = 'TEUs';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(35; "Chargable CBM/Weight"; Decimal)
        {
            Caption = 'Chargable CBM/Weight';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; "Container Size"; Enum "Container Size")
        {
            Caption = 'Container Size';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Imssetup: Record "IMS Setup";
            begin
                Imssetup.Get();
                GetHeader();
                Rec.Validate(CBM, 0);
                if "Container Size" = "Container Size"::" " then
                    Rec.TEUs := 0;
                if "Container Size" = "Container Size"::"20FT" then
                    Rec.TEUs := 1;
                if "Container Size" = "Container Size"::"40FT" then
                    Rec.TEUs := 2;
                if GateInHead."Location Type" = GateInHead."Location Type"::"Bonded Warehouse" then
                    rec."Chargable CBM/Weight" := ROUND("Weight/CBM" / Imssetup."20FT", 1, '>') * Imssetup."20FT";
                if GateInHead."Location Type" = GateInHead."Location Type"::"Free Warehouse" then
                    rec."Chargable CBM/Weight" := "Weight/CBM";
            end;
        }
        field(37; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            trigger onvalidate()
            var
                myInt: Integer;
            begin
                // rec.ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(38; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            trigger OnValidate()
            var
                Imssetup: Record "IMS Setup";
            begin
                Imssetup.Get();
                GetHeader();
                Rec.Validate(CBM, 0);
                if "Shortcut Dimension 5 Code" = '20FT' then
                    Rec.TEUs := 1
                else
                    if "Shortcut Dimension 5 Code" = '40FT' then
                        Rec.TEUs := 2
                    else
                        Rec.TEUs := 0;

                if GateInHead."Location Type" = GateInHead."Location Type"::"Bonded Warehouse" then
                    rec."Chargable CBM/Weight" := ROUND("Weight/CBM" / Imssetup."20FT", 1, '>') * Imssetup."20FT";
                if GateInHead."Location Type" = GateInHead."Location Type"::"Free Warehouse" then
                    rec."Chargable CBM/Weight" := "Weight/CBM";
            end;
        }
    }

    keys
    {
        key(PK; "Gate In No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        IMSSetup: Record "IMS Setup";
        GateInHead: Record "WH Gate In Header";
    begin
        IMSSetup.Get();
        "Item No." := IMSSetup."Default Item No. WH";
        if GateInHead.Get(Rec."Gate In No.") then begin
            Rec."Activity Date" := GateInHead."Activity Date";
            Rec."Activity Time" := GateInHead."Activity Time";
        end else begin
            Rec."Activity Date" := 0D;
            Rec."Activity Time" := 0T;
        end;
    end;

    local procedure GetHeader()
    begin
        GateInHead.Get(Rec."Gate In No.");
    end;

    var
        GateInHead: Record "WH Gate In Header";
}
