local MAX_AWARD_NUM = 5
local allianceMobAwardSingle = class("allianceMobAwardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMobAwardSingle")
	end
	return target
end)
function allianceMobAwardSingle:ctor()
	self.awardArray, _ENV = nil, nil
	self.Node_rank = SoraDGetChildByName(self, "Node_rank")
	self.Text_rank = SoraDGetChildByName(self, "Text_rank")
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Image_keyPoint = SoraDGetChildByName(self, "Image_keyPoint")
	self.Node_Top = SoraDGetChildByName(self, "Node_Top")
	self.Node_Top:setPositionY(190)
	self.Text_topOne = SoraDGetChildByName(self, "Text_topOne")
	self.Text_topOne:setString(i18n("alliance_flagname_01"))
	self.Text_topOne:setVisible(false)
	self.Node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Node_flag:setVisible(false)
end
function allianceMobAwardSingle:initData(data, otherData)
	self.data = data
	self.scroll = otherData.scroll
	self.view = otherData.view
	if otherData.stage then
		_ENV = nil
		;(nil).num = self.data.stage
		self.Text_rank:setString(i18n("common_text_3198", nil))
		self.Sprite_index:setVisible(false)
		SoraDToCenter(self.Node_rank)
		self.Image_keyPoint:setVisible(self.data.stage <= RANK_TOP_SPECIAL)
		self.Node_Top:setPositionY(190)
		self.Text_topOne:setVisible(false)
		self.Node_flag:setVisible(false)
	else
		_ENV = i18n("common_text_3198", nil)
		i18n("common_text_3198", nil).num = self.data.rank
		self.Text_rank:setString(i18n("common_text_617", i18n("common_text_3198", nil)))
		self.Sprite_index:setVisible(self.data.rank <= RANK_TOP_SPECIAL)
		if self.data.rank <= RANK_TOP_SPECIAL then
			self.Sprite_index:setSpriteFrame("icon_ranking_" .. self.data.rank .. ".png")
		end
		self.Sprite_index:setVisible(self.data.rank <= RANK_TOP_SPECIAL)
		SoraDToCenter(self.Node_rank)
		self.Image_keyPoint:setVisible(false)
		if self.data.rank == 1 then
			if not self.flag then
				self.flag = SoraDGetAllianceFlagByFid(17)
				self.flag:addTo(self.Node_flag)
			end
			self.Text_topOne:setVisible(true)
			self.Node_flag:setVisible(true)
			self.Node_Top:setPositionY(350)
		else
			self.Node_Top:setPositionY(190)
			self.Text_topOne:setVisible(false)
			self.Node_flag:setVisible(false)
		end
	end
	self:setAward()
end
function allianceMobAwardSingle:setAward()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local awardList = serviceFunctions.tableFormat(self.data.reward, nil)
	for k, v in ipairs(awardList) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(1.0)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.scroll)
			self.awardArray[k]:setPosition(0, 0)
			self.awardArray[k]:addTo(self.Node_items)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	for i = 1, #self.awardArray do
		self.awardArray[i]:setVisible(i <= #awardList)
	end
	SoraDToCenter(self.Node_items, 120, SoraDFIsRA())
end
return allianceMobAwardSingle
