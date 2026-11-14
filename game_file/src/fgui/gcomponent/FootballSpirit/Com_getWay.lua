local baseComponent = require("fgui.base.baseComponent")
local Com_getWay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://FootballSpirit/Com_getWay", Com_getWay)
function Com_getWay:onInit()
	self.fields.btn_go:setString(i18n("common_text_477"))
	self.fields.btn_go:addClickListener(handler(self, self.onBtnGo))
	self:fixChildrenPos()
end
function Com_getWay:onShow()
end
function Com_getWay:initData(data, parent)
	self.data = data
	self.parent = parent
	if self.data.wType == 1 then
		self.fields.title:setString(i18n("equip_text_46"))
	elseif self.data.wType == 2 then
		local cfg = clientEventMgr.getActivityCfg(self.data.activityID)
		self.fields.title:setString(cfg.name)
	end
end
function Com_getWay:onBtnGo()
	SoraDPlaySound()
	if self.data.wType == 1 then
		_ENV = nil
		;(nil).pType = 0
		uiManager:show("FootballSpiritProp", nil)
	elseif self.data.wType == 2 then
		if clientEventMgr.judgeIsOpen(self.data.activityID) then
			clientEventMgr.singleClickEvent(self.data.activityID, 7)
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	end
	self.parent:close()
end
return Com_getWay
