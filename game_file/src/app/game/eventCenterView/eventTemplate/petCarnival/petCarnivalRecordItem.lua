local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = SoraDGetCtrl("petCarnivalCtrl")
_ENV = "petCarnivalCtrl"
;("petCarnivalCtrl").noClaim = 1
;("petCarnivalCtrl").noReach = 2
local ("petCarnivalCtrl").claimed, giftStatus = 3, "petCarnivalCtrl"
local petCarnivalRecordItem = class("petCarnivalRecordItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petCarnivalRecordItem")
	end
	return target
end)
function petCarnivalRecordItem:ctor(...)
	self.award, _ENV = nil, nil
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.Text_dsc = SoraDGetChildByName(self, "Text_dsc")
	self.CCS_commonItemAward_1 = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.CCS_commonItemAward_1:setVisible(false)
	self.Text_time = SoraDGetChildByName(self, "Text_23")
	self.Node_13 = SoraDGetChildByName(self, "Node_13")
	if not SoraDFIsRA() then
		self.Node_13:setPositionX(55)
		self.Text_time:setPositionX(110)
		self.Text_dsc:setPositionX(433)
	end
end
function petCarnivalRecordItem:onMessageListener(...)
end
function petCarnivalRecordItem:initData(data, otherData)
	local card = clone(data.cardRecord[2])
	local reward = data.rewardRecord[1]
	local time = data.cardRecord[3]
	self.Text_time:setString(os.date("!%Y-%m-%d %H:%M:%S", time))
	for k, v in ipairs(self.award) do
		v:setVisible(false)
	end
	for index = 1, table.nums(reward) do
		local data = reward[index]
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(data.id, data.count)
			itemAward:setVisible(true)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.75)
			itemAward:setVisible(true)
			itemAward:setOwnScroll(otherData.scroll)
			itemAward:setOwnView(otherData.view)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(data.id, data.count)
			self.award[index] = itemAward
		end
	end
	if #card ~= 3 or not i18n("lost_ruins_text_32") then
		_ENV = reward[index]
		reward[index].num = 4 - #card
	end
	self.Text_dsc:setString((i18n("pet_flip_text_02", reward[index])))
	if #card == 3 then
	elseif #card == 2 then
		card[3] = card[2]
		card[2] = card[1]
	else
		card[3] = card[1]
		card[2] = card[1]
	end
	for index = 1, 3 do
		local img = SoraDGetChildByName(self, "Image_" .. index)
		if card[index] < 10 then
			img:loadTexture("frame_petFlip_0" .. card[index] .. ".png", ccui.TextureResType.plistType)
		else
			img:loadTexture("frame_petFlip_10.png", ccui.TextureResType.plistType)
		end
	end
	SoraDToCenter(self.Node_award, 85, SoraDFIsRA())
end
return petCarnivalRecordItem
