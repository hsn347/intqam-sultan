local baseComponent = require("fgui.base.baseComponent")
local Com_ML_SRTask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_SRTask", Com_ML_SRTask)
function Com_ML_SRTask:onInit()
	self:fixChildrenPos()
	self.fields.go:setTitle(i18n("common_text_477"))
	self.fields.go:addClickEventListener(handler(self, self.onGoClick))
end
function Com_ML_SRTask:onShow()
end
function Com_ML_SRTask:initData(data)
	self.fields.txt_desc:setString(data.desc)
	self.fields.txt_count:setString(string.format("(%d/%d)", data.num, data.max))
	self.controllers.c1:setSelectedIndex(data.num >= data.max and 0 or 1)
	self.fields.go:setVisible(data.guideID ~= nil)
	self.guideID = data.guideID
	self.desc = data.desc
end
function Com_ML_SRTask:onGoClick()
	SoraDPlaySound()
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local tbParam = mildGuideManager:splitGuideParam(self.guideID)
	if tbParam.id == gNewPLayerTaskType.POP_TIP then
		SoraDShowMsgTip(i18n(self.desc))
	end
	dump(self.guideID, "self.guideID")
	if self.guideID then
		local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(self.guideID)
		if not notNeedClose then
			SoraDRemoveAllPanelFromManager()
		end
	end
end
return Com_ML_SRTask
