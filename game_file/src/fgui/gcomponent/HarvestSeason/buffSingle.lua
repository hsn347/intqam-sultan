local gametop = gModuleMgr.getObject("gametop")
local buffltCtrl = include("buffltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local buffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HarvestSeason/buffSingle", buffSingle)
function buffSingle:onInit()
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
	self.fields.n0:fix()
end
function buffSingle:initData(index, data)
	self.activityID = data.activityID
	self.fields.icon:setURL(data.icon .. ".png")
	self.fields.Text_name:setString(i18n(data.text))
	if data.boostValue == 0 or data.boostValue == "0" then
		self.fields.Text_value:setVisible(false)
		return
	end
	local lang = SoraDGetDefaultLanguage()
	if lang == "ar" then
		self.fields.Text_value:setString("%" .. tostring(data.boostValue / 10) .. "+")
	else
		self.fields.Text_value:setString("+" .. tostring(data.boostValue / 10) .. "%")
	end
	self.fields.Button_go:setVisible(self.activityID == gActivityTimeActivityID.BUMPER_TREVIFOUNTAIN)
end
function buffSingle:onShow()
end
function buffSingle:btnClick()
	if self.activityID == gActivityTimeActivityID.BUMPER_TREVIFOUNTAIN then
		SoraDPlaySound()
		if not SoraDGetCtrl("cityCtrl"):getBuildCell(BUILDID.WISHING_WELL, 0) then
			SoraDShowMsgTip(i18n("common_text_4846"))
			return
		end
		SoraDRemoveAllPanelFromManager()
		_ENV = i18n("common_text_4846")
		gModuleMgr.sharedMgr("mildGuideManager"):starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, i18n("common_text_4846"))
	end
end
return buffSingle
