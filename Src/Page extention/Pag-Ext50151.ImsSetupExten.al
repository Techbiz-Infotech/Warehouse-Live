pageextension 50151 "Ims SetupExten" extends "IMS Setup"
{
    layout
    {

        addafter("Cancel Gatepass Nos")
        {
            field("Gate In No."; Rec."Gate In Nos.")
            {
                ToolTip = 'Specifies the value of the Gate In field.';
                ApplicationArea = All;
            }
            field("Gate Out No."; Rec."Gate Out Nos.")
            {
                ToolTip = 'Specifies the value of the Gate Out field.';
                ApplicationArea = All;
            }
        }
        addafter("IMS Defaults Values")
        {
            group("WareHouse Default Values")
            {
                field("Category for Warehouse Storage"; rec."Category for Warehouse Storage")
                {
                    ApplicationArea = all;

                }
                field("Category for Bond Cancelation"; rec."Category for Bond Cancellation")
                {
                    ApplicationArea = all;
                }

                field("Category for Bond Acceptance"; rec."Category for Bond Acceptance")
                {
                    ApplicationArea = All;
                }
                field("Category for Re-Warehouse"; rec."Category for Re-Warehouse")
                {
                    ApplicationArea = All;
                }
                field("Category for Customs Exam"; Rec."Category for Customs Exam")
                {
                    ApplicationArea = all;
                }
                field("Re WareHousing Days"; rec."Re WareHousing Days")
                {
                    ApplicationArea = All;
                }
                field("Rewarehouse Per Entry Charge"; Rec."Rewarehouse Per Entry Charge")
                {
                    ApplicationArea = All;
                    ToolTip = 'specifies the Rewarehouse Per Entry Charge field';
                }
field(BIF; Rec.BIF)
                {
                    ApplicationArea = All;
                    ToolTip = 'specifies the BIF field';

                }
                field("Default Item No. WH"; Rec."Default Item No. WH")
                {
                    ApplicationArea = all;
                }
                field("Warehouse Allowed Limit"; Rec."Warehouse Allowed Limit")
                {
                    ApplicationArea = all;
                }
                field("Warehouse Available Limit"; Rec."Warehouse Available Limit")
                {
                    ApplicationArea = all;
                    //Editable = false;
                }

                field("Warehouse Activated"; rec."Warehouse Activated")
                {
                    ApplicationArea = all;
                    ToolTip = 'specifies the Warehouse Activated field';
                }
                field("20FT"; rec."20FT")
                {
                    ApplicationArea = all;
                    ToolTip = 'specifies the Warehouse 20FT CBM field';
                }


            }
            // field("40FT"; rec."40FT CBM")
            //     {
            //         ApplicationArea = all;
            //         ToolTip = 'specifies the Warehouse 20FT CBM field';
            //     }
        }
    }
    trigger OnOpenPage()
    var
    begin
        rec.UpdateWHValues();
    end;
}

