local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsUtil = include("royalSummonsUtil")
local dashToSkyTaskView = class("dashToSkyTaskView", function(ccsFileName)
	target = include("royalSummonsMainTaskView").new(ccsFileName)
	return target
end)
function dashToSkyTaskView:ctor()
	self.scroll:setSingleCCS("dashToSkyTaskSingle")
end
function dashToSkyTaskView:showEffect()
	local cssFileName = "dashToSkyTaskView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, true)
	self:runAction(action)
	self.cloud_1 = SoraDGetChildByName(self, "Node_Yun_1")
	self.cloud_2 = SoraDGetChildByName(self, "Node_Yun_2")
	local formPoX = SoraDFIsRA() and -800 or 800
	self.cloud_1:setPositionX(-formPoX)
	self.cloud_2:setPositionX(0)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.moveTo(55.5, formPoX, 20)
	;(nil)[2] = cca.callFunc(function()
		self.cloud_1:setPositionX(-formPoX)
	end)
	;(nil)[3] = cca.moveTo(27.75, 0, 20)
	;(nil)[4] = cca.moveTo(27.75, 0, 20)
	;(nil)[5] = cca.moveTo(27.75, 0, 20)
	;(nil)[6] = cca.moveTo(27.75, 0, 20)
	self.cloud_1:runAction(cca.repeatForever(cca.seq(nil)))
	_UPVALUE2_ = cca.repeatForever(cca.seq(nil))
	cca.repeatForever(cca.seq(nil))[1] = cca.moveTo(27.75, formPoX, 20)
	cca.repeatForever(cca.seq(nil))[2] = cca.callFunc(function()
		self.cloud_2:setPositionX(-formPoX)
	end)
	cca.repeatForever(cca.seq(nil))[3] = cca.moveTo(27.75, 0, 20)
	cca.repeatForever(cca.seq(nil))[4] = cca.moveTo(27.75, 0, 20)
	cca.repeatForever(cca.seq(nil))[5] = cca.moveTo(27.75, 0, 20)
	cca.repeatForever(cca.seq(nil))[6] = cca.moveTo(27.75, 0, 20)
	self.cloud_2:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
end
function dashToSkyTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_TASK", handler(self, self.updateTaskData))
end
function dashToSkyTaskView:updateProgressBar()
	self.txtLevel:setString(royalSummonsCtrl:getCurLevel())
	local cur, max = royalSummonsCtrl:getCurLevelExp()
	self.nodeProBarPreview:stopAllActions()
	self.nodeProBarPreview:setInitState(false)
	royalSummonsCtrl = false
	;(false).maxValue = max
	;(false).curValue = cur
	self.nodeProBarPreview:setProgressDate(false)
	self.nodeProBarPreview:setInitState(true)
	self.topLeftImage = SoraDGetChildByName(self, "Top_ImageLeft")
end
function dashToSkyTaskView:initScrollList()
	self.scroll:jumpToTop()
	local view = self:getParent():getParent()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = view
	;(nil).mainView = self
	self.scroll:updateScrollView(cc.size(630, 160), self.taskList, 1, nil)
end
function dashToSkyTaskView:showTaskInfo(show)
	self.nodeTaskInfo:setVisible(show)
	if show then
		self.txtActivieyTime:setPositionY(20)
		local activityDay = royalSummonsCtrl:getActivityDay()
		local curExp, maxExp = royalSummonsUtil:getTaskExp(self.taskList)
		royalSummonsCtrl = nil
		;(nil).num = activityDay
		local strDay = i18n("summoned_text_43", nil)
		royalSummonsCtrl = nil
		;(nil).cur = string.formatnumberthousands(curExp)
		royalSummonsCtrl, royalSummonsCtrl, (nil).max = maxExp, string.formatnumberthousands(maxExp), string.formatnumberthousands(maxExp)
		royalSummonsCtrl, string.formatnumberthousands(maxExp).cur, maxExp.color = maxExp, maxExp, "#ffffff"
		royalSummonsCtrl, string.formatnumberthousands(maxExp).max, maxExp.color = maxExp, maxExp, "#ffffff"
		string.formatnumberthousands(maxExp).__default, maxExp.color = maxExp, "#c5dafc"
		local strExp = i18n_html("summoned_text_44", nil, (string.formatnumberthousands(maxExp)))
		self.txtTaskDay:setString(strDay)
		self.txtTaskExp = SoraDChangeTextToHtml(self.txtTaskExp)
		self.txtTaskExp:setString(strExp)
		SoraDToCenter(self.nodeTaskInfo, 10, SoraDFIsRA())
	else
		self.txtActivieyTime:setPositionY(0)
	end
end
function dashToSkyTaskView:scrollMove()
	self.topLeftImage:setPositionY(-90 + (1136 - self:getPanelOffsetHeight() + 300) / 100 * self.scroll:getScrolledPercentVertical())
end
return dashToSkyTaskView
