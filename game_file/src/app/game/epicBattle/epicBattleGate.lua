local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicBattleDef = include("epicBattleDef")
local buildLogic = include("buildLogic")
local epicBattleGate = class("epicBattleGate", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleGate")
	end
	return target
end)
function epicBattleGate:ctor()
	self.gateData, _ENV = nil, nil
	self.Button_click = SoraDGetChildByName(self, "Button_click")
	self.Button_click:setSwallowTouches(false)
	self.Button_click:addTouchEventListener(handler(self, self.onBtnCallBack))
	self.Node_lock = SoraDGetChildByName(self, "Node_lock")
	self.frame_towerlock = SoraDGetChildByName(self.Node_lock, "frame_towerlock")
	self.Node_unlock = SoraDGetChildByName(self, "Node_unlock")
	self.frame_sszz_tower = SoraDGetChildByName(self.Node_unlock, "frame_sszz_tower")
	self.Image_starBg = SoraDGetChildByName(self.Node_unlock, "Image_starBg")
	self.Node_star = SoraDGetChildByName(self.Node_unlock, "Node_star")
	self.Node_star:setVisible(false)
	self.head = SoraDGetChildByName(self, "frame_main_receive")
	self.head:setVisible(false)
	self.Avatar_hero = SoraDGetChildByName(self, "Avatar_hero")
	_ENV = self
	self.UILabelType = 2
	self.text = ""
	self.size = 20
	self.color = cc.c3b(255, 200, 100)
	self.dimensions = cc.size(100, 50)
	self.align = cc.TEXT_ALIGNMENT_CENTER
	self.Text_name = SoraDCreateLabel(self)
	self.Text_name:setAnchorPoint(cc.p(0.5, 0.5))
	self.Text_name:setPosition(cc.p(0, -100))
	self.Text_name:addTo(self, 99)
	self.Particle_1 = SoraDGetChildByName(self.Node_unlock, "Particle_1")
	self.Particle_1:setGroupAuto(true)
	self.Particle_1:setVisible(false)
end
function epicBattleGate:setDark(chapter)
	local stage = self:getStage()
	local ret = true
	if chapter then
		ret = math.floor((stage - 1500000) / 100) == chapter
	end
	self.Button_click:setTouchEnabled(ret)
	self.head:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	self.frame_sszz_tower:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	self.Image_starBg:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	self.Text_name:setColor(ret and cc.c3b(255, 200, 100) or cc.c3b(50, 50, 50))
	for i = 1, 3 do
		local star = SoraDGetChildByName(self.Node_star, "frame_star_" .. i)
		star:setColor(ret and cc.c3b(255, 255, 255) or cc.c3b(50, 50, 50))
	end
end
function epicBattleGate:setEffectVisible(ret)
	self.frame_sszz_tower:setSpriteFrame(ret and "frame_sszz_flag_03.png" or self.gateData.isBorder and "frame_sszz_flag_02.png" or "frame_sszz_flag_01.png")
	self.Particle_1:setVisible(ret)
end
function epicBattleGate:initData(data)
	self.gateData = data
	self.Node_lock:setVisible(not self.gateData.isCanChallenge)
	self.head:setVisible(self.gateData.isCanChallenge and self.gateData.isBorder)
	if self.gateData.isCanChallenge then
		self.frame_sszz_tower:setSpriteFrame(self.gateData.isBorder and "frame_sszz_flag_02.png" or "frame_sszz_flag_01.png")
		self.Avatar_hero:setSpriteFrame(self.gateData.picture)
	end
	self:setStar(self.gateData.curStar)
	self.Text_name:setString(string.format("%d-%d", self.gateData.chapter, self.gateData.index))
end
function epicBattleGate:getStage()
	return self.gateData.stage
end
function epicBattleGate:setStar(num)
	self.Node_star:setVisible(0 < num)
	for i = 1, 3 do
		local starBg = SoraDGetChildByName(self.Node_unlock, "frame_sszz_starblack_" .. i)
		local star = SoraDGetChildByName(self.Node_star, "frame_star_" .. i)
		star:setVisible(i <= num)
	end
end
function epicBattleGate:getBoundingBox()
	local boundingBox = self.Button_click:getBoundingBox()
	return cc.rect(self:getPositionX() - 0.25 * boundingBox.width, self:getPositionY() - 0.25 * boundingBox.height, boundingBox.width, boundingBox.height)
end
function epicBattleGate:onBtnCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.gateData.isCanChallenge then
			if self.gateData.stage == epicWarCtrl:getCurGateID() then
				local panel = SoraDCreatePanel("epicWarMapView")
				panel:show()
			else
				_ENV = panel.show
				panel.show.msg = "MESSAGE_UI_EPICBATTLE_GATE_SELECT"
				panel.show.gateData = self.gateData
				panel.show.isNewGate = true
				SoraDSendMessage(panel.show)
			end
		else
			local lastStageID, condition = epicWarltCtrl.getStageCondition(self.gateData.stage)
			epicWarltCtrl = nil
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
					_ENV = i18n("epicbattle_text_02", i18n("common_text_3962", nil))
					i18n("epicbattle_text_02", i18n("common_text_3962", nil)).chapter = preStageName
					SoraDShowMsgTip(i18n("epicbattle_text_07", i18n("epicbattle_text_02", i18n("common_text_3962", nil))))
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
return epicBattleGate
