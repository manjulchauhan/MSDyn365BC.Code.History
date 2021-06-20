codeunit 104151 "ISO Code UPG.BE"
{
    Subtype = Upgrade;

    trigger OnRun()
    begin
    end;

    trigger OnUpgradePerCompany()
    begin
        MoveCurrencyISOCode;
        UpdateCountyName;
    end;

    local procedure MoveCurrencyISOCode()
    var
        Currency: Record "Currency";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefinitions: Codeunit "Upgrade Tag Definitions";
    begin
        IF UpgradeTag.HasUpgradeTag(UpgradeTagDefinitions.GetMoveCurrencyISOCodeTag) THEN
            EXIT;

        WITH Currency DO BEGIN
            SETFILTER("ISO Currency Code", '<>%1', '');
            IF FINDSET THEN
                REPEAT
                    "ISO Code" := "ISO Currency Code";
                    MODIFY;
                UNTIL NEXT = 0;
        END;

        UpgradeTag.SetUpgradeTag(UpgradeTagDefinitions.GetMoveCurrencyISOCodeTag);
    end;

    local procedure UpdateCountyName()
    var
        CountryRegion: Record "Country/Region";
        UpgradeTag: Codeunit "Upgrade Tag";
        UpgradeTagDefCountry: Codeunit "Upgrade Tag Def - Country";
    begin
        IF UpgradeTag.HasUpgradeTag(UpgradeTagDefCountry.GetUpdateCountyNameTag) THEN
            EXIT;

        WITH CountryRegion DO BEGIN
            SETFILTER("ISO Country/Region Code", '<>%1', '');
            IF FINDSET THEN
                REPEAT
                    "ISO Code" := "ISO Country/Region Code";
                    MODIFY;
                UNTIL NEXT = 0;
        END;

        UpgradeTag.SetUpgradeTag(UpgradeTagDefCountry.GetUpdateCountyNameTag);
    end;
}
