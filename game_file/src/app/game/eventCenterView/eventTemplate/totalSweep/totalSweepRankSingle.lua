local totalSweepRankSingle = class("totalSweepRankSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("totalSweepRankSingle")
	end
	return target
end)
function totalSweepRankSingle:ctor()
	self.Panel_lordSingle = SoraDGetChildByName(self, "Panel_lordSingle")
	self.Panel_lordSingle:setSwallowTouches(false)
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self, "CCS_commonHead_head")
	self.ccs_head:setScale(1.0)
	self.Text_lordNum = SoraDGetChildByName(self, "Text_lordNum")
	self.Image_lordNum = SoraDGetChildByName(self, "Image_lordNum")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_int = SoraDGetChildByName(self, "Text_int")
end
function totalSweepRankSingle:initData(data)
	self.data = data
	self.Panel_lordSingle:setBackGroundColorOpacity(self.data.rank % 2 == 0 and 0 or 25.5)
	self.ccs_head:setPlayerID(tonumber(self.data.uid))
	self.ccs_head:setHeadSprite(self.data.iconID, self.data.avatar)
	local isTopThree = self.data.rank >= 1 and self.data.rank <= RANK_TOP_SPECIAL
	self.Image_lordNum:setVisible(isTopThree)
	self.Text_lordNum:setVisible(not isTopThree)
	self.Text_lordNum:setString(self.data.rank)
	if isTopThree then
		self.Image_lordNum:loadTexture("icon_ranking_" .. self.data.rank .. ".png", ccui.TextureResType.plistType)
	end
	if self.data.abbr and self.data.abbr ~= "" then
		_ENV = ".png"
		;(".png").abbr = self.data.abbr
		;(".png").name = self.data.nickName
		self.Text_name:setString(i18n("common_text_186", ".png"))
	else
		self.Text_name:setString(self.data.nickName)
	end
	self.Text_int:setString(string.formatnumberthousands(self.data.score))
end
return totalSweepRankSingle
