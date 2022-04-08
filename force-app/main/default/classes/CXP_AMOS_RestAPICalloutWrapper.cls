public with sharing class CXP_AMOS_RestAPICalloutWrapper {
    public Request request;

    public class Request {
        public Header header;
        public Payload payload;

        public Request() {
            header = new Header('IF_EU_CXP_AMOS_0001', 'EU', 'CXP', 'EU', 'AMOS');
        }
    }

    public class Header {
        public String ifId;
        public String ifVer = 'v001';
        public String ifSenderGrp;
        public String ifSender;
        public String ifReceiverGrp;
        public String ifReceiver;
        public String ifTrackingId;
        public String ifDateTime  = System.now().format('yyyyMMddkkmmss');

        public Header(String ifId,  String ifSenderGrp, String ifSender, String ifReceiverGrp, String ifReceiver) {
            this.ifId = ifId;
            this.ifSenderGrp = ifSenderGrp;
            this.ifSender = ifSender;
            this.ifReceiverGrp = ifReceiverGrp;
            this.ifReceiver = ifReceiver;
        }

    }

    public class T_DATA {
        public String DistributeCode;
        public String DealerCode;
        public String AMOSMOBISSuffix;
        public String ProductRequestNumber;
        public String OrderRefNo;
        public String OrderType;
        public String Description;
        public String Flag;
    }

    public class T_ITEM {
        public String DistributeCode;
        public String DealerCode;
        public String AMOSMOBISSuffix;
        public String ProductRequestNumber;
        public String OrderPartNo;
        public String ProductRequestLineItemNumber;
        public String QuantityRequested;
        public String FreeHomeDelivery;
        public String Description;
    }


    public class Payload {
        public T_DATA T_DATA;
        public List<T_ITEM> T_ITEM;
    }


    public static CXP_AMOS_RestAPICalloutWrapper parse(String json) {
        return(CXP_AMOS_RestAPICalloutWrapper) System.JSON.deserialize(json, CXP_AMOS_RestAPICalloutWrapper.class);
    }
 
    
    
}