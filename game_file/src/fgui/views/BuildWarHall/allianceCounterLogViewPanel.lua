local allianceCounterSysCtrl = SoraDGetCtrl("allianceCounterSysCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceCounterLogViewPanel = class("allianceCounterLogViewPanel", baseFguiPanel)
function allianceCounterLogViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceCounterLogViewPanel:ctor", self.viewName)
end
function allianceCounterLogViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceCounterLogViewPanel:onInit()
	print("=======allianceCounterLogViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("CounterSystem_btn_11"))
	self.scroll = self.fields.scroll
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_1464"))
	self.labelNotice:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_COUNTER_RECORD_INFO", function(target, data)
		table.sort(data.enemyData, function(l, r)
			return l.counterPower > r.counterPower
		end)
		self.data = data.enemyData
		self:updateView()
		SoraDCloseLoading(self)
	end)
end
function allianceCounterLogViewPanel:onShow()
	print("=======allianceCounterLogViewPanel:onShow")
end
function allianceCounterLogViewPanel:onItemRenderer(index, single)
	local data = self.data[index + 1]
	local power = SoraDGetChildByName(single, "Text_power")
	local name = SoraDGetChildByName(single, "Text_name")
	local head = SoraDGetChildByName(single, "CCS_commonHead_head")
	_ENV = nil
	;(nil).num = string.formatnumberthousands(data.counterPower)
	power:setString(i18n("CounterSystem_text_34", nil))
	name:setString(data.nickName)
	head:setPlayerID(data.uid)
	head:setHeadSprite(data.iconID, data.avatar)
end
function allianceCounterLogViewPanel:initData(uid)
	self.uid = uid
	allianceCounterSysCtrl:getCounterRecord(self.uid)
	SoraDShowLoading(self)
end
function allianceCounterLogViewPanel:updateView()
	self.labelNotice:setVisible(#self.data <= 0)
	self.scroll:setNumItems(#self.data)
end
return allianceCounterLogViewPanel
