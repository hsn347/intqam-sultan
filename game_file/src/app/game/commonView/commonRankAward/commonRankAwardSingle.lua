local commonRankAwardSingle = class("commonRankAwardSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonRankAwardSingle")
	end
	return target
end)
function commonRankAwardSingle:ctor()
	self.itemArray, _ENV = nil, nil
	self.icon_rank = SoraDGetChildByName(self, "icon_rank")
	self.Text_rank = SoraDGetChildByName(self, "Text_rank")
	self.Node_item = SoraDGetChildByName(self, "Node_item")
end
function commonRankAwardSingle:initData(data, otherData)
	self.scroll = otherData.scroll
	self.view = otherData.view
	if not otherData.param then
		_ENV = otherData.param
	end
	self.param = otherData.param
	local rankFrom = data.rank[1]
	local rankTo = data.rank[2]
	if not rankFrom and not rankTo then
		self.icon_rank:setVisible(false)
		self.Text_rank:setVisible(true)
		self.Text_rank:setString(i18n("common_text_312"))
	elseif rankFrom == rankTo then
		if self.param.chapter then
			self.icon_rank:setVisible(false)
			self.Text_rank:setVisible(true)
			_ENV = i18n("common_text_312")
			i18n("common_text_312").num = rankFrom
			self.Text_rank:setString(i18n("common_text_3162", i18n("common_text_312")))
		elseif rankFrom <= RANK_TOP_SPECIAL then
			self.icon_rank:setVisible(true)
			self.Text_rank:setVisible(false)
			self.icon_rank:setSpriteFrame("icon_ranking_" .. rankFrom .. ".png")
		else
			self.icon_rank:setVisible(false)
			self.Text_rank:setVisible(true)
			self.Text_rank:setString(rankFrom)
		end
	else
		self.icon_rank:setVisible(false)
		self.Text_rank:setVisible(true)
		if 99999999 <= rankTo then
			self.Text_rank:setString(string.format("%d+", rankFrom))
		else
			self.Text_rank:setString(string.format("%d-%d", rankFrom, rankTo))
		end
	end
	local award = data.reward or data.rewards
	if type(award[1]) == "number" then
		_UPVALUE2_ = string.format("%d-%d", rankFrom, rankTo)
		string.format("%d-%d", rankFrom, rankTo)[1] = "id"
		string.format("%d-%d", rankFrom, rankTo)[2] = "count"
		award = serviceFunctions.tableFormat(award, string.format("%d-%d", rankFrom, rankTo))
	end
	for k, v in ipairs(award) do
		if not self.itemArray[k] then
			self.itemArray[k] = SoraDPopItemAward()
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
	for i = #self.itemArray, #award + 1, -1 do
		if self.itemArray[i] then
			self.itemArray[i]:setVisible(false)
		end
	end
	local __, totalLen = SoraDToCenter(self.Node_item, self.param.interval or 84, SoraDFIsRA())
	local beginPosx = self.param.itemsPositionX or 430
	self.Node_item:setPosition(SoraDFPoint(beginPosx - totalLen / 2, self.Node_item:getPositionY(), 536))
	if otherData.singleSize then
		_UPVALUE3_ = self.Node_item
		self.Node_item[1] = self.icon_rank
		self.Node_item[2] = self.Text_rank
		self.Node_item[3] = self.Node_item
		for i, v in ipairs(self.Node_item) do
			v:setPositionY(otherData.singleSize.height / 2)
		end
	end
	if otherData.center then
		_UPVALUE2_ = ipairs(self.Node_item)
		ipairs(self.Node_item)[1] = self.icon_rank
		ipairs(self.Node_item)[2] = self.Text_rank
		for i, v in ipairs(ipairs(self.Node_item)) do
			v:setPosition(SoraDFPoint(beginPosx + 55, self.Node_item:getPositionY(), 536))
		end
	end
	local node = SoraDGetChildByName(self, "Node_Need")
	if node then
		node:setVisible(false)
		if data.needShowInfo and rankTo <= data.needShowInfo.num then
			SoraDGetChildByName(self, "Node_Need"):setVisible(true)
			_ENV = v.setPosition
			v.setPosition.num = string.formatnumberthousands(data.needShowInfo.charmNum)
			SoraDGetChildByName(self, "Text_NeedPoint"):setString(i18n(data.needShowInfo.i18nKey, v.setPosition))
		end
	end
end
return commonRankAwardSingle
