public with sharing class SendPartOrderToAMOS {
    
    private static final String CONSTANT_AMOSENDPOINT = 'AMOS';
    private static final String CONSTANT_INTERFACENAME = 'IF_EU_CXP_AMOS_0001';
    private static String strTrackingId;
    private static Id partsOrderId;
    private static Map<String, String> partNoIdMap;   

    @AuraEnabled(cacheable=true)
    public static Parts_Order__c getProductRequestForAMOSCallout(Id productRequestId) { 
        Parts_Order__c prodRequest = [ 
            SELECT Id, CreatedDate, Department__r.Cost_Center_Code__c, Department__r.Department_Code__c, AMOSMOBIS_Suffix__c, Name, OrderRefNo__c, Order_Type__c, 
            Description__c, Flag__c, Department__r.DistCode__c, Department__r.DealerCode__c, Department__r.MobisSuffix__c, DepartmentCode__c, Dealer_Code__c, 
            (SELECT Id, Ordered_Product__r.ProductCode, Ordered_Product__r.Id, Order_Line_No__c, Quantity_Requested__c, Free_Home_Delivery__c, Description__c FROM Parts_Order_Line_Item__r)
            FROM Parts_Order__c
            WHERE Id =: productRequestId
        ];

        partNoIdMap = new Map<String, String>();
        for(Parts_Order_Line_Item__c po : prodRequest.Parts_Order_Line_Item__r) { 
            partNoIdMap.put(po.Ordered_Product__r.ProductCode, po.Ordered_Product__r.Id);
        }

        return prodRequest;
    }


    public static String generateBody(Id productRequestId) { 

        Parts_Order__C prodRequest = get
    }
}
