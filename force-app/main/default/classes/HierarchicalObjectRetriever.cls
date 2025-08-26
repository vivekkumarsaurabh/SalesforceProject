public class HierarchicalObjectRetriever {
    private static final Integer MAX_DEPTH = 10; // Set a limit for depth

    public static void getHierarchicalRelatedObjects(String objectName) {
        Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();

        if (!allObjects.containsKey(objectName)) {
            System.debug('Object not found: ' + objectName);
            return;
        }

        // Start with the specified object
        Schema.SObjectType startingObject = allObjects.get(objectName);
        Set<String> visitedObjects = new Set<String>();

        // Retrieve the hierarchy
        traverseRelationships(startingObject, visitedObjects, 0);
    }

    private static void traverseRelationships(Schema.SObjectType sObjectType, Set<String> visitedObjects, Integer level) {
        if (level > MAX_DEPTH) {
            return; // Prevent exceeding max depth
        }

        Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();

        // Add the current object to the visited set
        if (visitedObjects.contains(describeResult.getName())) {
            return; // Avoid circular references
        }
        visitedObjects.add(describeResult.getName());

        // Indent for visual hierarchy
        String indent = String.join(new List<String>(new String[level]), ' ');

        // Output the current object
        System.debug(indent + describeResult.getName());

        // Traverse child relationships
        for (Schema.ChildRelationship childRelationship : describeResult.getChildRelationships()) {
            if (childRelationship.getChildSObject() != null) {
                Schema.SObjectType childType = childRelationship.getChildSObject();
                traverseRelationships(childType, visitedObjects, level + 1);
            }
        }
    }
}