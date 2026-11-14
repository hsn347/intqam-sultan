local baseComponent = require("fgui.base.baseComponent")
local Com_FP_ProsHeart = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_ProsHeart", Com_FP_ProsHeart)
local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
function Com_FP_ProsHeart:onInit()
	self.fields.btn_intimacy:addClickEventListener(handler(self, self.intimacyClick))
	local clip = cc.ClippingNode:create()
	local stencil = display.newSprite("SinglePicture/G_ygg_axd_mask.png")
	stencil:setScale(0.98)
	clip:setStencil(stencil)
	clip:setInverted(false)
	clip:setAlphaThreshold(0.05)
	clip:setAnchorPoint(cc.p(0.5, 0.5))
	clip:setPosition(cc.p(-2, 5))
	local sp = display.newSprite("#aixin_ygg_max_01.png")
	local frames = display.newFrames("G_ygg_aixin_%.2d.png", 1, 30)
	local animation = display.newAnimation(frames, 1.5 / #frames)
	sp:playAnimationForever(animation)
	sp:setName("lineadd")
	sp:addTo(clip)
	sp:setPosition(cc.p(126, 128))
	clip:setScale(0.95)
	self.line = sp
	fguiHelper.get_fields(self.fields.heart_line).loader3d:setContent(clip)
end
function Com_FP_ProsHeart:runLineAction(actionSeq)
	self.line:setOpacity(0)
	self.line:runAction(actionSeq)
end
function Com_FP_ProsHeart:onShow()
end
function Com_FP_ProsHeart:updateValue(per, isCanClick, isCanUp)
	self.isCanUp = isCanUp
	self.isCanClick = isCanClick
	local heartAni = fguiHelper.get_fields(self.fields.progress).heart
	heartAni:setAllFrameName("aixin_ygg_max%02d.png", 1)
	heartAni:setPlaySettings(0, -1, -1)
	self.fields.progress:setSize(cc.size(160, 15 + 120 * per / 100))
	self.line:setPositionY(128 * per / 100 - 70 + 128)
	self.fields.btn_intimacy:setTouchEnabled(isCanClick)
	self.fields.max:setVisible(isCanUp)
	if isCanUp then
		self.fields.max:setAllFrameName("G_ygg_aixin_max%02d.png", 1)
		self.fields.max:setPlaySettings(0, -1, -1)
	end
end
function Com_FP_ProsHeart:intimacyClick(sender, params)
	if not self.isCanClick then
		return
	end
	SoraDPlaySound()
	if not self.isCanUp then
		uiManager:show("ForeignPIntimacy")
	else
		exoticPavilionCtrl:reqEPUpgradeIntimacyLv()
	end
end
function Com_FP_ProsHeart:addHeartShow(callback, sender)
	SoraDPlaySound("innerbuildsound", 107)
	local flyAdd = fgui.UIPackage:createObjectFromURL("ui://ForeignPavilion/Com_FP_AddIntimacy")
	self:addChild(flyAdd)
	local worldPos = sender:getParent():convertToWorldSpace(sender:getPosition())
	local curPos = flyAdd:convertToNodeSpace(worldPos)
	local fields = fguiHelper.get_fields(flyAdd)
	fields.shine:setVisible(false)
	fields.fly:setAllFrameName("G_ygg_fly1_%02d.png", 1)
	fields.fly:setPlaySettings(0, -1, 1)
	local angle = math.radian2angle(cc.pGetAngle(fields.fly:getPosition(), curPos)) - 30
	fields.heart:setPosition(curPos)
	fields.fly:setRotation(angle)
	fields.heart:setVisible(false)
	fields.heart:runAction(ffa.seq(ffa.delay(0.06666666666666667), ffa.callFunc(function()
		fields.heart:setVisible(true)
	end), ffa.moveTo(0.3333333333333333, cc.p(11, 23)), ffa.delay(0.03333333333333333), ffa.callFunc(function()
		fields.heart:setVisible(false)
		if callback then
			callback()
		end
	end), ffa.delay(1.5), ffa.callFunc(function()
		flyAdd:removeFromParent()
	end)))
	fields.shine:runAction(ffa.seq(ffa.delay(0.3), ffa.callFunc(function()
		fields.shine:setVisible(true)
		fields.shine:setAllFrameName("G_ygg_fly_%02d.png", 1)
		fields.shine:setPlaySettings(0, -1, 1)
	end)))
end
return Com_FP_ProsHeart
