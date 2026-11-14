local gametop = gModuleMgr.getObject("gametop")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001061_MainPanel = class("Activity_9001061_MainPanel", baseFguiPanel)
function Activity_9001061_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001061_MainPanel:ctor", self.viewName)
end
function Activity_9001061_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001061_MainPanel:onInit()
	print("=======Activity_9001061_MainPanel:onInit")
	self.isAddToPopManager = true
	self.fields.Com_title:initData(i18n("common_text_605"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	_ENV = i18n("common_text_605")
	_ENV, _ENV, i18n("common_text_605").defaultClick = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick).title = i18n("common_text_625")
	_ENV, handler(self, self.onClickClose)[1], handler(self, self.btnHelpClick).tag = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick).title = i18n("common_text_626")
	_ENV, handler(self, self.onClickClose)[2], handler(self, self.btnHelpClick).tag = handler(self, self.btnHelpClick)
	handler(self, self.btnHelpClick).title = i18n("common_text_627")
	i18n("common_text_605").tabsetArray, handler(self, self.onClickClose)[3], handler(self, self.btnHelpClick).tag = handler(self, self.onClickClose), handler(self, self.btnHelpClick)
	i18n("common_text_605").callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView((i18n("common_text_605")))
end
function Activity_9001061_MainPanel:onShow()
	print("=======Activity_9001061_MainPanel:onShow")
	self:setTime()
	self:getNewInfo()
	self:initStageData()
end
function Activity_9001061_MainPanel:initData()
	self:initStageData()
	self.fields.Node_Score:updateView()
end
function Activity_9001061_MainPanel:initStageData()
	local activityList = activityCtrl.activityList
	local curStage = activityCtrl.curStage
	for i = 1, 5 do
		local index = SoraDFPosX(i, 6)
		self.fields["StageNode_" .. i]:initData(index, activityList[index], curStage)
	end
end
function Activity_9001061_MainPanel:getNewInfo()
	SoraDShowLoading(self)
	activityCtrl:reqActivityInfo()
	activityCtrl:reqActivityMemberInfo()
end
function Activity_9001061_MainPanel:setTime()
	local queue = activityCtrl:queryQueue(activityCtrl.activityState)
	if queue then
		self.fields.Com_title:initSpecialActivityTime(queue.timerNode.timer:getRemainTime())
	end
end
function Activity_9001061_MainPanel:onTabClick(tag)
	self.controllers.c1:setSelectedIndex(tag == 1 and 0 or 1)
	if 1 < tag then
		self.fields.Node_Rank:setRankTag(tag - 1)
	end
end
function Activity_9001061_MainPanel:btnHelpClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_912"))
end
return Activity_9001061_MainPanel
