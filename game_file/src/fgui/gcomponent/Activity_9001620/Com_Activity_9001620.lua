local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001620_Read = include("activity_9001620_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001620 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001620/Com_Activity_9001620", Com_Activity_9001620)
function Com_Activity_9001620:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_PREVIEW
end
function Com_Activity_9001620:onShow()
	self.fields.timer:initCommonActivityTime(self.activityID)
	self.cfg = activity_9001620_Read.getPreviewCfg(self:getGroup())
	self:initData()
end
function Com_Activity_9001620:initData()
	for i = 1, 4 do
		if self.cfg[i] then
			self.fields["n" .. i]:setVisible(true)
			self.fields["n" .. i]:initData(self.cfg[i])
		else
			self.fields["n" .. i]:setVisible(false)
		end
	end
end
function Com_Activity_9001620:getGroup()
	local param = activityShowCtrl:getParamByID(self.activityID)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return Com_Activity_9001620
