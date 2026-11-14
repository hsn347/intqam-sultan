local constantRead = include("constantRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_main = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001643/Com_main", Com_main)
function Com_main:onInit()
	self.member, _ENV, self.reward, _ENV = nil, nil, nil, nil
	self.fields.Lab_my:setString(i18n("eidal_celebration_text23"))
	self.fields.Lab_alliance:setString(i18n("eidal_celebration_text14"))
	self.fields.Text_helpTip:setString(i18n("eidal_celebration_text17"))
	self.fields.Text_tip:setString(i18n("eidal_celebration_text34"))
	self.fields.Text_none:setString(allianceMgr:hasJoinAlliance() and i18n("eidal_celebration_text43") or i18n("eidal_celebration_text15"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onMemberRenderer))
end
function Com_main:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_main:onMemberRenderer(index, obj)
	obj:initData(self.member[index + 1])
end
function Com_main:onShow()
end
function Com_main:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001643_HELPLIST", handler(self, self.updateView))
end
function Com_main:updateView(target, data)
	if not data or not data.helpList then
		_UPVALUE0_ = data.helpList
	end
	self.member = data.helpList
	self.fields.List:setNumItems(#self.member)
	self.fields.List:setHeight(#self.member * 112 + (#self.member - 1) * 10)
	self.fields.Text_none:setVisible(#self.member == 0)
end
function Com_main:initData()
	if allianceMgr:hasJoinAlliance() then
		activity_9001643_Ctrl:reqHelpList()
	else
		self:updateView()
	end
	self.fields.Com_my:initMyData()
	allianceMgr = nil
	local reward = constantRead.getConstValueArray("EIDAL_CELEBRATION_HELP_REWARD", nil)
	constantRead = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(reward, nil)
	self.fields.List_reward:setNumItems(#self.reward)
	self.fields.List_reward:setWidth(#self.reward * 60 + (#self.reward - 1) * 10)
	self.fields.rbg:setWidth(self.fields.List_reward:getWidth() + 10)
	local helpCount = activity_9001643_Ctrl:getHelpCount()
	local limitNum = constantRead.getConstValue("EIDAL_CELEBRATION_HELP_DAILY_NUM")
	allianceMgr = nil
	;(nil).num = fguiHelper.getColorString(0 < helpCount and "#00FF3C" or "#D6C29A", helpCount)
	;(nil).limit = limitNum
	self.fields.Text_today:setString(i18n("eidal_celebration_text18", nil))
end
return Com_main
