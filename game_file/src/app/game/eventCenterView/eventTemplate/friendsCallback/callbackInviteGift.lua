local callbackInviteGift = class("callbackInviteGift", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("callbackInviteGift")
	end
	return target
end)
local friendsCallbackRead = include("friendsCallbackRead")
function callbackInviteGift:ctor()
	self:initWidget()
	self:initData()
end
function callbackInviteGift:initWidget()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("returnnew_title_014"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = SoraDCreatePanelByCloneNode(self.scroll, "commonAutoScrollList")
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.Panel_single = SoraDGetChildByName(self, "Panel_single")
end
function callbackInviteGift:initData()
	self.itemList = friendsCallbackRead.getCallbackInviteGift()
	self.scroll:updateScrollView(self.Panel_single:getContentSize(), self.itemList)
	self.Text_des:setString(i18n("returnnew_text_015"))
end
function callbackInviteGift:createSingle()
	local ocx = self.Panel_single:clone()
	local Text_title = SoraDGetChildByName(ocx, "Text_title")
	local Node_rewards = SoraDGetChildByName(ocx, "Node_rewards")
	function ocx.initData(target, data, otherData)
		Text_title:setString(string.format("%s -- %s", self:getShowLvStr(data.CastleLv[1]), self:getShowLvStr(data.CastleLv[2])))
		local rewards = data.Gift
		local width = 87
		for i, v in ipairs(rewards) do
			local item = SoraDCreatePanel("commonItemAward")
			item:setScale(0.8)
			item:setOwnView(self)
			item:addTo(Node_rewards)
			item:initData(v.id, v.count)
			item:setPosition(-width * 3.5 + width * i, 0)
		end
	end
	return ocx
end
function callbackInviteGift:getShowLvStr(lv)
	local isShowWarLv, textLv = SoraDGetBuildWarLv(lv)
	if isShowWarLv then
		_ENV = nil
		;(nil).lv = textLv
		textLv = i18n("common_text_1948", nil)
	end
	_ENV = nil
	;(nil).lv = textLv
	local str = i18n("common_text_3514", nil)
	return str
end
return callbackInviteGift
