pageextension 50156 "Customer List Extn" extends "Customer List"
{
    layout
    {


        addafter("Payments (LCY)")
        {
            // field("Terminal ChargeID Assignments"; Rec."Terminal ChargeID Assignments")
            // {
            //     ApplicationArea = all;
            //     Visible = false;
            // }
            field("Warehouse ChargeID Assignments"; Rec."Warehouse ChargeID Assignments")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
    actions
    {
        addbefore(Dimensions)
        {
            action("WH Charge Id Assignment")
            {
                Caption = 'Ware House Charge ID Assignment';
                ApplicationArea = All;
                RunObject = page "Warehouse Charge ID Assignemnt";
                RunPageLink = "Customer No." = field("No.");
                trigger OnAction()
                begin

                end;
            }
        }
    }
    }
