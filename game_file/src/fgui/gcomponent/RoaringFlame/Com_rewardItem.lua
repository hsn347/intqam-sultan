local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_rewardItem", Com_rewardItem)
function Com_rewardItem:onInit()
	self.fields.lock:fixPos()
end
function Com_rewardItem:onShow()
end
function Com_rewardItem:initData(data, isAdd, lv, isAdv)
	self.fields.Com_item:initData(data.id, data.count)
	local curLv = roaringFlameWarCtrl:getDecreeLvExp()
	if isAdv then
		local advLv = roaringFlameWarCtrl:getDecreeAdvLv()
		local isClaimed = lv <= advLv
		self.controllers.c1:setSelectedIndex(not (not isClaimed or isAdd) and 1 or 0)
		local isActive = roaringFlameWarCtrl:isSeniorRewardLock()
		self.fields.lock:setVisible(not isActive)
		if isActive and (not (isAdd or isClaimed) and lv <= curLv or isAdd and curLv > advLv and lv < curLv) then
			self.fields.Com_item:setEffect(1)
		else
			self.fields.Com_item:hideEffect()
		end
	else
		local normalLv = roaringFlameWarCtrl:getDecreeNormalLv()
		local isClaimed = lv <= normalLv
		self.controllers.c1:setSelectedIndex(not (not isClaimed or isAdd) and 1 or 0)
		self.fields.lock:setVisible(false)
		if not (isAdd or isClaimed) and lv <= curLv or isAdd and curLv > normalLv and lv < curLv then
			self.fields.Com_item:setEffect(1)
		else
			self.fields.Com_item:hideEffect()
		end
	end
end
function Com_rewardItem:initNumData(data, index, num, isAdv)
	self.fields.Com_item:initData(data.id, data.count)
	local curNum = roaringFlameWarCtrl:getDecreeGiftUserNum()
	if isAdv then
		local isClaimed = index <= roaringFlameWarCtrl:getGiftSeniorIdx()
		self.controllers.c1:setSelectedIndex(isClaimed and 1 or 0)
		local isActive = roaringFlameWarCtrl:isSeniorRewardLock()
		self.fields.lock:setVisible(not isActive)
		if not isClaimed and isActive and num <= curNum then
			self.fields.Com_item:setEffect(1)
		else
			self.fields.Com_item:hideEffect()
		end
	else
		local isClaimed = index <= roaringFlameWarCtrl:getGiftNormalIdx()
		self.controllers.c1:setSelectedIndex(isClaimed and 1 or 0)
		self.fields.lock:setVisible(false)
		if not isClaimed and num <= curNum then
			self.fields.Com_item:setEffect(1)
		else
			self.fields.Com_item:hideEffect()
		end
	end
end
return Com_rewardItem
