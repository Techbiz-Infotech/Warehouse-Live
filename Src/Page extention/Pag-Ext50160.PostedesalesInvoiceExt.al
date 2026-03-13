pageextension 50160 "Postede sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("BL No.")
        {
            field("Location Type"; Rec."Location Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies Location Type Field';
            }
            field("Gate In No."; Rec."Gate In No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies Gate In No. Field';
            }
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies Invoice Type Field';
            }
            field("Customs Entry No."; Rec."Customs Entry No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Customs Entry No.';
            }
            field("Consignment Value"; Rec."Consignment Value")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the Consignment Value';
            }



        }
    }
    actions
    {



        addlast(Category_Category6)
        {
            actionref(Print_Promoted_1; "Wh Sales Invoice")
            {
            }

        }




        addafter(SendCustom)
        {
            action("Wh Sales Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Sales Invoice';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category5;
                ToolTip = 'View or print the Wh sales invoice.';

                trigger OnAction()
                var
                    salesInvHeader: Record "Sales Invoice Header";
                begin
                    //DocPrint.PrintProformaSalesInvoice(Rec);
                    salesInvHeader.Reset();
                    salesInvHeader.SetRange("No.", Rec."No.");
                    IF salesInvHeader.FindFirst() then begin
                        if not salesInvHeader.Warehouse = true then
                            Error('Please use Terminal Invoice')
                        else
                            report.RunModal(report::"Sales-Invoice-WH", true, true, salesInvHeader)

                    end;
                end;
            }


        }

    }
}
