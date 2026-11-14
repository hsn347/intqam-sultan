local gametop = gModuleMgr.getObject("gametop")
local radianceWarHistoryDetailSingle = class("radianceWarHistoryDetailSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarHistoryDetailSingle")
	end
	return target
end)
function radianceWarHistoryDetailSingle:ctor()
	self.imgSheer = SoraDGetChildByName(self, "Image_Sheer")
	self.textIndex = SoraDGetChildByName(self, "Text_index")
	self.spIndex = SoraDGetChildByName(self, "Sprite_index")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textKingInfo = SoraDGetChildByName(self, "Text_KingInfo")
end
function radianceWarHistoryDetailSingle:initData(data, otherData)
	self.imgSheer:setVisible(data.rank % 2 == 0)
	self.textIndex:setString(data.rank)
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(data.occupyTime)
	self.textTime:setString(i18n("brightWar_text_36", nil))
	self.textKingInfo:setString(data.kingdomName)
	if self.textIndex then
		self.textIndex:setVisible(data.rank > RANK_TOP_SPECIAL)
	end
	if self.spIndex then
		self.spIndex:setVisible(data.rank <= RANK_TOP_SPECIAL)
	end
	if data.rank <= RANK_TOP_SPECIAL then
		if self.spIndex then
			self.spIndex:setSpriteFrame("icon_ranking_" .. data.rank .. ".png")
		end
	elseif self.textIndex then
		self.textIndex:setString(data.rank)
	end
end
return radianceWarHistoryDetailSingle
