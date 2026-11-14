local newTrialResultView = class("newTrialResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newTrialResultView")
	end
	return target
end)
function newTrialResultView:ctor()
	self.enableTouchCloseSelf = true
	self.isCantCloseByReturn = true
	self:initControls()
end
function newTrialResultView:initControls()
	self.panelTotal = SoraDGetChildByName(self, "panel_total")
	self.panelTotal:setPositionY(display.height / 2)
	_UPVALUE1_ = display.height / 2
	;(display.height / 2)[1] = "node_title"
	self.nodeTitle = SoraDGetChildByFullPath(self.panelTotal, display.height / 2)
	_UPVALUE1_ = display.height / 2
	;(display.height / 2)[1] = "node_explose"
	self.nodeSuccessAni = SoraDGetChildByFullPath(self.nodeTitle, display.height / 2)
	self.nodeSuccessAni:setVisible(false)
	_UPVALUE1_ = false
	;(false)[1] = "panel_sucess"
	self.panel_sucess = SoraDGetChildByFullPath(self.panelTotal, false)
	_UPVALUE1_ = false
	;(false)[1] = "Text_lordTitle"
	self.Text_lordTitle = SoraDGetChildByFullPath(self.panel_sucess, false)
	_UPVALUE1_ = false
	;(false)[1] = "Text_failTitle"
	self.Text_failTitle = SoraDGetChildByFullPath(self.panel_sucess, false)
	self.image_mvp = SoraDGetChildByName(self, "image_mvp")
	self.image_mvp:setVisible(false)
	_UPVALUE1_ = false
	;(false)[1] = "Text_title_time"
	self.Text_title_time = SoraDGetChildByFullPath(self.panel_sucess, false)
	_UPVALUE1_ = false
	;(false)[1] = "Text_time"
	self.Text_time = SoraDGetChildByFullPath(self.panel_sucess, false)
	for i = 1, 4 do
		self["Text_name_" .. i] = SoraDGetChildByName(self, "Text_name_" .. i)
		local kill = SoraDGetChildByName(self, "Text_kill_" .. i)
		SoraDSetTextWidthHeight(kill, cc.size(165, 40))
		self["Text_kill_" .. i] = kill
	end
	self.btn_confirm = SoraDGetChildByName(self, "btn_confirm")
	self.btn_confirm:setTitleText(i18n("common_text_054"))
	self.btn_confirm:addTouchEventListener(function(button, eventType)
		if eventType ~= ccui.TouchEventType.ended then
			return
		end
		SoraDPlaySound()
		self:removeFromParent()
		_ENV = self
		self.msg = "MESSAGE_UI_NEWTRIALMAINUI"
		SoraDSendMessage(self)
		if not worldMapDefine.isInNewTrial() then
			_G.SoraDQuickLogin()
		end
	end)
end
function newTrialResultView:onExitPanel()
	_G.SoraDGetCtrl("devilValleyCtrl"):resetNewTrialEnd()
end
function newTrialResultView:playFailAni()
	local node
	node = SoraDCreatAnimation("animationKingWarLose", nil, false)
	if node then
		node:setLocalZOrder(-1)
		self.nodeTitle:addChild(node)
	end
	SoraDPlaySound("innerbuildsound", 106)
end
function newTrialResultView:playSuccessAni()
	local node
	node = SoraDCreatAnimation("animationCommonWarWin", nil, false)
	if node then
		node:setLocalZOrder(-1)
		self.nodeTitle:addChild(node)
	end
	SoraDPlaySound("innerbuildsound", 106)
	self.nodeSuccessAni:setVisible(true)
	for k, v in pairs(self.nodeSuccessAni:getChildren()) do
		v:resetSystem()
	end
end
function newTrialResultView:initData(data)
	if data.rtype then
		if data.rtype == 1 then
			self:playSuccessAni()
			local challengeLv = data.challengeLv or 1
			local newTrialRead = include("newTrialRead")
			local name = newTrialRead.getName(challengeLv)
			_ENV = nil
			;(nil).trouble = name
			self.Text_lordTitle:setString(i18n("devilvalley_text_29", nil))
			if data.costTime then
				self.Text_title_time:setString(i18n("devilvalley_text_35"))
				self.Text_time:setString(SoraDConvertSecondToString(data.costTime))
				_UPVALUE2_ = SoraDConvertSecondToString(data.costTime)
				SoraDConvertSecondToString(data.costTime)[1] = self.Text_title_time
				SoraDConvertSecondToString(data.costTime)[2] = self.Text_time
				_UPVALUE1_ = self.Text_time
				self.Text_time[1] = 10
				_G.SoraDAlignNodeArrayOnCenterX(280, SoraDConvertSecondToString(data.costTime))
			end
		else
			self:playFailAni()
			self.Text_failTitle:setString(i18n("devilvalley_text_31"))
			self.Text_failTitle:setVisible(true)
		end
	end
	if data.players and next(data.players) then
		local killMax = 0
		for i = 1, 4 do
			local player = data.players[i]
			if player then
				self["Text_name_" .. i]:setString(player.name)
				local strKill = SoraDConvertNumberWithUnit(player.kill)
				self["Text_kill_" .. i]:setString(i18n("devilvalley_text_30") .. strKill)
			end
		end
		local mvp = data.mvp
		if mvp then
			local widget = self["Text_kill_" .. mvp]
			if mvp and widget then
				self.image_mvp:setVisible(true)
				self.image_mvp:setPositionY(widget:getPositionY())
			end
		end
	else
		self.Text_failTitle:setPositionY(self.Text_failTitle:getPositionY() - 100)
	end
end
function newTrialResultView:onEnterPanel()
	SoraDGetCtrl("queueCtrl"):removeQueue(tostring(gQueueTypeDef.hostpital_queue))
end
return newTrialResultView
