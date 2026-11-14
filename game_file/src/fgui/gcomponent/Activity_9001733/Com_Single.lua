local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001733/Com_Single", Com_Single)
function Com_Single:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.itemRenderer_List_award))
	self.fields.Button_btn:addClickListener(handler(self, self.onClick_Button_btn))
	self.fields.txtNotReached:setString("common_text_2139")
	self.fields.txtReceived:setString(i18n("common_text_1892"))
	self:fixChildrenPos()
end
function Com_Single:onShow()
end
local getGuideID = function(guideId)
	if type(guideId) == "string" then
		guideId = string.trim(guideId)
		return string.len(guideId) > 0 and guideId or nil
	end
	return nil
end
function Com_Single:initData(activityID, data)
