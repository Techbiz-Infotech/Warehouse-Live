page 50204 WarehouseDetailsList
{
    ApplicationArea = All;
    Caption = 'WarehouseDetailsList';
    PageType = Card;
    SourceTable = Warehouseinvoicedetails;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
            }
        }
    }
    trigger OnOpenPage()
    var
        IMSSetup: Record "IMS Setup";
    begin
        IMSSetup.Get();
        if IMSSetup."Warehouse Activated" = false then
            Error('Warehouse functionality is not activated for %1', CompanyName);
    end;
}
