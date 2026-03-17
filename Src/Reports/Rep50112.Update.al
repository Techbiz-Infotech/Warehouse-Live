report 50112 Update
{
    Caption = 'Update';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(WHGateInHeader; "WH Gate In Header")
        {
            trigger OnAfterGetRecord()
            begin
                if WHGateInHeader."Gate In No." = 'WHGI2600016' then
                    WHGateInHeader.Validate("Consignee No.", 'C00001');
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
