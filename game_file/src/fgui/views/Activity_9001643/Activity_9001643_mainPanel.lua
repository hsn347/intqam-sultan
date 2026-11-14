local activity_9001643_Ctrl = SoraDGetCtrl("activity_9001643_Ctrl")
local activity_9001643_Read = include("activity_9001643_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001643_mainPanel = class("Activity_9001643_mainPanel", baseFguiPanel)
function Activity_9001643_mainPanel:ctor(...)
	Activity_9001643_mainPanel.super.ctor(self, ...)
	print("Activity_9001643_mainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.EID_CELEBRATION_ACTIVITY
	self.classType = SoraDGetActivityClassType(self.activityID)
end
function Activity_9001643_mainPanel:onInit()
	print("=======Activity_9001643_mainPanel:onInit")
	self.chapterList, _ENV, self.tag = print, print, 1
	self.fields.Com_title:setTitleWidthHeight(480, 40)
	self.fields.Com_title:initData(i18n("activity_name_9001643"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onChapterRenderer))
end
function Activity_9001643_mainPanel:onChapterRenderer(index, obj)
	obj:initData(self.chapterList[index + 1])
end
function Activity_9001643_mainPanel:onShow()
	print("=======Activity_9001643_mainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.tag = self.param and self.param.tag or 1
	self.chapterList = activity_9001643_Read.getChapterCfg()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("eidal_celebration_text31")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("eidal_celebration_text12")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(nil)
end
function Activity_9001643_mainPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:updateView()
end
function Activity_9001643_mainPanel:updateView(target, data)
	if self.tag == 1 then
		self.fields.List:setNumItems(#self.chapterList)
		self.fields.List:setScrollEnable(#self.chapterList > 3)
	elseif self.tag == 2 then
		self.fields.Com_help:initData()
	end
	local ret, num = activity_9001643_Ctrl:getReceiveStatusAndNum()
	self.fields.Com_tab:setBtnRedDot(1, 0 < num, num)
	local helpCount = activity_9001643_Ctrl:getHelpCount()
	self.fields.Com_tab:setBtnRedDot(2, 0 < helpCount, helpCount)
end
function Activity_9001643_mainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("eidal_celebration_text30")
	uiManager:show("RuleView", nil)
end
return Activity_9001643_mainPanel
