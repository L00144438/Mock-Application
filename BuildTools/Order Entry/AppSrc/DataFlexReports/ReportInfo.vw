Use Windows.pkg
Use DFClient.pkg
Use File_dlg.pkg
Use Dftreevw.pkg
Use cDRReport.pkg

Deferred_View Activate_oReportInfoView for ;
Object oReportInfoView is a dbView
    Set Border_Style to Border_Thick
    Set Size to 200 350
    Set Location to 4 3
    Set Label to "Report Info"
    Set piMaxSize to 400 500
    Set piMinSize to 200 350

    Object oReportFileNameForm is a Form
        Set Size to 13 242
        Set Location to 5 50
        Set Prompt_Button_Mode to PB_PromptOn
        Set Label_Col_Offset to 2
        Set Label to "Filename:"
        Set Label_Justification_Mode to JMode_Right
        Set psToolTip to "Report File Name"
        Set peAnchors to anTopLeftRight

        Procedure Prompt
            Boolean bSelected
            String sFileName

            Get Show_Dialog of oReportSelectorDialog to bSelected
            If (bSelected) Begin
                Get File_Name of oReportSelectorDialog to sFileName
                Set Value to sFileName
            End
        End_Procedure
    End_Object

    Object oReportSelectorDialog is a OpenDialog
        Set Filter_String to "DataFlex Reports|*.dr|All Files|*.*"
        Set Dialog_Caption to "Select a DataFlex Reports Report"
    End_Object

    Object oResults is a TreeView
        Set Size to 174 334
        Set Location to 20 9
        Set peAnchors to anAll

        Procedure OnCreateTree
            Handle hVoid

            Get AddTreeItem 'Select a Report for Information' 0 0 0 0 to hVoid
        End_Procedure
    End_Object

    Object oReport is a cDRReport
        Procedure ShowInfo
            String sFileName sReportId
            Handle hReportItem

            Get Value of oReportFileNameForm to sFileName
            If (sFileName <> "") Begin
                Set psReportName to sFileName
                Get OpenReport to sReportId
                If (sReportId <> "") Begin
                    Send ClearAll of oResults
                    Get AddTreeItem of oResults sFileName 0 0 0 0 to hReportItem
                    Send ShowReportInfo sReportId hReportItem
                    Send DoExpandItem of oResults hReportItem
                    Send CloseReport sReportId
                End
            End
        End_Procedure

        Procedure ShowReportInfo String sReportId Handle hReportItem
            Handle hVoid

            Get AddTreeItem of oResults ('Report ID:' * sReportId) hReportItem 0 0 0 to hVoid

            Send ShowDatabases sReportId hReportItem
            Send ShowFunctions sReportId hReportItem
            Send ShowParameters sReportId hReportItem
            Send ShowSelections sReportId hReportItem
            Send ShowRecordSorts sReportId hReportItem
            Send ShowSubReports sReportId hReportItem
            Send ShowPaperInfo sReportId hReportItem
        End_Procedure

        Procedure ShowPaperInfo String sReportId Handle hReportItem
            Integer ePaperOrientation ePaperSize iMargin
            Handle hPaperItem hVoid
            String sValue
            
            Get AddTreeItem of oResults 'Paper' hReportItem 0 0 0 to hPaperItem

            Get PaperOrientation sReportId to ePaperOrientation
            Case Begin
                Case (ePaperOrientation = DMORIENT_PORTRAIT)
                    Get AddTreeItem of oResults 'Paper Orientation: Portrait' hPaperItem ePaperOrientation 0 0 to hVoid
                    Case Break
                Case (ePaperOrientation = DMORIENT_LANDSCAPE)
                    Get AddTreeItem of oResults 'Paper Orientation: Landscape' hPaperItem ePaperOrientation 0 0 to hVoid
                    Case Break
            Case End

            Get piPaperMarginTop sReportId to iMargin
            Get AddTreeItem of oResults ('Top Margin:' * String (iMargin)) hPaperItem iMargin 0 0 to hVoid
            Get piPaperMarginBottom sReportId to iMargin
            Get AddTreeItem of oResults ('Bottom Margin:' * String (iMargin)) hPaperItem iMargin 0 0 to hVoid
            Get piPaperMarginLeft sReportId to iMargin
            Get AddTreeItem of oResults ('Left Margin:' * String (iMargin)) hPaperItem iMargin 0 0 to hVoid
            Get piPaperMarginRight sReportId to iMargin
            Get AddTreeItem of oResults ('Right Margin:' * String (iMargin)) hPaperItem iMargin 0 0 to hVoid

            Get PaperSize sReportId to ePaperSize
            Case Begin
                Case (ePaperSize = DMPAPER_LETTER)
                    Move 'Letter 8 1/2 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LETTERSMALL)
                    Move 'Letter Small 8 1/2 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_TABLOID)
                    Move 'Tabloid 11 x 17 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LEDGER)
                    Move 'Ledger 17 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LEGAL)
                    Move 'Legal 8 1/2 x 14 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_STATEMENT)
                    Move 'Statement 5 1/2 x 8 1/2 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_EXECUTIVE)
                    Move 'Executive 7 1/4 x 10 1/2 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A3)
                    Move 'A3 297 x 420 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A4)
                    Move 'A4 210 x 297 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A4SMALL)
                    Move 'A4 Small 210 x 297 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A5)
                    Move 'A5 148 x 210 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B4)
                    Move 'B4 (JIS) 250 x 354' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B5)
                    Move 'B5 (JIS) 182 x 257 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_FOLIO)
                    Move 'Folio 8 1/2 x 13 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_QUARTO)
                    Move 'Quarto 215 x 275 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_10X14)
                    Move '10x14 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_11X17)
                    Move '11x17 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_NOTE)
                    Move 'Note 8 1/2 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_9)
                    Move 'Envelope #9 3 7/8 x 8 7/8' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_10)
                    Move 'Envelope #10 4 1/8 x 9 1/2' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_11)
                    Move 'Envelope #11 4 1/2 x 10 3/8' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_12)
                    Move 'Envelope #12 4 \276 x 11' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_14)
                    Move 'Envelope #14 5 x 11 1/2' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_CSHEET)
                    Move 'C size sheet' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_DSHEET)
                    Move 'D size sheet' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ESHEET)
                    Move 'E size sheet' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_DL)
                    Move 'Envelope DL 110 x 220mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_C5)
                    Move 'Envelope C5 162 x 229 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_C3)
                    Move 'Envelope C3  324 x 458 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_C4)
                    Move 'Envelope C4  229 x 324 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_C6)
                    Move 'Envelope C6  114 x 162 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_C65)
                    Move 'Envelope C65 114 x 229 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_B4)
                    Move 'Envelope B4  250 x 353 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_B5)
                    Move 'Envelope B5  176 x 250 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_B6)
                    Move 'Envelope B6  176 x 125 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_ITALY)
                    Move 'Envelope 110 x 230 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_MONARCH)
                    Move 'Envelope Monarch 3.875 x 7.5 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_PERSONAL)
                    Move '6 3/4 Envelope 3 5/8 x 6 1/2 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_FANFOLD_US)
                    Move 'US Std Fanfold 14 7/8 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_FANFOLD_STD_GERMAN)
                    Move 'German Std Fanfold 8 1/2 x 12 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_FANFOLD_LGL_GERMAN)
                    Move 'German Legal Fanfold 8 1/2 x 13 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ISO_B4)
                    Move 'B4 (ISO) 250 x 353 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JAPANESE_POSTCARD)
                    Move 'Japanese Postcard 100 x 148 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_9X11)
                    Move '9 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_10X11)
                    Move '10 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_15X11)
                    Move '15 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_ENV_INVITE)
                    Move 'Envelope Invite 220 x 220 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_RESERVED_48)
                Case (ePaperSize = DMPAPER_RESERVED_49)
                    Move 'RESERVED--DO not Use' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LETTER_EXTRA)
                    Move 'Letter Extra 9 \275 x 12 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LEGAL_EXTRA)
                    Move 'Legal Extra 9 \275 x 15 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_TABLOID_EXTRA)
                    Move 'Tabloid Extra 11.69 x 18 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A4_EXTRA)
                    Move 'A4 Extra 9.27 x 12.69 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LETTER_TRANSVERSE)
                    Move 'Letter Transverse 8 \275 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A4_TRANSVERSE)
                    Move 'A4 Transverse 210 x 297 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LETTER_EXTRA_TRANSVERSE)
                    Move 'Letter Extra Transverse 9\275 x 12 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A_PLUS)
                    Move 'SuperA/SuperA/A4 227 x 356 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B_PLUS)
                    Move 'SuperB/SuperB/A3 305 x 487 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LETTER_PLUS)
                    Move 'Letter Plus 8.5 x 12.69 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A4_PLUS)
                    Move 'A4 Plus 210 x 330 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A5_TRANSVERSE)
                    Move 'A5 Transverse 148 x 210 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B5_TRANSVERSE)
                    Move 'B5 (JIS) Transverse 182 x 257 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A3_EXTRA)
                    Move 'A3 Extra 322 x 445 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A5_EXTRA)
                    Move 'A5 Extra 174 x 235 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B5_EXTRA)
                    Move 'B5 (ISO) Extra 201 x 276 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A2)
                    Move 'A2 420 x 594 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A3_TRANSVERSE)
                    Move 'A3 Transverse 297 x 420 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A3_EXTRA_TRANSVERSE)
                    Move 'A3 Extra Transverse 322 x 445 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_DBL_JAPANESE_POSTCARD)
                    Move 'Japanese Double Postcard 200 x 148 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A6)
                    Move 'A6 105 x 148 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_KAKU2)
                    Move 'Japanese Envelope Kaku #2' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_KAKU3)
                    Move 'Japanese Envelope Kaku #3' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_CHOU3)
                    Move 'Japanese Envelope Chou #3' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_CHOU4)
                    Move 'Japanese Envelope Chou #4' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_LETTER_ROTATED)
                    Move 'Letter Rotated 11 x 8 1/2 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A3_ROTATED)
                    Move 'A3 Rotated 420 x 297 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A4_ROTATED)
                    Move 'A4 Rotated 297 x 210 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A5_ROTATED)
                    Move 'A5 Rotated 210 x 148 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B4_JIS_ROTATED)
                    Move 'B4 (JIS) Rotated 364 x 257 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B5_JIS_ROTATED)
                    Move 'B5 (JIS) Rotated 257 x 182 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JAPANESE_POSTCARD_ROTATED)
                    Move 'Japanese Postcard Rotated 148 x 100 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED)
                    Move 'Double Japanese Postcard Rotated 148 x 200 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_A6_ROTATED)
                    Move 'A6 Rotated 148 x 105 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_KAKU2_ROTATED)
                    Move 'Japanese Envelope Kaku #2 Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_KAKU3_ROTATED)
                    Move 'Japanese Envelope Kaku #3 Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_CHOU3_ROTATED)
                    Move 'Japanese Envelope Chou #3 Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_CHOU4_ROTATED)
                    Move 'Japanese Envelope Chou #4 Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B6_JIS)
                    Move 'B6 (JIS) 128 x 182 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_B6_JIS_ROTATED)
                    Move 'B6 (JIS) Rotated 182 x 128 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_12X11)
                    Move '12 x 11 in' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_YOU4)
                    Move 'Japanese Envelope You #4' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_JENV_YOU4_ROTATED)
                    Move 'Japanese Envelope You #4 Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_P16K)
                    Move 'PRC 16K 146 x 215 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_P32K)
                    Move 'PRC 32K 97 x 151 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_P32KBIG)
                    Move 'PRC 32K(Big) 97 x 151 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_1)
                    Move 'PRC Envelope #1 102 x 165 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_2)
                    Move 'PRC Envelope #2 102 x 176 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_3)
                    Move 'PRC Envelope #3 125 x 176 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_4)
                    Move 'PRC Envelope #4 110 x 208 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_5)
                    Move 'PRC Envelope #5 110 x 220 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_6)
                    Move 'PRC Envelope #6 120 x 230 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_7)
                    Move 'PRC Envelope #7 160 x 230 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_8)
                    Move 'PRC Envelope #8 120 x 309 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_9)
                    Move 'PRC Envelope #9 229 x 324 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_10)
                    Move 'PRC Envelope #10 324 x 458 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_P16K_ROTATED)
                    Move 'PRC 16K Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_P32K_ROTATED)
                    Move 'PRC 32K Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_P32KBIG_ROTATED)
                    Move 'PRC 32K(Big) Rotated' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_1_ROTATED)
                    Move 'PRC Envelope #1 Rotated 165 x 102 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_2_ROTATED)
                    Move 'PRC Envelope #2 Rotated 176 x 102 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_3_ROTATED)
                    Move 'PRC Envelope #3 Rotated 176 x 125 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_4_ROTATED)
                    Move 'PRC Envelope #4 Rotated 208 x 110 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_5_ROTATED)
                    Move 'PRC Envelope #5 Rotated 220 x 110 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_6_ROTATED)
                    Move 'PRC Envelope #6 Rotated 230 x 120 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_7_ROTATED)
                    Move 'PRC Envelope #7 Rotated 230 x 160 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_8_ROTATED)
                    Move 'PRC Envelope #8 Rotated 309 x 120 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_9_ROTATED)
                    Move 'PRC Envelope #9 Rotated 324 x 229 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_PENV_10_ROTATED)
                    Move 'PRC Envelope #10 Rotated 458 x 324 mm' to sValue
                    Case Break
                Case (ePaperSize = DMPAPER_USER)
                    Move 'User Defined' to sValue
                    Case Break
            Case End

            Get AddTreeItem of oResults ('Paper Size:' * sValue * '(' - String (ePaperSize) - ')') hPaperItem ePaperSize 0 0 to hVoid
        End_Procedure

        Procedure ShowRecordSorts String sReportId Handle hReportItem
            Integer iSortFields iSortField eSortOrder
            Handle hRecordSortsItem hVoid
            String sValue

            Get RecordSortCount sReportId to iSortFields
            If (iSortFields > 0) Begin
                Get AddTreeItem of oResults ('Record Sorts (' - String (iSortFields) - ')') hReportItem 0 0 0 to hRecordSortsItem
                Decrement iSortFields
                For iSortField from 0 to iSortFields
                    Get psRecordSortField sReportId iSortField to sValue
                    Get peRecordSortOrder sReportId iSortField to eSortOrder
                    If (eSortOrder = C_drAscending) Begin
                        Get AddTreeItem of oResults ('Field:' * sValue * '(Ascending)') hRecordSortsItem iSortField 0 0 to hVoid
                    End
                    Else Begin
                        Get AddTreeItem of oResults ('Field:' * sValue * '(Descending)') hRecordSortsItem iSortField 0 0 to hVoid
                    End
                Loop
            End
        End_Procedure

        Function DatabaseTypeString Integer eDatabaseType Returns String
            String sTypeName

            Case Begin
                Case (Low (eDatabaseType) = C_drDF)
                    Move "DataFlex" to sTypeName
                    Case Break
                Case (Low (eDatabaseType) = C_drODBC)
                    Case Begin
                        Case (Hi (eDatabaseType) = C_drStandard)
                            Move "ODBC" to sTypeName
                            Case Break
                        Case (Hi (eDatabaseType) = C_drSP)
                            Move "ODBC - Stored Procedure" to sTypeName
                            Case Break
                        Case (Hi (eDatabaseType) = C_drSQL)
                            Move "ODBC - SQL Statement" to sTypeName
                            Case Break
                    Case End
                    Case Break
                Case (Low (eDatabaseType) = C_drRDS)
                    Move "Runtime Data Source" to sTypeName
                    Case Break
                Case (Low (eDatabaseType) = C_drSQLite)
                    Case Begin
                        Case (Hi (eDatabaseType) = C_drStandard)
                            Move "SQLite" to sTypeName
                            Case Break
                        Case (Hi (eDatabaseType) = C_drSQL)
                            Move "SQLite - SQL Statement" to sTypeName
                            Case Break
                    Case End
                    Case Break
            Case End

            Function_Return sTypeName
        End_Function

        Procedure ShowDatabases String sReportId Handle hReportItem
            String sValue
            Handle hDatabaseItem hVoid
            Integer eDatabaseType

            // There is only one database per report
            Get psDatabaseName sReportId to sValue
            If (sValue <> '') Begin
                Get AddTreeItem of oResults 'Databases (1)' hReportItem 0 0 0 to hDatabaseItem
                Get AddTreeItem of oResults ('Name:' * sValue) hDatabaseItem 0 0 0 to hVoid
                Get psDatabaseConnection sReportId to sValue
                If (sValue <> '') Begin
                    Get AddTreeItem of oResults ('Connection:' * sValue) hDatabaseItem 0 0 0 to hVoid
                End
                Get DatabaseType sReportId to eDatabaseType
                Get DatabaseTypeString eDatabaseType to sValue
                Get AddTreeItem of oResults ('Type:' * sValue) hDatabaseItem 0 0 0 to hVoid

                Send ShowTables sReportId hDatabaseItem
            End
        End_Procedure

        Function FilterOperatorString Integer eFilterOperator Returns String
            String sResult

            Case Begin
                Case (eFilterOperator = C_drNone)
                    Move "None" to sResult
                    Case Break
                Case (eFilterOperator = C_drEqual)
                    Move "Equal" to sResult
                    Case Break
                Case (eFilterOperator = C_drNotEqual)
                    Move "Not Equal" to sResult
                    Case Break
                Case (eFilterOperator = C_drGreaterThan)
                    Move "Greater Than" to sResult
                    Case Break
                Case (eFilterOperator = C_drGreaterThanOrEqual)
                    Move "Greater Than or Equal" to sResult
                    Case Break
                Case (eFilterOperator = C_drLessThan)
                    Move "Less Than" to sResult
                    Case Break
                Case (eFilterOperator = C_drLessThanOrEqual)
                    Move "Less Than or Equal" to sResult
                    Case Break
            Case End

            Function_Return sResult
        End_Function

        Procedure ShowSelections String sReportId Handle hReportItem
            String sValue
            Handle hVoid hFiltersItem
            Integer iFilters iFilter eFilterOperator

            Get psFilterFunction sReportId to sValue
            If (sValue <> '') Begin
                Get AddTreeItem of oResults ('Filter Function:' * sValue) hReportItem 0 0 0 to hVoid
            End

            Get FilterCount sReportId to iFilters
            If (iFilters > 0) Begin
                Get AddTreeItem of oResults ('Filters (' - String (iFilters) - ')') hReportItem 0 0 0 to hFiltersItem
                Decrement iFilters
                For iFilter from 0 to iFilters
                    Get psFilterField sReportId iFilter to sValue
                    Get AddTreeItem of oResults ('Field:' - sValue) hFiltersItem 0 0 0 to hVoid
                    Get peFilterOperator sReportId iFilter to eFilterOperator
                    Get FilterOperatorString eFilterOperator to sValue
                    Get AddTreeItem of oResults ('Operator:' - sValue * '(' - String (eFilterOperator) - ')') hFiltersItem 0 0 0 to hVoid
                    Get psFilterValue sReportId iFilter to sValue
                    Get AddTreeItem of oResults ('Value:' - sValue) hFiltersItem 0 0 0 to hVoid
                Loop
            End
        End_Procedure

        Procedure ShowSubReports String sReportId Handle hReportItem
            Integer iSubReports
            Handle hSubReportsItem

            Get SubReportCount sReportId to iSubReports
            If (iSubReports > 0) Begin
                Get AddTreeItem of oResults ('SubReports (' - String (iSubReports) - ')') hReportItem iSubReports 0 0 to hSubReportsItem
                Send ShowSubReportInfo sReportId iSubReports hSubReportsItem
            End
        End_Procedure

        Procedure ShowSubReportInfo String sReportId Integer iSubReports Handle hSubReportsItem
            Integer iSubReport
            String sSubReportId sReportName
            Handle hSubReportItem hVoid

            Decrement iSubReports
            For iSubReport from 0 to iSubReports
                Get SubReportId sReportId iSubReport to sSubReportId
                Get ComReportName sSubReportId to sReportName
                Get AddTreeItem of oResults sReportName hSubReportsItem iSubReport 0 0 to hSubReportItem
                Send ShowReportInfo sSubReportId hSubReportItem
            Loop
        End_Procedure

        Procedure ShowParameters String sReportId Handle hReportItem
            Integer iParameters
            Handle hParametersItem

            Get ParameterCount sReportId to iParameters
            If (iParameters > 0) Begin
                Get AddTreeItem of oResults ('Parameters (' - String (iParameters) - ')') hReportItem iParameters 0 0 to hParametersItem
                Send ShowParametersInfo sReportId iParameters hParametersItem
            End
        End_Procedure

        Procedure ShowParametersInfo String sReportId Integer iParameters Handle hParametersItem
            Integer iParameter
            String sParameterValue sType
            Handle hParameterItem hVoid
            tDRParameter ParameterDetails

            Decrement iParameters
            For iParameter from 0 to iParameters
                Get ParameterInfo sReportId iParameter to ParameterDetails
                Get AddTreeItem of oResults (String (iParameter) - ':' * ParameterDetails.sName) hParametersItem iParameter 0 0 to hParameterItem
                Get psParameterValue sReportId iParameter to sParameterValue
                Get AddTreeItem of oResults ('Value:' * sParameterValue) hParameterItem iParameter 0 0 to hVoid
                Get BuildReturnTypeString ParameterDetails.iType to sType
                Get AddTreeItem of oResults ('Type:' * sType * '(' - String (ParameterDetails.iType) - ')') hParameterItem iParameter 0 0 to hVoid
                Get AddTreeItem of oResults ('Length:' * String (ParameterDetails.iLength)) hParameterItem iParameter 0 0 to hVoid
                Get AddTreeItem of oResults ('Precision:' * String (ParameterDetails.iPrecision)) hParameterItem iParameter 0 0 to hVoid
            Loop
        End_Procedure

        Procedure ShowFunctions String sReportId Handle hReportItem
            Integer iFunctions
            Handle hFunctionsItem

            Get FunctionCount sReportId to iFunctions
            If (iFunctions > 0) Begin
                Get AddTreeItem of oResults ('Functions (' - String (iFunctions) - ')') hReportItem iFunctions 0 0 to hFunctionsItem
                Send ShowFunctionsInfo sReportId iFunctions hFunctionsItem
            End
        End_Procedure

        Function BuildReturnTypeString Integer eType Returns String
            String sResult

            Case Begin
                Case (eType = SQL_CHAR)
                    Move 'char' to sResult
                    Case Break
                Case (eType = SQL_NUMERIC)
                    Move 'number' to sResult
                    Case Break
                Case (eType = SQL_INTEGER)
                    Move 'integer' to sResult
                    Case Break
                Case (eType = SQL_DOUBLE)
                    Move 'double' to sResult
                    Case Break
                Case (eType = SQL_DATETIME)
                    Move 'datetime' to sResult
                    Case Break
                Case Else
                    Move 'unknown' to sResult
                    Case Break
            Case End

            Function_Return sResult
        End_Function

        Procedure ShowFunctionsInfo String sReportId Integer iFunctions Handle hFunctionsItem
            Integer iFunction iLength eType
            String sFunctionName sType sFunctionBody
            Handle hFunctionItem hVoid

            Decrement iFunctions
            For iFunction from 0 to iFunctions
                Get psFunctionName sReportId iFunction to sFunctionName
                If (sFunctionName = '') Begin
                    Move 'Built-in Function' to sFunctionName
                End
                Get AddTreeItem of oResults (String (iFunction) - ':' * sFunctionName) hFunctionsItem iFunction 0 0 to hFunctionItem
                Get FunctionLength sFunctionName iFunction to iLength
                Get AddTreeItem of oResults ('Length:' * String (iLength)) hFunctionItem iLength 0 0 to hVoid
                Get FunctionType sFunctionName iFunction to eType
                Get BuildReturnTypeString eType to sType
                Get AddTreeItem of oResults ('Type:' * sType * '(' - String (eType) - ')') hFunctionItem eType 0 0 to hVoid
                Get ComFunction sReportId iFunction to sFunctionBody
                Get AddTreeItem of oResults ('Value:' * sFunctionBody) hFunctionItem eType 0 0 to hVoid
            Loop
        End_Procedure

        Procedure ShowTables String sReportId Handle hReportItem
            Integer iTables
            Handle hTablesItem

            Get TableCount sReportId to iTables
            If (iTables > 0) Begin
                Get AddTreeItem of oResults ('Tables (' - String (iTables) - ')') hReportItem iTables 0 0 to hTablesItem
                Send ShowTablesInfo sReportId iTables hTablesItem
            End
        End_Procedure

        Procedure ShowTablesInfo String sReportId Integer iTables Handle hTablesItem
            Integer iTable
            String sTableName
            Handle hTableItem

            Decrement iTables
            For iTable from 0 to iTables
                Get psTableName of oReport sReportId iTable to sTableName
                Get AddTreeItem of oResults sTableName hTablesItem iTable 0 0 to hTableItem
                Send ShowColumns sReportId iTable hTableItem
            Loop
        End_Procedure

        Procedure ShowColumns String sReportId Integer iTable Handle hTableItem
            Integer iColumns
            Handle hColumnsItem

            Get TableColumnCount sReportId iTable to iColumns
            Get AddTreeItem of oResults ('Columns (' - String (iColumns) - ')') hTableItem iTable 0 0 to hColumnsItem
            Send ShowColumnsInfo sReportId iTable iColumns hColumnsItem
        End_Procedure

        Procedure ShowColumnsInfo String sReportId Integer iTable Integer iColumns Handle hColumnsItem
            Integer iColumn
            Handle hColumnItem

            Decrement iColumns
            For iColumn from 0 to iColumns
                Get AddTreeItem of oResults ('Column (' - String (iColumn) - ')') hColumnsItem iColumn 0 0 to hColumnItem
                Send ShowColumnName sReportId iTable iColumn hColumnItem
                Send ShowColumnType sReportId iTable iColumn hColumnItem
                Send ShowColumnLength sReportId iTable iColumn hColumnItem
                Send ShowColumnPrecision sReportId iTable iColumn hColumnItem
                Send ShowColumnIndex sReportId iTable iColumn hColumnItem
            Loop
        End_Procedure

        Procedure ShowColumnName String sReportId Integer iTable Integer iColumn Handle hColumnItem
            String sColumnName
            Handle hVoid

            Get TableColumnName sReportId iTable iColumn to sColumnName
            Get AddTreeItem of oResults ("Name:" * sColumnName) hColumnItem iColumn 0 0 to hVoid
        End_Procedure

        Procedure ShowColumnType String sReportId Integer iTable Integer iColumn Handle hColumnItem
            Integer eType
            String sLabel
            Handle hVoid

            Get TableColumnType sReportId iTable iColumn to eType
            Move 'Type:' to sLabel
            Case Begin
                Case (eType = SQL_INTEGER)
                    Move (sLabel * "(Integer)") to sLabel
                    Case Break
                Case (eType = SQL_BIGINT)
                    Move (sLabel * "(BIG Integer)") to sLabel
                    Case Break
                Case (eType = SQL_TINYINT)
                    Move (sLabel * "(Tiny Integer)") to sLabel
                    Case Break
                Case (eType = SQL_SMALLINT)
                    Move (sLabel * "(Small Integer)") to sLabel
                    Case Break
                Case (eType = SQL_DATETIME)
                    Move (sLabel * "(DateTime)") to sLabel
                    Case Break
                Case (eType = SQL_TIME)
                Case (eType = SQL_TYPE_TIME)
                    Move (sLabel * "(Time)") to sLabel
                    Break
                Case (eType = SQL_TYPE_TIMESTAMP)
                    Move (sLabel * "(TimeStamp)") to sLabel
                    Case Break
                Case (eType = SQL_TYPE_DATE)
                    Move (sLabel * "(Date)") to sLabel
                    Case Break
                Case (eType = SQL_NUMERIC)
                    Move (sLabel * "(Numeric)") to sLabel
                    Case Break
                Case (eType = SQL_DECIMAL)
                    Move (sLabel * "(Decimal)") to sLabel
                    Case Break
                Case (eType = SQL_DOUBLE)
                    Move (sLabel * "(Double)") to sLabel
                    Case Break
                Case (eType = SQL_FLOAT)
                    Move (sLabel * "(Float)") to sLabel
                    Case Break
                Case (eType = SQL_REAL)
                    Move (sLabel * "(Real)") to sLabel
                    Case Break
                Case (eType = SQL_CHAR)
                    Move (sLabel * "(String)") to sLabel
                    Case Break
                Case (eType = SQL_VARCHAR)
                    Move (sLabel * "(Variable Length String)") to sLabel
                    Case Break
                Case (eType = SQL_LONGVARCHAR)
                    Move (sLabel * "(Long Variable Length String)") to sLabel
                    Case Break
                Case (eType = SQL_BINARY)
                    Move (sLabel * "(Binary)") to sLabel
                    Case Break
                Case (eType = SQL_VARBINARY)
                    Move (sLabel * "(Variable Length Binary)") to sLabel
                    Case Break
                Case (eType = SQL_LONGVARBINARY)
                    Move (sLabel * "(Long Variable Length Binary)") to sLabel
                    Case Break
                Case (eType = SQL_BIT)
                    Move (sLabel * "(Bit)") to sLabel
                    Case Break
                Case (eType = SQL_GUID)
                    Move (sLabel * "(GUID)") to sLabel
                    Case Break
                Case (eType = SQL_UNKNOWN_TYPE)
                    Move (sLabel * "(Unknown)") to sLabel
                    Case Break
            Case End

            Get AddTreeItem of oResults sLabel hColumnItem iColumn 0 0 to hVoid
        End_Procedure

        Procedure ShowColumnLength String sReportId Integer iTable Integer iColumn Handle hColumnItem
            Integer iLength
            Handle hVoid

            Get TableColumnLength sReportId iTable iColumn to iLength
            Get AddTreeItem of oResults ("Length:" * String (iLength)) hColumnItem iColumn 0 0 to hVoid
        End_Procedure

        Procedure ShowColumnPrecision String sReportId Integer iTable Integer iColumn Handle hColumnItem
            Integer iPrecision
            Handle hVoid

            Get TableColumnPrecision sReportId iTable iColumn to iPrecision
            Get AddTreeItem of oResults ("Precision:" * String (iPrecision)) hColumnItem iColumn 0 0 to hVoid
        End_Procedure

        Procedure ShowColumnIndex String sReportId Integer iTable Integer iColumn Handle hColumnItem
            Integer iIndex
            Handle hVoid

            Get TableColumnIndex sReportId iTable iColumn to iIndex
            Get AddTreeItem of oResults ("Index:" * String (iIndex)) hColumnItem iColumn 0 0 to hVoid
        End_Procedure
    End_Object

    Object oShowInfoButton is a Button
        Set Location to 5 294
        Set Label to 'Show Info'
        Set peAnchors to anTopRight

        Procedure OnClick
            Send ShowInfo of oReport
        End_Procedure
    End_Object
Cd_End_Object
