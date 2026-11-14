local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001709_MainPanel = class("Activity_9001709_MainPanel", baseFguiPanel)
function Activity_9001709_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001709_MainPanel.super.ctor(self, ...)
	print("Activity_9001709_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE_HELP_9001709
end
function Activity_9001709_MainPanel:onInit()
	print("=======Activity_9001709_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_des1:setString(i18n("migrant_move_text61"))
	self.fields.Text_des2:setString(i18n("migrant_move_text62"))
	self.fields.Button_go:setString(i18n("migrant_move_text60"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.fields.mv_light:setAllFrameNameOnce("dh_zhangjie10_%02d.png", 0)
	self.fields.mv_xian:setAllFrameNameOnce("G_9001709_xian_%02d.png", 1)
	_UPVALUE3_ = self.fields.mv_xian.setAllFrameNameOnce
	self.fields.mv_xian.setAllFrameNameOnce[1] = i18n("migrant_move_text68")
	self.fields.mv_xian.setAllFrameNameOnce[2] = i18n("migrant_move_text69")
	self.fields.mv_xian.setAllFrameNameOnce[3] = i18n("migrant_move_text70")
	self.fields.mv_xian.setAllFrameNameOnce[4] = i18n("migrant_move_text71")
	self.fields.mv_xian.setAllFrameNameOnce[5] = i18n("migrant_move_text71")
	self.fields.mv_xian.setAllFrameNameOnce[6] = i18n("migrant_move_text71")
	self.fields.mv_xian.setAllFrameNameOnce[7] = i18n("migrant_move_text71")
	self.fields.mv_xian.setAllFrameNameOnce[8] = i18n("migrant_move_text71")
	self.fields.mv_xian.setAllFrameNameOnce[9] = i18n("migrant_move_text71")
	self.fields.mv_xian.setAllFrameNameOnce[10] = i18n("migrant_move_text71")
	local self.fields.mv_xian.setAllFrameNameOnce[11], config = i18n("migrant_move_text71")
	for i, v in ipairs(config) do
		local obj = self.fields["Com_main" .. i]
		if obj then
			obj:setString(v)
			local _fields = fguiHelper.get_fields(obj)
			fguiHelper.setTextHeight(_fields.title, 70)
			_fields.mv_fuhuo:setAllFrameNameOnce("dh_jinengyj01_%.3d.png", 0)
			_fields.mv_paopao:setAllFrameNameOnce("9001692_paopao_%02d.png", 1)
		end
	end
end
function Activity_9001709_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("migrant_move_text74")
	uiManager:show("RuleView", nil)
end
function Activity_9001709_MainPanel:endShow()
	print("=======Activity_9001709_MainPanel:endShow")
end
function Activity_9001709_MainPanel:onClickBtnGo()
	SoraDPlaySound()
	self:closePanel()
	clientEventMgr.singleClickEvent(gActivityTimeActivityID.KOH_MIGRATE)
end
return Activity_9001709_MainPanel
