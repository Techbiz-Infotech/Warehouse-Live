pageextension 50157 "Postede sales Cr.Memo Extn" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
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

        // modify(Print)
        // {
        //     Visible = false;
        // }
        addlast(Category_Category7)
        {
            actionref(Print_Promoted_1; "Wh Sales Cr Memo")
            {
            }
            // actionref(Print_Promoted_2; "Terminal Sales Cr.Memo")
            // {
            // }

        }

        addafter(SendCustom)
        {
            action("Wh Sales Cr Memo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Warehouse Sales Cr.Memo';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category5;
                ToolTip = 'View or print the Wh sales invoice.';

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    //DocPrint.PrintProformaSalesInvoice(Rec);
                    SalesCrMemoHeader.Reset();
                    SalesCrMemoHeader.SetRange("No.", Rec."No.");
                    IF SalesCrMemoHeader.FindFirst() then begin
                        if not SalesCrMemoHeader.Warehouse then
                            Error('Please use Terminal CreditMemo')
                        else
                            report.RunModal(report::SalesCrMemoWH, true, true, SalesCrMemoHeader)
                    end;
                end;
            }
            // action("Terminal Sales Cr.Memo")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Terminal Sales Cr.Memo';
            //     Ellipsis = true;
            //     Image = Print;
            //     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
            //     //PromotedCategory = Category5;
            //     ToolTip = 'View or print the Sales Cr.Memo';

            //     trigger OnAction()
            //     var
            //         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
            //     begin
            //         //DocPrint.PrintProformaSalesInvoice(Rec);
            //         SalesCrMemoHeader.Reset();
            //         SalesCrMemoHeader.SetRange("No.", Rec."No.");
            //         IF SalesCrMemoHeader.FindFirst() then begin
            //             if SalesCrMemoHeader.Warehouse = false then
            //                 report.RunModal(report::"Credit Memo Report", true, true, SalesCrMemoHeader)
            //             else
            //                 Error('Please use WarehouseHouse Credit Memo');

            //         end;
            //     end;
            // }
        }
    }
}
