local pyramidTreasureRead = include("pyramidTreasureRead")
local pyramidTreasureRecordSingle = class("pyramidTreasureRecordSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidTreasureRecordSingle")
	end
	return target
end)
function pyramidTreasureRecordSingle:ctor()
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
end
function pyramidTreasureRecordSingle:initData(data, scroll, view, isNotSelf)
	self.Text_time:setString(os.date("!%m/%d %H:%M:%S", data.time or data[1]))
	local id, count = pyramidTreasureRead.getBestCfg(data.bestTreasureId or data[2])
	self.ccs_item:setOwnScroll(scroll)
	self.ccs_item:setOwnView(view)
	self.ccs_item:initData(id, count)
	if isNotSelf then
		self.ccs_head:setVisible(true)
		self.ccs_head:setHeadSprite(data.iconID, data.avatar)
		self.ccs_head:setPlayerID(data.uid)
		self.Text_name:setVisible(true)
		if data.allianceAbbr and data.allianceAbbr ~= "" then
			_ENV = os.date("!%m/%d %H:%M:%S", data.time or data[1])
			os.date("!%m/%d %H:%M:%S", data.time or data[1]).abbr = data.allianceAbbr
			os.date("!%m/%d %H:%M:%S", data.time or data[1]).name = data.nickName .. "#" .. data.kid
			self.Text_name:setString(i18n("common_text_186", os.date("!%m/%d %H:%M:%S", data.time or data[1])))
		else
			self.Text_name:setString(data.nickName .. "#" .. data.kid)
		end
		self.Text_time:setPositionX(SoraDFPosX(330, 534))
		self.ccs_item:setPositionX(SoraDFPosX(480, 534))
	else
		self.ccs_head:setVisible(false)
		self.Text_name:setVisible(false)
		self.Text_time:setPositionX(SoraDFPosX(80, 534))
		self.ccs_item:setPositionX(SoraDFPosX(450, 534))
	end
end
return pyramidTreasureRecordSingle
