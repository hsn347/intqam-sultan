local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local compoundSuccessfulView = class("compoundSuccessfulView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end, "compoundSuccessfulView"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end).light = "frame_zzsds_02.png"
_ENV, ("compoundSuccessfulView")[851601], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end).dark = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end, "frame_zzsds_03.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end).light = "frame_zzsds_04.png"
_ENV, ("compoundSuccessfulView")[851701], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end).dark = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end, "frame_zzsds_05.png"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end).light = "frame_zzsds_06.png"
;("compoundSuccessfulView")[851801], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end).dark = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("compoundSuccessfulView")
	end
	return target
end, "frame_zzsds_07.png"
local decorationName = "compoundSuccessfulView"
function compoundSuccessfulView:ctor()
	self:initControls()
end
function compoundSuccessfulView:initControls()
	self.txtTitle = SoraDGetChildByName(self, "text_title")
	self.imageTree = SoraDGetChildByName(self, "image_tree")
	self.txtDes = SoraDGetChildByName(self, "text_describe")
	self.txtName = SoraDGetChildByName(self, "text_remain")
	self.panel = SoraDGetChildByName(self, "BG_zzsds_18_1")
	self.imageTreeDecoration = SoraDGetChildByName(self, "frame_zzsds_02_1")
	self.btnShare = SoraDGetChildByName(self, "btn_share")
	self.btnShare:addTouchEventListener(handler(self, self.shareClickCallBack))
	self.txtTitle:setString(i18n("christmas_tree_text_13"))
	SoraDSetTextWidthHeight(self.txtTitle, cc.size(450, 60))
	self.txtDes:setString(i18n("christmas_tree_text_14"))
	self.btnShare:setTitleText(i18n("common_text_533"))
	self.panel:setPositionY(display.height / 2)
	self.imageTree:setLocalZOrder(2)
	self.imageTree:setPositionY(415)
	self.effectbehind = SoraDCreatAnimation("synthesisBehind")
	self.effectbehind:setPosition(cc.p(220, 300))
	self.panel:addChild(self.effectbehind, self.imageTree:getLocalZOrder() - 1)
	self.effectfront = SoraDCreatAnimation("synthesisfront")
	self.effectfront:setPosition(cc.p(220, 300))
	self.panel:addChild(self.effectfront, self.imageTree:getLocalZOrder() + 1)
end
function compoundSuccessfulView:initData(treeId)
	if treeId == 851601 or treeId == 851501 then
		self.effectfront:setVisible(false)
		self.effectbehind:setVisible(false)
	elseif treeId == 851701 then
		self.effectfront:setVisible(true)
		self.effectbehind:setVisible(false)
	elseif treeId == 851801 then
		self.effectfront:setVisible(true)
		self.effectbehind:setVisible(true)
	end
	self.txtName:setString(itemDesRead.getName(treeId))
	self.imageTreeDecoration:stopAllActions()
	self.imageTreeDecoration:setVisible(treeId ~= 851501)
	if 851501 < treeId then
		self.imageTreeDecoration:setSpriteFrame(decorationName[treeId].light)
	end
	self.btnShare:setVisible(treeId == 851801)
end
function compoundSuccessfulView:shareClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("christmasTreeSharePopView"):show()
		self:removeFromParent()
	end
end
function compoundSuccessfulView:begin2Action(...)
	self.panel:setScale(0.1)
	self.panel:setOpacity(0)
	self.imageTree:setOpacity(0)
	self.enableTouchCloseSelf = true
	_UPVALUE1_ = nil
	_UPVALUE1_ = nil
	_UPVALUE2_ = nil
	;(nil)[1] = cca.scaleTo(0.3, 1.2)
	;(nil)[2] = cca.scaleTo(0.3, 1.0)
	;(nil)[3] = cca.callFunc(function()
		self.imageTree:runAction(cca.fadeIn(1.0))
	end)
	;(nil)[4] = cca.callFunc(function()
		self.imageTree:runAction(cca.fadeIn(1.0))
	end)
	;(nil)[1] = cca.seq(nil)
	;(nil)[2] = cca.fadeIn(1.0)
	;(nil)[3] = cca.fadeIn(1.0)
	;(nil)[4] = cca.fadeIn(1.0)
	;(nil)[5] = cca.fadeIn(1.0)
	;(nil)[6] = cca.fadeIn(1.0)
	;(nil)[1] = cca.spawn(nil)
	;(nil)[2] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	;(nil)[3] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	;(nil)[4] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	;(nil)[5] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	;(nil)[6] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	;(nil)[7] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	;(nil)[8] = cca.callFunc(function()
		self.enableTouchCloseSelf = false
	end)
	self.panel:runAction(cca.seq(nil))
end
return compoundSuccessfulView
