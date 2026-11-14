local rechargePresentUtil = include("rechargePresentUtil")
local resDesRead = include("resDesRead")
local rechargePresentNodeGold = class("rechargePresentNodeGold", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargePresentNodeGold")
	end
	return target
end)
function rechargePresentNodeGold:ctor()
	self.txtTitle = SoraDGetChildByName(self, "Text_Title")
	self.txtNum = SoraDGetChildByName(self, "Text_Num")
	self.spriteBox = SoraDGetChildByName(self, "Sprite_10")
	self.txtTitle:setString(i18n("common_text_4458"))
end
function rechargePresentNodeGold:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function rechargePresentNodeGold:initData(rechargeIDList, viewType)
	self.rechargeIDList = rechargeIDList
	self.viewType = viewType
end
function rechargePresentNodeGold:msgCallBack(target, data)
	if not rechargePresentUtil.checkActivityFirstStage(self.activityID) then
		self:removeFromParent()
	end
end
function rechargePresentNodeGold:setActivityID(activityID)
	self.activityID = activityID
	for _, v in ipairs(self.rechargeIDList) do
		local num = rechargePresentUtil.getRecargeGiftNum(v.rechargeID, self.activityID)
		if num and 0 < num then
			self.txtNum:setString("X" .. num)
			break
		end
	end
	local resId = rechargePresentUtil.getResIdByActivityID(self.activityID)
	local iconName = resDesRead.getIcon(resId)
	self.spriteBox:setSpriteFrame(iconName)
end
return rechargePresentNodeGold
