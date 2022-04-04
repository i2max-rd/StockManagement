public with sharing class CXP_AMOS_RestAPIWrapper {
    public static CXP_AMOS_RestAPIWrapper parse(String json) { 
        return (CXP_AMOS_RestAPIWrapper) System.JSON.deserialize(json, CXP_AMOS_RestAPIWrapper.class);
    }

    public class Response { 
        public Payload payload;
        public Header header;
    }

    public class ES_DATA {
        public String AMOSDealerCode;
        public String DealerCode;
        public String AMOSMOBISSuffix;
        public String AMOSOrderNo;
        public String OrderType;
        public String Description;
        public String DistributeCode;
        public String OrderNoCXP;
        public String OrderRecieveDate;
        public String OrderRefNo;
        public String Flag;
        public String CoDate;
    }

    public Response response;

    public class Header {
        public String ifDateTime;
        public String ifReceiverGrp;
        public String ifResult;
        public String ifTrackingId;
        public String ifReceiver;
        public String ifId;
        public String ifSenderGrp;
        public String ifFailMsg;
        public String ifSender;
    }

    public class ES_ITEM {
        public String AMOSMOBISSuffix;
        public String fm_OrderQt;
        public String OrderNumberCXP;
        public String AMOSConfirmPartNo;
        public String Description;
        public String AMOSDiscountCode;
        public String DistributeCode;
        public String OrderedPartNo;
        public String AMOSDelAcceptYn;
        public String CurrencyISOCode;
        public String DealerCode;
        public String UnitPrice;
        public String AMOSOrderNo;
        public String OrderLineNoCXP;
        public String AMOSConfirmQty;
        public String CancelCode;
        public String CancelDescription;
    }

    public class Payload {
        public ES_DATA ES_DATA;
        public List<ES_ITEM> ES_ITEM;
    }
}