local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local palaceInfoRead = include("palaceInfoRead")
local radianceWarIntegralPalaceView = class("radianceWarIntegralPalaceView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
function radianceWarIntegralPalaceView:ctor()
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("commonRankingSingle")
	self.textNotice = SoraDGetChildByName(self.scrollRank, "Text_notice")
	self.textPoint = SoraDGetChildByName(self, "Text_point")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textNoRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.textPoint:setString(i18n("brightWar_text_34"))
	self.textRank:setString(i18n("common_text_2193"))
	self.textName:setString(i18n("common_text_2037"))
	self.textNoRecrod:setString(i18n("common_text_927"))
	SoraDShowLoading(self)
	radianceActivityCtrl:reqKindomPalaceRank()
end
function radianceWarIntegralPalaceView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_UI_REFRESH", handler(self, self.initData))
end
function radianceWarIntegralPalaceView:initData(target, data)
	if data.subMsg == "KingPalaceRank" then
		SoraDCloseLoading(self)
		if data.err then
			return
		end
		if not data.data or not data.data.rankList then
			_ENV = data.data.rankList
		end
		self.rankInfo = data.data.rankList
		local _ENV, tmp = data.data.rankList, data.data.rankList
		for i, v in ipairs(self.rankInfo) do
			local _ENV, singleData
			singleData.player, _ENV, singleData.rank = nil, nil, i
			singleData.lineOneName = v.kname
			singleData.player.palaceIcon = self:getKidPalace(v.kPlace or 1)
			singleData.kid = v.kid
			singleData.score = SoraDConvertSecondToString(v.totalSecs)
			singleData.model = 3
			singleData.nameShowType = 1
			singleData.btnClickType = 4
			table.insert(tmp, singleData)
		end
		if self.rankInfo and next(self.rankInfo) then
			self.scrollRank:setVisible(true)
			_ENV = nil
			;(nil).scroll = self.scroll
			;(nil).view = self
			self.scrollRank:updateScrollView(cc.size(640, 112), tmp, 1, nil)
			self.scrollRank:jumpToTop()
			self.textNoRecrod:setVisible(false)
		else
			self.scrollRank:setVisible(false)
			self.textNoRecrod:setVisible(true)
		end
	end
end
function radianceWarIntegralPalaceView:getKidPalace(kPlace)
	if self.kingdomlist then
		if self.kingdomlist[tonumber(kid)] then
			return palaceInfoRead.getIcon(kPlace or 1)
		else
			return palaceInfoRead.getIcon(1)
		end
	else
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
		self.kingdomlist = kingdomCtrl:getKingdomList()
		if self.kingdomlist[tonumber(kid)] then
			return palaceInfoRead.getIcon(kPlace or 1)
		else
			return palaceInfoRead.getIcon(1)
		end
	end
end
return radianceWarIntegralPalaceView
