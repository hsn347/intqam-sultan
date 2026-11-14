local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
local buildLogic = include("buildLogic")
local epicWarGate = class("epicWarGate", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarGate")
	end
	return target
end)
function epicWarGate:ctor()
	self.Button_click = SoraDGetChildByName(self, "Button_click")
	self.Button_click:setSwallowTouches(false)
	self.Button_click:addTouchEventListener(handler(self, self.onBtnCallBack))
	self.Node_unlock = SoraDGetChildByName(self, "Node_unlock")
	self.frame_sszz_tower = SoraDGetChildByName(self.Node_unlock, "frame_sszz_tower")
	self.head = SoraDGetChildByName(self, "frame_main_receive")
	self.head:setVisible(false)
	self.Avatar_hero = SoraDGetChildByName(self, "Avatar_hero")
	self.Avatar_hero:setVisible(false)
	self.Button_award = SoraDGetChildByName(self, "Button_award")
	self.Button_award:setSwallowTouches(false)
	self.Button_award:addTouchEventListener(handler(self, self.onAwardCallBack))
	self.Button_award:setVisible(false)
	self.Node_etBox = SoraDGetChildByName(self.Button_award, "Node_etBox")
	SoraDCreatAnimation("animationEpicWarGQBX"):addTo(self.Node_etBox)
	self.Node_etBox:setVisible(false)
	self.Text_gate = SoraDGetChildByName(self, "Text_gate")
	self.frame_fighting = SoraDGetChildByName(self, "frame_fighting")
	self.Node_etFighting = SoraDGetChildByName(self, "Node_etFighting")
	SoraDCreatAnimation("animationEpicWarFighting"):addTo(self.Node_etFighting)
	self.frame_fighting:setVisible(false)
	self.Node_etXZ = SoraDGetChildByName(self, "Node_etXZ")
	SoraDCreatAnimation("animationEpicWarXZTX"):addTo(self.Node_etXZ)
	self.Node_etXZ:setVisible(false)
end
function epicWarGate:setDark(chapter)
	local stage = self:getStage()
	local ret = true
	if chapter then
		ret = math.floor((stage - 1500000) / 100) == chapter
	end
	self.Button_click:setTouchEnabled(ret)
	self.head:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	self.frame_sszz_tower:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	self.Text_gate:setColor(ret and cc.c3b(196, 207, 182) or cc.c3b(164, 171, 155))
end
function epicWarGate:setEffectVisible(ret)
	if epicWarCtrl:getCurGateID() == self.gateID then
		self.frame_sszz_tower:setSpriteFrame("frame_sszz_flag_01.png")
	else
		self.frame_sszz_tower:setSpriteFrame(self.gateInfo.isPass and "frame_sszz_flag_01.png" or "frame_sszz_flag_05.png")
	end
end
function epicWarGate:initData(gateID)
	self.gateID = gateID
	self.gateInfo = epicWarCtrl:getStageEntityInfo(self.gateID)
	local isBox, stageIcon = epicWarltCtrl.getGateHeadInfo(self.gateID)
	self.Node_etBox:setVisible(false)
	if stageIcon then
		self.head:setVisible(true)
		if isBox then
			local isGot = epicWarCtrl:isGateBoxGot(self.gateID)
			print("self.gateID,isGot ======== ", self.gateID, isGot)
			self.Button_award:setVisible(not isGot)
			self.Avatar_hero:setVisible(isGot)
			local isPass = epicWarCtrl:isGatePassed(self.gateID)
			if isPass then
				self.Button_award:stopAllActions()
				self.Button_award:setRotation(0)
				_UPVALUE8_ = self.Button_award
				self.Button_award[1] = cca.rotateTo(0.2, -10)
				self.Button_award[2] = cca.rotateTo(0.2, 0)
				self.Button_award[3] = cca.rotateTo(0.2, 10)
				self.Button_award[4] = cca.rotateTo(0.2, 0)
				self.Button_award[5] = cca.rotateTo(0.1, -5)
				self.Button_award[6] = cca.rotateTo(0.1, 0)
				self.Button_award[7] = cca.rotateTo(0.1, 5)
				self.Button_award[8] = cca.rotateTo(0.1, 0)
				self.Button_award[9] = cca.delay(2)
				self.Button_award[10] = cca.delay(2)
				local seq = cca.seq(self.Button_award)
				self.Button_award:runAction(cc.RepeatForever:create(seq))
				self.Node_etBox:setVisible(true)
			end
		else
			self.Button_award:setVisible(false)
			self.Avatar_hero:setVisible(true)
		end
		self.Avatar_hero:setSpriteFrame(stageIcon[2])
	else
		self.head:setVisible(false)
	end
	self.Text_gate:setString(string.format("%d-%d", self.gateInfo.chapter, self.gateInfo.index))
	if epicWarCtrl:getCurGateID() == self.gateID then
		self.frame_fighting:setVisible(true)
		self.Node_etXZ:setVisible(true)
		self.Text_gate:setVisible(false)
		self.frame_sszz_tower:setSpriteFrame("frame_sszz_flag_01.png")
	else
		self.frame_fighting:setVisible(false)
		self.Node_etXZ:setVisible(false)
		self.Text_gate:setVisible(true)
		self.frame_sszz_tower:setSpriteFrame(self.gateInfo.isPass and "frame_sszz_flag_01.png" or "frame_sszz_flag_05.png")
	end
end
function epicWarGate:getStage()
	return self.gateID
end
function epicWarGate:getBoundingBox()
	local boundingBox = self.Button_click:getBoundingBox()
	return cc.rect(self:getPositionX() - 0.25 * boundingBox.width, self:getPositionY() - 0.25 * boundingBox.height, boundingBox.width, boundingBox.height)
end
function epicWarGate:onAwardCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("epicWarGateAwardView")
		panel:initData(self.gateID)
		panel:show()
	end
end
function epicWarGate:onBtnCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.gateInfo.isCanChallenge then
			_ENV = nil
			;(nil).msg = "MESSAGE_UI_EPICBATTLE_GATE_SELECT"
			;(nil).gateData = self.gateInfo
			;(nil).isNewGate = true
			SoraDSendMessage(nil)
		else
			local lastStageID, condition = epicWarltCtrl.getStageCondition(self.gateInfo.stage)
			buildLogic = nil
			;(nil)[1] = "condKey"
			;(nil)[2] = "condValue"
			condition = serviceFunctions.tableFormat(condition, nil)
			local isLegal, condValue, condKey = serviceFunctions.checkCondtion(condition)
			if not isLegal then
				local ret, wlv, progress = buildLogic.isBuildWarLv(condValue)
				if ret then
					_ENV = nil
					;(nil).level = wlv
					SoraDShowMsgTip(i18n("common_text_3962", nil))
				else
					_ENV = i18n("common_text_3962", nil)
					i18n("common_text_3962", nil).level = condValue
					SoraDShowMsgTip(i18n("epicbattle_text_02", i18n("common_text_3962", nil)))
				end
			else
				local preStageName = ""
				if lastStageID ~= 0 then
					preStageName = epicWarltCtrl.getStageName(lastStageID)
					local chapterIndex, gateIndex = epicWarltCtrl.getPreStageInfo(self.gateInfo.stage)
					local nameStr = string.format("%d-%d%s", chapterIndex, gateIndex, preStageName)
					_ENV = preStageName
					preStageName.chapter = nameStr
					SoraDShowMsgTip(i18n("epicbattle_text_07", preStageName))
				end
			end
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return epicWarGate
