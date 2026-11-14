local gametop = gModuleMgr.getObject("gametop")
local annihilationCtrl = gametop.playertop_:getModule("annihilationCtrl")
local annihilationRead = include("annihilationRead")
local totalSweepAwardBox = class("totalSweepAwardBox", function(target)
	if target == nil then
		return SoraDCreateBasePanel("totalSweepAwardBox")
	end
	return target
end)
function totalSweepAwardBox:ctor()
	_UPVALUE4_ = nil
	self.boxImgs, (nil)[1] = nil, "icon_KingGroupbuy_lv1_small.png"
	self.boxImgs, (nil)[2] = nil, "icon_KingGroupbuy_lv2_small.png"
	self.boxImgs, (nil)[3] = nil, "icon_KingGroupbuy_lv3_small.png"
	self.boxImgs, (nil)[4] = nil, "icon_KingGroupbuy_lv4_small.png"
	self.index = 1
	self.Sprite_box = SoraDGetChildByName(self, "Sprite_box")
	self.Text_price = SoraDGetChildByName(self, "Text_price")
	self.Button_price = SoraDGetChildByName(self, "Button_price")
	self.Button_price:addTouchEventListener(handler(self, self.btnBoxClickCallBack))
end
function totalSweepAwardBox:initData(data)
	self.data = data
	self.status = annihilationCtrl:getBoxStatus(self.data.index)
	if self.status == gBtnTargetStatusDef.GET then
		self:setBoxReceive()
	elseif self.status == gBtnTargetStatusDef.GOT then
		self:setBoxReceived()
	else
		self:setBoxNormal()
	end
	self.Text_price:setString(string.formatnumberthousands(self.data.num))
end
function totalSweepAwardBox:setIndex(index)
	self.index = index
	self.Sprite_box:setSpriteFrame(self.boxImgs[self.index])
end
function totalSweepAwardBox:setBoxNormal()
	local eNode = self:getChildByName("effect_node")
	if eNode then
		eNode:setVisible(false)
	end
	self.Sprite_box:setColor(cc.c3b(255, 255, 255))
end
function totalSweepAwardBox:setBoxReceive()
	local eNode = self:getChildByName("effect_node")
	if not eNode then
		_ENV, _ENV = "effect_node", self
		;("effect_node").png = "dh_xsyd_01.png"
		;("effect_node").scale = 2.75
		;("effect_node").opacity = 178.5
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeTo(0.55, 0.2)
		;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
		_ENV, self[1], ("effect_node").seq = "effect_node", "effect_node", cca.seq(nil)
		;("effect_node").png = "dh_xsyd_07.png"
		_ENV, self[2], ("effect_node").scale = "effect_node", "effect_node", 2
		;("effect_node").png = "dh_xsyd_02.png"
		;("effect_node").scale = 2.4
		_ENV = nil
		;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
		self[3], ("effect_node").seq = "effect_node", cca.seq(nil)
		local actionConfig = self
		local roundNode = display.newNode()
		roundNode:setScale(0.3)
		roundNode:setName("effect_node")
		roundNode:addTo(self, 9)
		for k, v in ipairs(actionConfig) do
			if v.png then
				local sprite = display.newSprite("#" .. v.png)
				if v.scale then
					sprite:setScale(v.scale)
				end
				if v.opacity then
					sprite:setOpacity(v.opacity)
				end
				if v.rotation then
					sprite:setRotation(v.rotation)
				end
				if v.seq then
					sprite:runAction(cc.RepeatForever:create(v.seq))
				end
				sprite:addTo(roundNode, k)
			end
		end
	else
		eNode:setVisible(true)
	end
	self.Sprite_box:setColor(cc.c3b(255, 255, 255))
end
function totalSweepAwardBox:setBoxReceived()
	local eNode = self:getChildByName("effect_node")
	if eNode then
		eNode:setVisible(false)
	end
	self.Sprite_box:setColor(cc.c3b(125, 125, 125))
end
function totalSweepAwardBox:btnBoxClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("totalSweepBoxPop")
		panel:initData(self.data, self.status)
		panel:show()
	end
end
return totalSweepAwardBox
