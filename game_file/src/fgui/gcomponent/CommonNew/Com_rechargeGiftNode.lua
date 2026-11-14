local rechargePresentUtil = include("rechargePresentUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_rechargeGiftNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_rechargeGiftNode", Com_rechargeGiftNode)
fgui.register_extension("ui://CommonNew/Com_rechargeGiftNode_SVIP", Com_rechargeGiftNode)
function Com_rechargeGiftNode:onInit()
end
function Com_rechargeGiftNode:onShow()
end
function Com_rechargeGiftNode:initData(idList, isSpShow)
	self.isSpShow = isSpShow or false
	local showGift = rechargePresentUtil.checkCanOpenViewByRecharge(idList) and rechargePresentUtil.checkCanOpenViewGift()
	self.fields.Com_rechargeGift:initData(idList)
	local showPresent = rechargePresentUtil.checkActivityByRecharge(idList)
	local showNewyear = false
	local showRechargePresent = showPresent or showNewyear
	if showRechargePresent then
		self.fields.Com_rechargePresent:setActivityID(rechargePresentUtil.activityID)
	end
	local c_index = 0
	if showGift and not showRechargePresent then
		c_index = 1
	elseif not showGift and showRechargePresent then
		c_index = 2
	end
	self.controllers.c_count:setSelectedIndex(c_index)
	self.fields.Com_rechargeGift:setVisible(showGift)
	self.fields.Com_rechargePresent:setVisible(showRechargePresent)
	if self.isSpShow then
		if c_index == 0 then
			self.fields.Com_rechargeGift:setPositionY(-3)
			self.fields.Com_rechargePresent:setPositionY(-58)
		elseif c_index == 1 then
			self.fields.Com_rechargeGift:setPositionY(-58)
		elseif c_index == 2 then
			self.fields.Com_rechargePresent:setPositionY(-58)
		end
	end
end
function Com_rechargeGiftNode:fixNodePos()
	self:fixChildrenPos()
	self.fields.Com_rechargePresent:fixChildrenPos()
	self.fields.Com_rechargeGift:fixChildrenPos()
end
function Com_rechargeGiftNode:fixNodePosEX()
	self:fixChildrenPos()
	self.fields.Com_rechargePresent:fixChildrenPos(false, true)
	self.fields.Com_rechargeGift:fixChildrenPos(false, true)
	self.fields.Com_rechargePresent:fixBgEX()
	self.fields.Com_rechargeGift:fixBgEX()
end
function Com_rechargeGiftNode:fixNodePos()
	self:fixChildrenPos()
	self.fields.Com_rechargePresent:fixChildrenPos()
	self.fields.Com_rechargeGift:fixChildrenPos()
end
return Com_rechargeGiftNode
