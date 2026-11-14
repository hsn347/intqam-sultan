local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerNowFloorAward = class("babelTowerNowFloorAward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("babelTowerNowFloorAward")
end)
function babelTowerNowFloorAward:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.textMonterName = SoraDGetChildByName(self.node, "Text_monterName")
	self.textMonterTalk = SoraDGetChildByName(self.node, "Text_monterTalk")
	self.textMonterTalk:setString(i18n("Promise_Summit_text_35"))
	self.textDropTip = SoraDGetChildByName(self.node, "Text_dropTip")
	self.textDropTip:setString(i18n("Promise_Summit_text_12"))
	self.nodeItem = SoraDGetChildByName(self.node, "Node_Item")
	self.btnGo = SoraDGetChildByName(self.node, "Button_Go")
	self.btnGo:setTitleText(i18n("Promise_Summit_text_44"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self:addButterfly()
end
function babelTowerNowFloorAward:initData(floor)
	self.nowFloor = math.min(babelTowerRead:getTowerNum(), floor)
	_ENV = nil
	;(nil).num = self.nowFloor
	self.textMonterName:setString(i18n("Promise_Summit_text_01", nil))
	self.reward = babelTowerRead:getBaseReward(self.nowFloor)
	for i = 1, #self.reward, 3 do
		local single = include("commonItemAward").new()
		single:addTo(self.nodeItem)
		single:setScale(0.7)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:initData(self.reward[i], self.reward[i + 1] * babelTowerCtrl:getRewardMultiple())
	end
	SoraDautoSortPos(self.nodeItem, 4, 1, cc.size(90, 90), SoraDFIsRA())
end
function babelTowerNowFloorAward:addButterfly()
	local spBufffly = display.newSprite("dh_xuyuanshuhd_00.png")
	spBufffly:addTo(self.node)
	spBufffly:setPosition(200, 240)
	local frames = display.newFrames("dh_xuyuanshuhd_%.2d.png", 0, 21)
	local animation = display.newAnimation(frames, 2.45 / #frames)
	spBufffly:playAnimationForever(animation)
end
function babelTowerNowFloorAward:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_BABEL_TOWER_REFRESH"
		;(nil).subMsg = "showFinger"
		SoraDSendMessage(nil)
		self:removeFromParent()
	end
end
return babelTowerNowFloorAward
