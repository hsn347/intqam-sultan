local warTreasureCtrl = SoraDGetCtrl("warTreasureCtrl")
local warTreasureLog = class("warTreasureLog", function(ccsFileName)
	local target = SoraDCreateTouchPanel(ccsFileName)
	return target
end)
local MAX_REQ_NUM = 10
function warTreasureLog:ctor()
	self.rankData, _ENV, self.sIndex = nil, nil, 1
	self.wGet = true
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("warSecrit_title_01"))
	self.singleNode = SoraDGetChildByName(self, "Node_score")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.scroll:setScrollBottomFun(handler(self, self.reqSendMsg))
	self.textTips = SoraDGetChildByName(self, "Text_Tip")
	self.textTips:setString(i18n("parliament_text_11"))
	self:reqSendMsg()
end
function warTreasureLog:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WAR_TREASURE_REFRESH", handler(self, self.updataData))
end
function warTreasureLog:updataData(target, data)
	if data.subMsg == "logList" then
		SoraDCloseLoading(self)
		dump(data, "warTreasureLog:updataData", 20)
		if not data.rankList then
			local _ENV, rankList = data.rankList, data.rankList
		end
		local num = #rankList
		self.sIndex = self.sIndex + #rankList
		self.wGet = num >= MAX_REQ_NUM
		if next(rankList) ~= nil then
			local cpyTbl = clone(rankList)
			for _, v in ipairs(cpyTbl) do
				table.insert(self.rankData, v)
			end
		end
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(533, 100), self.rankData, 1, nil)
	end
end
function warTreasureLog:createSingle()
	local single = self.singleNode:clone()
	return single
end
function warTreasureLog:refreshSingle(single, info)
	local index = single:getTag()
	local txtInfo = SoraDGetChildByName(single, "Text_info")
	local txtTime = SoraDGetChildByName(single, "Text_time")
	local spBg = SoraDGetChildByName(single, "Image_Bg")
	txtInfo = SoraDChangeTextToHtml(txtInfo)
	local allianceName = "(" .. (info and info.toAllianceAbb or "") .. ")" .. string.htmlspecialchars(info and info.toAllianceName or "")
	_ENV = nil
	;(nil).name = "(" .. (info.allianceAbb or "") .. ")" .. info.name
	;(nil).alliance = allianceName
	_ENV, _ENV, (nil).num = info.allianceAbb or "", info.n, info.n
	_ENV, info.n.num, (info.allianceAbb or "").color = info.allianceAbb or "", info.allianceAbb or "", "#00BE1E"
	info.n.__default, (info.allianceAbb or "").color = info.allianceAbb or "", "#D7C39B"
	txtInfo:setString(i18n_html(info.subType == 1 and "warSecrit_text_03" or "warSecrit_text_04", nil, info.n))
	txtTime:setString(SoraDConverTimeStr(info.t))
	spBg:setVisible(index % 2 == 1)
end
function warTreasureLog:reqSendMsg()
	if self.wGet then
		self.wGet = false
		SoraDShowLoading(self)
		_ENV = nil
		;(nil).iBegin = self.sIndex
		;(nil).nCount = MAX_REQ_NUM
		warTreasureCtrl:reqWarTreasureDonateLog(nil)
	end
end
return warTreasureLog
