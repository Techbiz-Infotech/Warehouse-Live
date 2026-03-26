report 50112 Update
{
    Caption = 'Update';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    ApplicationArea = all;
    dataset
    {
        dataitem(WHGateInHeader; "WH Gate In Header")
        {
            trigger OnAfterGetRecord()
            begin
                if WHGateInHeader."Gate In No." = 'WHGI2600016' then begin
                    WHGateInHeader.Validate("Consignee No.", 'C00001');
                    WHGateInHeader.Modify();
                end;
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
