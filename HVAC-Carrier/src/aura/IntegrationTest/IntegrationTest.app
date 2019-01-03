<aura:application controller="IntegrationTestApx" access="global" extends="force:slds">
    <aura:attribute name="salesDetail" type="Object"/>
    <aura:attribute name="salesDetail2" type="List"/>
    <aura:attribute name="dealerDetail" type="object"/>
    <aura:attribute name="materialDetails" type="List"/>
    <aura:attribute name="displayInput" type="boolean" default="false"/>
    <aura:attribute name="displayHeader" type="boolean" default="false"/>
    <aura:attribute name="displayHeaderWithParam" type="boolean" default="false"/>
    
    <div>
        
        <div class="slds-m-around_medium">
            <lightning:layout>          
                <lightning:layoutItem size="1" padding="around-small">
                    <div><br></br><lightning:button onclick="{!c.Header}" variant="brand" label="KQuotes"/></div>
                </lightning:layoutItem> 
                <lightning:layoutItem size="2" padding="around-small">
                    <div><br></br><lightning:button onclick="{!c.HeaderWithParams}" variant="brand" label="KQuotes related to Dealer"/></div>
                </lightning:layoutItem> 
                <lightning:layoutItem size="2" padding="around-small">
                    <div><br></br><lightning:button onclick="{!c.Input}" variant="brand" label="Input Response"/></div>
                </lightning:layoutItem>  
            </lightning:layout>
        </div>
        <aura:renderIf isTrue="{!v.displayHeader}">
            <table class="slds-table slds-table_bordered slds-table_striped slds-table_cell-buffer slds-table_fixed-layout">
                <thead>
                    <tr class="slds-text-heading_label">
                        <th scope="col"><div class="slds-truncate">Quote Number</div></th>
                        <th scope="col"><div class="slds-truncate">Quote Ref Number</div></th>
                        <th scope="col"><div class="slds-truncate">Distributor</div></th>
                        <th scope="col"><div class="slds-truncate">Quote Description</div></th>
                        <th scope="col"><div class="slds-truncate">KD Level</div></th>
                        <th scope="col"><div class="slds-truncate">KD Level Description</div></th>
                        <th scope="col"><div class="slds-truncate">Eff Date</div></th>
                        <th scope="col"><div class="slds-truncate">Exp Date</div></th>
                    </tr>
                </thead>
                <tbody>
                    <aura:iteration items="{!v.salesDetail2}" var="salesDetail2">
                        <tr>
                            <th scope="row"><div class="slds-truncate">{!salesDetail2.REFQUOTE}</div></th>
                            <th scope="row"><div class="slds-truncate">{!salesDetail2.SDeal}</div></th>
                            <td><div class="slds-truncate">{!salesDetail2.SDistributor}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.SDealDesc}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.KDLevel}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.KDLevelDesc}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.HDRValidFromDate}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.HDRValidToDate}</div></td>
                        </tr>
                    </aura:iteration>
                </tbody>
            </table>
        </aura:renderIf>
        
         <aura:renderIf isTrue="{!v.displayHeaderWithParam}">
            <table class="slds-table slds-table_bordered slds-table_striped slds-table_cell-buffer slds-table_fixed-layout">
                <thead>
                    <tr class="slds-text-heading_label">
                        <th scope="col"><div class="slds-truncate">Quote Number</div></th>
                        <th scope="col"><div class="slds-truncate">Quote Ref Number</div></th>
                        <th scope="col"><div class="slds-truncate">Distributor</div></th>
                        <th scope="col"><div class="slds-truncate">Quote Description</div></th>
                        <th scope="col"><div class="slds-truncate">KD Level</div></th>
                        <th scope="col"><div class="slds-truncate">KD Level Description</div></th>
                        <th scope="col"><div class="slds-truncate">Eff Date</div></th>
                        <th scope="col"><div class="slds-truncate">Exp Date</div></th>
                    </tr>
                </thead>
                <tbody>
                    <aura:iteration items="{!v.salesDetail2}" var="salesDetail2">
                        <tr>
                            <th scope="row"><div class="slds-truncate">{!salesDetail2.REFQUOTE}</div></th>
                            <th scope="row"><div class="slds-truncate">{!salesDetail2.SDeal}</div></th>
                            <td><div class="slds-truncate">{!salesDetail2.SDistributor}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.SDealDesc}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.KDLevel}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.KDLevelDesc}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.HDRValidFromDate}</div></td>
                            <td><div class="slds-truncate">{!salesDetail2.HDRValidToDate}</div></td>
                        </tr>
                    </aura:iteration>
                </tbody>
            </table>
        </aura:renderIf>
    </div>
    
    <aura:renderIf isTrue="{!v.displayInput}">
        <div>
            <br></br><br></br><br></br>
            
            <span>Sales Detail:</span>
            <br></br><br></br>
            <table class="slds-table slds-table_bordered slds-table_striped slds-table_cell-buffer slds-table_fixed-layout">
                <thead>
                    <tr class="slds-text-heading_label">
                        <th scope="col"><div class="slds-truncate">Distributor</div></th>
                        <th scope="col"><div class="slds-truncate">HDR Valid From Date</div></th>
                        <th scope="col"><div class="slds-truncate">HDR Valid To Date</div></th>
                        <th scope="col"><div class="slds-truncate">KD Level</div></th>
                        <th scope="col"><div class="slds-truncate">KD Level Desc</div></th>
                        <th scope="col"><div class="slds-truncate">Price List</div></th>
                        <th scope="col"><div class="slds-truncate">REF QUOTE</div></th>
                        <th scope="col"><div class="slds-truncate">Sales Deal</div></th>
                        <th scope="col"><div class="slds-truncate">Sales Deal Desc</div></th>                        
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row"><div class="slds-truncate">{!v.salesDetail.Distributor}</div></th>
                        <td><div class="slds-truncate">{!v.salesDetail.HDR_Valid_From_Date}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.HDR_Valid_To_Date}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.KD_Level}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.KD_Level_Desc}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.Price_List}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.REF_QUOTE}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.Sales_Deal}</div></td>
                        <td><div class="slds-truncate">{!v.salesDetail.Sales_Deal_Desc}</div></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div>
            <br></br><br></br><br></br>       
            <span>Material Detail</span>
            <br></br>
            <table class="slds-table slds-table_bordered slds-table_striped slds-table_cell-buffer slds-table_fixed-layout">
                <thead>
                    <tr class="slds-text-heading_label">
                        <th scope="col"><div class="slds-truncate">Brand</div></th>
                        <th scope="col"><div class="slds-truncate">Buy Price</div></th>
                        <th scope="col"><div class="slds-truncate">ITEM Valid From Date</div></th>
                        <th scope="col"><div class="slds-truncate">ITEM Valid To Date</div></th>
                        <th scope="col"><div class="slds-truncate">Material Entered</div></th>
                        <th scope="col"><div class="slds-truncate">Sell Price</div></th>
                    </tr>
                </thead>
                <tbody>
                    <aura:iteration items="{!v.materialDetails}" var="materialDetail">
                        <tr>
                            <th scope="row"><div class="slds-truncate">{!materialDetail.Brand}</div></th>
                            <td><div class="slds-truncate">{!materialDetail.Buy_Price}</div></td>
                            <td><div class="slds-truncate">{!materialDetail.ITEM_Valid_From_Date}</div></td>
                            <td><div class="slds-truncate">{!materialDetail.ITEM_Valid_To_Date}</div></td>
                            <td><div class="slds-truncate">{!materialDetail.Material_Entered}</div></td>
                            <td><div class="slds-truncate">{!materialDetail.Sell_Price}</div></td>
                        </tr>
                    </aura:iteration>
                </tbody>
            </table>
        </div> 
        <div>
            <br></br><br></br><br></br>
            <span>Dealer Details:</span>
            <br></br><br></br>
            <table class="slds-table slds-table_bordered slds-table_striped slds-table_cell-buffer slds-table_fixed-layout">
                <thead>
                    <tr class="slds-text-heading_label">
                        <th scope="col"><div class="slds-truncate">Dealer</div></th>
                        <th scope="col"><div class="slds-truncate">DLR Valid From Date</div></th>
                        <th scope="col"><div class="slds-truncate">DLR Valid To Date</div></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row"><div class="slds-truncate">{!v.dealerDetail.Dealer}</div></th>
                        <td><div class="slds-truncate">{!v.dealerDetail.DLR_Valid_From_Date}</div></td>
                        <td><div class="slds-truncate">{!v.dealerDetail.Dealer}</div></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </aura:renderIf>
    <!--<c:Add_Dealer_step1/>
    <c:Add_Dealer_step2/>
    <c:Add_Dealer_step3/>
    <c:Add_Dealer_step4/>
    <c:DealerProfile/>
    <c:Add_Dealer_Competitive_Sell_Request/>-->
</aura:application>