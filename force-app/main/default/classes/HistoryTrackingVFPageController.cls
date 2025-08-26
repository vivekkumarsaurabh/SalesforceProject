public class HistoryTrackingVFPageController {
    public String objectName { get; set; }
    public String recordId {get; set;}

    public HistoryTrackingVFPageController() {
        recordId = ApexPages.currentPage().getParameters().get('recordId');
        objectName = ApexPages.currentPage().getParameters().get('objectName');
    }
}