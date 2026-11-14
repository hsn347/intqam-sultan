local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_farm = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_farm", Com_farm)
function Com_farm:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.fields.bglv:fixPos()
	self.fields.Text_lv:fixPos()
end
function Com_farm:onShow()
end
function Com_farm:initData(parent, data)
	self.parent = parent
	self.data = data
	if self.data.uid ~= SoraDGetPlayerID() or not i18n("bubble_farm_text16") then
		_ENV = nil
		;(nil).name = self.data.nickName
	end
	self.fields.title:setString((i18n("bubble_farm_text11", nil)))
	self.fields.title:setColor(self.data.uid == SoraDGetPlayerID() and cc.c3b(112, 199, 35) or cc.c3b(240, 230, 210))
	local curLv = activity_9001661_Ctrl:getGrowthLv(self.data)
	self.fields.Text_lv:setString(curLv)
	self.fields.icon:setSpriteFrame(activity_9001661_Read.getFarmSmallIcon(curLv))
	local total = constantRead.getConstValue("FARM_ACCEPPT_HELP_NUM", 2)
	_ENV = activity_9001661_Read.getFarmSmallIcon(curLv)
	activity_9001661_Read.getFarmSmallIcon(curLv).num = #self.data.assistanceUsers
	activity_9001661_Read.getFarmSmallIcon(curLv).maxnum = total
	self.fields.Text_count:setString(i18n("bubble_farm_text12", activity_9001661_Read.getFarmSmallIcon(curLv)))
	self.isHelped = SoraDisInList(SoraDGetPlayerID(), self.data.assistanceUsers)
	self.isFullHelp = #self.data.assistanceUsers >= constantRead.getConstValue("FARM_ACCEPPT_HELP_NUM", 2)
	self.fields.icon:setGrayed(self.data.uid ~= SoraDGetPlayerID() and (self.isHelped or self.isFullHelp))
end
function Com_farm:getUid()
	return self.data.uid
end
function Com_farm:btnClick()
	SoraDPlaySound()
	if self.data.uid == SoraDGetPlayerID() then
		uiManager:show("Activity_9001661_Main")
		if self.parent then
			self.parent:close()
		end
	else
		if self.isHelped then
			SoraDShowMsgTip(i18n("bubble_farm_text15"))
			return
		end
		local times = constantRead.getConstValue("FARM_HELP_NUM", 2) - activity_9001661_Ctrl:getAssistanceTimes()
		if times <= 0 then
			SoraDShowMsgTip(i18n("bubble_farm_text13"))
			return
		end
		if self.isFullHelp then
			SoraDShowMsgTip(i18n("bubble_farm_text14"))
			return
		end
		_ENV = i18n("bubble_farm_text14")
		i18n("bubble_farm_text14").member = self.data
		i18n("bubble_farm_text14").from = "map"
		uiManager:show("Activity_9001661_Main", i18n("bubble_farm_text14"))
	end
end
return Com_farm
