page 50228 InvoicingGateIns
{
    ApplicationArea = All;
    Caption = 'InvoicingGateIns';
    PageType = List;
    SourceTable = "Invoicing Gate Ins";
    UsageCategory = Lists;
    //Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Activity Date field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gate In No."; Rec."Gate In No.")
                {
                    ToolTip = 'Specifies the value of the Gate In No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gate In Line No."; Rec."Gate In Line No.")
                {
                    ToolTip = 'Specifies the value of the Gate In Line No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Description Of The Goods"; Rec."Description Of The Goods")
                {
                    ToolTip = 'Specifies the value of the Description Of The Goods field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Location Type"; rec."Location Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Type field.', Comment = '%';
                     
                }
                field("Container Size"; Rec."Container Size")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Container Size field.';
                     
                }
                field("Proforma Invoice No."; Rec."Proforma Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Posted Invoice No."; Rec."Posted Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Posted Invoice No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Consignment Value Released"; rec."Consignment Value Released")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Consignment Value to Release field.', Comment = '%';
                     
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the Consignee No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Consignee Name"; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the Consignee Name field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Invoicing Quantity"; Rec."Invoicing Quantity")
                {
                    ToolTip = 'Specifies the value of the Invoicing Quantity field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Invoicing CBM/Weight"; Rec."Invoicing CBM/Weight")
                {
                    ToolTip = 'Specifies the value of the Invoicing CBM/Weight field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Warehouse Entry No."; Rec."Warehouse Entry No.")
                {
                    ToolTip = 'Specifies the value of the Warehouse Entry No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Posted Credit Memo No."; Rec."Posted Credit Memo No.")
                {
                    ToolTip = 'Specifies the value of the Posted Credit Memo No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gated Out"; Rec."Gated Out")
                {
                    ToolTip = 'Specifies the value of the Gated Out field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gate Out No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gate Out Date"; Rec."Gate Out Date")
                {
                    ToolTip = 'Specifies the value of the Gate Out Date field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gate In Charges"; rec."Gate In Charges")
                {
                    ToolTip = 'Specifies the value of the Gate In Charges field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Gate Out Charges"; rec."Gate out Charges")
                {
                    ToolTip = 'Specifies the value of the Gate Out Charges field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Invoice Type"; rec."Invoice Type")
                {
                    ToolTip = 'Specifies the value of the Invoice Type field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                field("Chargeable warehouse Periods"; Rec."Chargeable warehouse Periods")
                {
                    ToolTip = 'Specifies the value of the Chargeable warehouse Periods field.', Comment = '%';
                    ApplicationArea = all;
                     

                }
                field("Customs Entry No."; Rec."Customs Entry No.")
                {
                    ToolTip = 'Specifies the value of the Customs Entry No. field.', Comment = '%';
                    ApplicationArea = all;
                     
                }
                
            }
        }
    }
    trigger OnOpenPage()
    var
        IMSSetup: Record "IMS Setup";
    begin
        IMSSetup.Get();
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
}
