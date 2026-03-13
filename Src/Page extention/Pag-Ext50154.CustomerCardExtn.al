pageextension 50154 "Customer Card Extn" extends "Customer Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("Warehouse ChargeID Assignments"; Rec."Warehouse ChargeID Assignments")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        //addafter("Bank Accounts")
        addbefore(Dimensions)
        {

            action("WH Charge Id Assignment")
            {
                Caption = 'Warehouse Charge ID Assignment';
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
