page 50219 "Posted WH Gate Out Order"
{
    //ApplicationArea = All;
    Caption = 'Posted Warehouse Gate Out Order';
    PageType = Document;
    SourceTable = "WH Gate Out Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Gate Out No."; Rec."Gate Out No.")
                {
                    ToolTip = 'Specifies the value of the Gate Out No. field.';
                    ApplicationArea = All;
                }
                field("Activity Date"; Rec."Activity Date")
                {
                    ToolTip = 'Specifies the value of the Gate Out Date field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent"; Rec."Clearing Agent")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent  field.';
                    ApplicationArea = All;
                }
                field("Clearing Agent Name"; Rec."Clearing Agent Name")
                {
                    ToolTip = 'Specifies the value of the Clearing Agent Name field.';
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
                field("Consignment Value"; Rec."Consignment Value to Release")
                {
                    ToolTip = 'Specifies the value of the Consignment Value field.';
                    ApplicationArea = All;
                }
                // field("Customs No."; Rec."Customs No.")
                // {
                //     ToolTip = 'Specifies the value of the Customs No. field.';
                //     ApplicationArea = All;
                // }

                field(Transporter; Rec.Transporter)
                {
                    ToolTip = 'Specifies the value of the Transporter field.';
                    ApplicationArea = All;
                }
            }
            part(PostedGateSubForm; "Posted Gate Out Order SubForm")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
            }
        }
    }
}
