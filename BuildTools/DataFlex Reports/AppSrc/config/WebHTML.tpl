Use cWebView.pkg
Use cWebPanel.pkg
Use cWebButton.pkg
Use cWebCardContainer.pkg
Use cWebCheckbox.pkg
Use cWebCombo.pkg
Use cWebGroup.pkg

Use cDRReport.pkg
Use cWebDRReportViewer.pkg

Object oWebReportView is a cWebView
    Set piColumnCount to 12
// ToDo: Change the label of this report view, adjust the menu item on the report pull-down
    Set psCaption to "DataFlex Reports Web View"
    Set piMinWidth to 700

    // Your DDO structure will go here

    Object oReport is a cDRReport
// ToDo: Assign a report filename.
//        Set psReportName to 'somename.DR'

        Procedure OnInitializeReport
            Send SetFilters
            Send SetSortFields
        End_Procedure
        
        Procedure SetSortFields
// ToDo: Write the code to change the sort order in the report
            // Example code:
            String sSortOnColumn
            Boolean bDescending
            
            // Optionally remove all existing sort fields
//            Send RemoveAllRecordSortFields C_USEMAINDRREPORTID
            WebGet psValue of oSortOnCombo to sSortOnColumn
            Get GetChecked of oSortDescending to bDescending
            If (bDescending) Begin
                Send AddRecordSortField C_USEMAINDRREPORTID sSortOnColumn C_DRDescending
            End
            Else Begin
                Send AddRecordSortField C_USEMAINDRREPORTID sSortOnColumn C_DRAscending
            End
            // Or:
//            Send AddRecordSortField C_USEMAINDRREPORTID "{Table.ColumnReference}" C_DRAscending
        End_Procedure
        
        Procedure SetFilters
// ToDo: Write the code to get the values from the selection input controls and pass them to DataFlex Reports via Send AddFilter
            // Example code:
//            String sReportId
//            Integer[] iCustomerCustomerNumbers
//
//            Get psReportId to sReportId
//
//            WebGet psValue of oFromCustomerCustomerNumber to iCustomerCustomerNumbers[0]
//            WebGet psValue of oToCustomerCustomerNumber to iCustomerCustomerNumbers[1]
        End_Procedure
    End_Object

    Object oWebMainPanel is a cWebPanel
        Set piColumnCount to 12

        // place controls for report selections here.
        // Your view will grow as controls are added

        Object oSortOrderGroup is a cWebGroup
            Set psCaption to "Order By:"
            Set piColumnCount to 5

            Object oSortOnCombo is a cWebCombo
                Set piColumnSpan to 3
                Set pbShowLabel to False

                Procedure OnFill
                    Send AddComboItem "{Table.ColumnReference}" "Column name to show to user"
                    Send AddComboItem "{Table.ColumnReference}" "Column name to show to user"
                    Send AddComboItem "{Table.ColumnReference}" "Column name to show to user"
                End_Procedure
            End_Object

            Object oSortDescending is a cWebCheckBox
                Set piColumnIndex to 3
                Set psCaption to "Descending"
            End_Object
        End_Object

        Procedure RunReport
            Send ShowReport of oViewer
        End_Procedure
        
        Object oRunReportButton is a cWebButton
            Set psCaption to "Run Report"
            Set piColumnSpan to 2

            Procedure OnClick
                Send RunReport
            End_Procedure
        End_Object

        Object oViewer is a cWebDRReportViewer
		    Set phoReport to oReport
        End_Object
    End_Object
End_Object