local gametop = gModuleMgr.getObject("gametop")
local petCarnivalCtrl = SoraDGetCtrl("petCarnivalCtrl")
local petCarnivalRead = include("petCarnivalRead")
_ENV = "petCarnivalRead"
;("petCarnivalRead").noClaim = 1
;("petCarnivalRead").noReach = 2
local ("petCarnivalRead").claimed, giftStatus = 3, "petCarnivalRead"
local petCarnivalPreviewItem = class("petCarnivalPreviewItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petCarnivalPreviewItem")
	end
	return target
end)
function petCarnivalPreviewItem:ctor(...)
	self.award, _ENV = nil, nil
	self.Text_dsc = SoraDGetChildByName(self, "Text_dsc")
	self.Text_1 = SoraDGetChildByName(self, "Text_1")
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.CCS_commonItemAward_1 = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.CCS_commonItemAward_1:setVisible(false)
end
function petCarnivalPreviewItem:onMessageListener(...)
end
function petCarnivalPreviewItem:initData(data, otherData)
	_ENV = nil
	;(nil).num = data.index
	self.Text_1:setString(i18n("pet_flip_text_11", nil))
	if data.type ~= 1 or not i18n("lost_ruins_text_32") then
		_ENV = i18n("pet_flip_text_11", nil)
		i18n("pet_flip_text_11", nil).num = data.type
	end
	self.Text_dsc:setString((i18n("pet_flip_text_02", i18n("pet_flip_text_11", nil))))
	for index = 1, table.nums(data.reward) do
		local rewardData = data.reward
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(rewardData[index].id, rewardData[index].count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.75)
			itemAward:setOwnScroll(otherData.scroll)
			itemAward:setOwnView(otherData.view)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(rewardData[index].id, rewardData[index].count)
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.Node_award, 85, SoraDFIsRA())
end
return petCarnivalPreviewItem
