pageextension 50155 "Posted sales Invoice List Ext" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Currency Code")
        {
            field(Warehouse; rec.Warehouse)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Location Type"; Rec."Location Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies Location Type Field';
            }
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies Invoice Type Field';
            }
            field("Gate In No."; Rec."Gate In No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies Gate In No. Field';
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

        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
    }
    actions
    {
        // modify(Print)
        // {
        //     Visible = false;
        // }

        addlast(Category_Category7)
        {
            actionref(Print_Promoted_1; "Wh Sales Invoice")
            {
            }
            // actionref(Print_Promoted_2; "Terminal Sales Invoice")
            // {
            // }

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
                    salesInvHeader.Reset();
                    salesInvHeader.SetRange("No.", Rec."No.");
                    IF salesInvHeader.FindFirst() then begin
                        if not salesInvHeader.Warehouse then
                            Error('This is not a Warehouse Invoice. Please use Terminal Sales Invoice action.')
                        else
                            report.RunModal(report::"Sales-Invoice-WH", true, true, salesInvHeader);
                    end;
                end;
            }
            // action("Terminal Sales Invoice")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Terminal Sales Invoice';
            //     Ellipsis = true;
            //     Image = Print;
            //     ToolTip = 'View or print the pro forma sales invoice.';

            //     trigger OnAction()
            //     var
            //         salesInvHeader: Record "Sales Invoice Header";
            //     begin
            //         salesInvHeader.Reset();
            //         salesInvHeader.SetRange("No.", Rec."No.");
            //         IF salesInvHeader.FindFirst() then begin
            //             if salesInvHeader.Warehouse then
            //                 Error('This is not a Terminal Invoice. Please use Warehouse Sales Invoice action.')
            //             else
            //                 report.RunModal(report::"Sales Invoice - SICD", true, true, salesInvHeader);
            //         end;
            //     end;
            // }

        }
    }
}
