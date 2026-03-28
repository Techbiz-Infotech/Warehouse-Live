page 50221 "Warehouse ledger entries List"
{
    ApplicationArea = All;
    Caption = 'Warehouse Ledger Entries';
    PageType = List;
    SourceTable = "Warehouse Item Ledger Entry";
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    Editable = false;
                }
                field("Warehouse Entry Type"; Rec."Warehouse Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Warehouse Entry Type field.', Comment = '%';
                    Editable = false;
                }
                field("Location Type"; Rec."Location Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Type field.';
                    Editable = false;
                }
                field("Consignee Name"; Rec."Consignee Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Consignee Name field.', Comment = '%';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Editable = false;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Line No. field.';
                    Editable = false;
                }
                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description Of The Goods field.', Comment = '%';
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Editable = false;
                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Container Size field.';
                    Editable = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Weight field.';
                    Editable = false;
                }
                field(CBM; Rec.CBM)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CBM field.';
                    Editable = false;
                }
                field("Weight/CBM"; rec."Weight/CBM")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Weight/CBM value';
                    Editable = false;
                }
                field(TEUs; rec.TEUs)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the TEUs value';
                    Editable = false;
                }
                field("Chargable CBM/Weight"; Rec."Chargable CBM/Weight")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CBM field.';
                    Editable = false;
                }
                field("Invoiced CBM/Weight"; Rec."Invoiced CBM/Weight")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoiced CBM/Weight field.';
                    Editable = false;
                }
                field("Consignment Value"; Rec."Consignment Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Consignment Value field.';
                    Editable = false;
                }
                field("Remaining Quantity"; rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the CBM field.';
                    Editable = false;
                }
                field("Remaining CBM/Weight"; Rec."Remaining CBM/Weight")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Weight field.';
                    Editable = false;
                }
                field("Stripped Qty"; Rec."Stripped Qty")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stripped Qty field.';
                    Editable = false;

                }
                field("Invoicing WH Stripped Qty"; Rec."Invoicing WH Stripped Qty")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Invoicing WH Stripped Qty field.';
                    Editable = false;

                }
                field("Remaining WH Stripped Qty"; Rec."Remaining WH Stripped Qty")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining WH Stripped Qty field.';
                    Editable = false;
                }

                field("Remaining Consignment Value"; rec."Remaining Consignment Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining Consignment Value field.';
                    Editable = false;
                }
                field("Applied Document No."; Rec."Applied Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applied Document No. field.', Comment = '%';
                    Editable = false;
                }
                field("Applied Document Line No."; Rec."Applied Document Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applied Document Line No. field.', Comment = '%';
                    Editable = false;
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Consignee No. field.', Comment = '%';
                    Editable = false;
                }
                field("Clearing Agent"; Rec."Clearing Agent")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Clearing Agent field.', Comment = '%';
                    Editable = false;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.', Comment = '%';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Code field.';
                    Editable = false;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shelf No. field.';
                    Editable = false;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customs No. field.';
                    Editable = false;
                }
                field(Open; Rec.Open)
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Open field.';
                    Editable = false;
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Positive field.', Comment = '%';
                    Visible = false;
                    Editable = false;
                }

                field("Age in No. of Days"; rec."Age in No. of Days")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Age in No. of Days field.', Comment = '%';
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Editable = false;
                }
                field("Remaining Bond value"; Rec."Remaining Bond value")
                {
                    ToolTip = 'Specifies the value of the Remaining Bond value field.';
                    Editable = false;
                    ApplicationArea = all;

                }
                field("Chargeable warehouse Periods"; Rec."Chargeable warehouse Periods")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Chargeable warehouse Periods field.';
                    Editable = false;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        IMSSetup: Record "IMS Setup";
    begin
        IMSSetup.Get();
        IMSSetup.UpdateWHValues();
        CurrPage.Update(false);
        if IMSSetup."Warehouse Activated" = false then
            Error('Warehouse functionality is not activated for %1', CompanyName);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        Usersetup: Record "User Setup";
    begin
        // Usersetup.Get(UserId);
        IF (UserId <> 'GROUP.AUDIT') and (UserId <> 'TECHBIZINFOTECH') then
            Error('you_are_not_authorized_to_delete_this_record');
    end;


    var
        IMSSetup: Record "IMS Setup";




}
