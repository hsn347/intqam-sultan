local atlantisRewardSingle = class("atlantisRewardSingle", function(target)
	return target
end)
function atlantisRewardSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.Node_Rank = SoraDGetChildByName(self, "Node_Rank")
	self.icon_rank = SoraDGetChildByName(self.Node_Rank, "icon_rank")
	self.icon_rank:setVisible(false)
	self.Text_rank = SoraDGetChildByName(self.Node_Rank, "Text_rank")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	local offsetX = 204.5
	self.Node_item:setPositionX(self.Node_item:getPositionX() - SoraDFSign(offsetX))
	self.Node_Title = SoraDGetChildByName(self, "Node_Title")
	self.icon_Title = SoraDGetChildByName(self.Node_Title, "icon_Title")
	self.Text_Title = SoraDGetChildByName(self.Node_Title, "Text_Title")
end
function atlantisRewardSingle:initData(data, otherData)
	self.scroll = otherData.scroll
	self.view = otherData.view
	if not otherData.param then
		_ENV = otherData.param
	end
	self.param = otherData.param
	if data.rank then
		self.Node_Rank:setVisible(true)
		self.Node_Title:setVisible(false)
		if tolua.type(data.rank) == "number" then
			_ENV = nil
			;(nil).num = data.rank
			self.Text_rank:setString(i18n("common_text_617", nil))
		else
			local rankFrom = data.rank[1]
			local rankTo = data.rank[2]
			if rankFrom == rankTo then
				_ENV = i18n("common_text_617", nil)
				i18n("common_text_617", nil).num = rankTo
				self.Text_rank:setString(i18n("common_text_617", i18n("common_text_617", nil)))
			else
				_ENV = i18n("common_text_617", i18n("common_text_617", nil))
				i18n("common_text_617", i18n("common_text_617", nil)).num = string.format("%d-%d", rankFrom, rankTo)
				self.Text_rank:setString(i18n("common_text_617", i18n("common_text_617", i18n("common_text_617", nil))))
			end
		end
	else
		self.Node_Rank:setVisible(false)
		self.Node_Title:setVisible(true)
		self.icon_Title:setScale(0.8)
		self.icon_Title:setSpriteFrame(data.titleIcon)
		self.Text_Title:setString(i18n(data.titleStr))
	end
	for k, v in ipairs(data.award) do
		if not self.itemArray[k] then
			self.itemArray[k] = include("commonItemAward").new()
			self.itemArray[k]:setTextFont(self.param.fontSize or 22)
			self.itemArray[k]:setScale(self.param.itemScale or 0.7)
			self.itemArray[k]:setBaseScale(1.0)
			self.itemArray[k]:setPosition(0, 0)
			if data.highlight and data.highlight == k then
				self.itemArray[k]:showCoolSquare()
			end
			self.itemArray[k]:setOwnScroll(self.scroll)
			self.itemArray[k]:setOwnView(self.view)
			self.itemArray[k]:addTo(self.Node_item)
		end
		self.itemArray[k]:setVisible(true)
		self.itemArray[k]:initData(v.id, v.count)
	end
	for i = #self.itemArray, #data.award + 1, -1 do
		if self.itemArray[i] then
			self.itemArray[i]:setVisible(false)
		end
	end
	SoraDautoSortPos(self.Node_item, 5, SoraDFIsRA() and 2 or 0, cc.size(85.8, 75.8))
	local posY = data.singleH / 2
	self.Node_item:setPositionY(posY)
	self.Node_Rank:setPositionY(posY)
	self.Node_Title:setPositionY(posY)
end
function atlantisRewardSingle:showLine(visible)
	SoraDGetChildByName(self, "frame_king_road_line_04_8"):setVisible(visible)
	SoraDGetChildByName(self, "Image_1"):setVisible(visible)
end
return atlantisRewardSingle
