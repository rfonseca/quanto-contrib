from QuantoCoreConstants import QuantoCoreConstants
from QuantoAppConstants import *
class activity:        
    def __init__(self, act = QuantoCoreConstants.ACT_INVALID):
        self.act = act & 0xFFFF

    def set(self, act):
        self.act = act & 0xFFFF

    def get(self):
        return act
    def get_node(self):
        return (self.act >> QuantoCoreConstants.ACT_NODE_OFF) & QuantoCoreConstants.ACT_NODE_MASK
    def get_activity_type(self):
        return (self.act >> QuantoCoreConstants.ACT_TYPE_OFF) & QuantoCoreConstants.ACT_TYPE_MASK
    def set_node(self, node):
        self.act = (self.act & ~(QuantoCoreConstants.ACT_NODE_MASK << QuantoCoreConstants.ACT_NODE_OFF)) | \
                   ((node & QuantoCoreConstants.ACT_NODE_MASK) << QuantoCoreConstants.ACT_NODE_OFF)
    def set_activity_type(self, act_type):
        self.act = (self.act & ~(QuantoCoreConstants.ACT_TYPE_MASK << QuantoCoreConstants.ACT_TYPE_OFF)) | \
                   ((act_type & QuantoCoreConstants.ACT_TYPE_MASK) << QuantoCoreConstants.ACT_TYPE_OFF)

    def isValid(self):
        return self.get_node() != QuantoCoreConstants.ACT_NODE_INVALID
    def isIdle(self):
        return self.isValid() and self.get_activity_type == QuantoAppConstants.QUANTO_IDLE_ACTIVITY_ID
    def isUnknown(self):
        return self.isValid() and self.get_activity_type == QuantoAppConstants.QUANTO_UNKNOWN_ACTIVITY_ID

    def __str__(self):
        if self.isValid():
           return str(self.get_node()) + ':' + self.activity_type_str() 
        else:
           return 'inv:inv'

    def activity_type_str(self):
        act_type = self.get_activity_type()
        name = act_type
        if (QuantoAppConstants.activityNames.has_key(act_type)):
            name = QuantoAppConstants.activityNames[act_type]
        return str(name)


