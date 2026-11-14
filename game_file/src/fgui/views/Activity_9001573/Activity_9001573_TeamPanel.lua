local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_TeamPanel = class("Activity_9001573_TeamPanel", baseFguiPanel)
local constantRead = include("constantRead")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
function Activity_9001573_TeamPanel:ctor(...)
	Activity_9001573_TeamPanel.super.ctor(self, ...)
	print("Activity_9001573_TeamPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001573_TeamPanel:onInit()
	print("=======Activity_9001573_TeamPanel:onInit")
	self.fields.n14:fixPos()
	self.fields.txt_num:fixPos()
	self.fields.Com_title:initData(i18n("alliance_office_name_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.txt_des:setString(i18n("Celestial_defense_text_008"))
	self.fields.list:setItemRenderer(handler(self, self.onPlayerItemRederer))
	self.commanderLimit = constantRead.getConstValue("CELESTIAL_DEFENSE_COMMANDER", 3)
	activity_9001573_Ctrl:reqCommandList()
	SoraDShowLoading(self:displayObject())
end
function Activity_9001573_TeamPanel:onShow()
	print("=======Activity_9001573_TeamPanel:onShow")
end
function Activity_9001573_TeamPanel:initData(data)
	SoraDCloseLoading(self:displayObject())
	local limitNum = self.commanderLimit
	local nowNum = activity_9001573_Ctrl:getCommanderNum()
	_ENV = self:displayObject()
	self:displayObject().num1 = nowNum
	self:displayObject().num2 = limitNum
	self.fields.txt_num:setString(i18n("Celestial_defense_text_009", self:displayObject()))
	dump(data, "Activity_9001573_TeamPanel:initData")
	self.memberList = data.commandList
	self.fields.list:setNumItems(limitNum)
end
function Activity_9001573_TeamPanel:onPlayerItemRederer(index, obj)
	local memberData = self.memberList[index + 1]
	obj:initData(memberData)
end
function Activity_9001573_TeamPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Celestial_defense_text_007")
	uiManager:show("RuleView", nil)
end
return Activity_9001573_TeamPanel
