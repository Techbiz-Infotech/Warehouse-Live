page 50213 "Posted WH Gate In Order"
{
    //ApplicationArea = All;
    Caption = 'Posted Warehouse Gate In Order';
    PageType = Document;
    SourceTable = "WH Gate In Header";
    //Editable = false;
    //UsageCategory = History;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Gate In No."; Rec."Gate In No.")
                {
                    ToolTip = 'Specifies the value of the Gate In No. field.';
                    ApplicationArea = All;

                }
                field("Gate In Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Gate In Date field.';
                    ApplicationArea = All;
                }
                field("Location Type"; Rec."Location Type")
                {
                    ToolTip = 'Specifies the value of the Location Type field.';
                    ApplicationArea = All;
                }
                field("Consignee No."; Rec."Consignee No.")
                {
                    ToolTip = 'Specifies the value of the Consignee No. field.';
                    ApplicationArea = All;
                }
                field("Consignee Name "; Rec."Consignee Name")
                {
                    ToolTip = 'Specifies the value of the Consignee Name field.';
                    ApplicationArea = All;
                }
                field("Consignment Value"; Rec."Consignment Value")
                {
                    ToolTip = 'Specifies the value of the Consignment Value field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent "; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent  field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.';
                    ApplicationArea = All;
                }
                field("Customs No."; Rec."Customs No.")
                {
                    ToolTip = 'Specifies the value of the Customs No. field.';
                    ApplicationArea = All;
                }
                field("Truck No."; Rec."Truck No.")
                {
                    ToolTip = 'Specifies the value of the Transporter field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                    ApplicationArea = All;
                }

            }
            part(GateInLines; "Posted Gate In Order SubForm")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Gate In No." = field("Gate In No.");
                Editable = false;
            }
        }



    }
    actions
    {
        area(Navigation)
        {
            action("Additional Charges")
            {
                Caption = 'Additional Charges';
                ApplicationArea = All;
                RunObject = page "WareHouse Additional Charges";
                RunPageLink = "Gate In No." = field("Gate In No.");
            }
            action("Print GatePass")
            {
                Caption = 'Print Gate In Order';
                ApplicationArea = All;
                trigger OnAction()
                var
                    GatePass: Record "WH Gate In Header";
                    GatepassLine: Record "WH Gate In Line";
                    CustRec: Record customer;
                begin
                    GatePass.Reset();
                    GatePass.SetRange("Gate In No.", Rec."Gate In No.");
                    IF GatePass.FindFirst() then begin
                        report.RunModal(report::"Warehouse - GateIn", true, true, GatePass);
                    end;
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        Usersetup: Record "User Setup";
    begin
       // Usersetup.Get(UserId);
        IF (UserId <> 'GROUP.AUDIT') and (UserId <> 'TECHBIZINFOTECH') then
            Error('you_are_not_authorized_to_delete_this_record');

    end;
}