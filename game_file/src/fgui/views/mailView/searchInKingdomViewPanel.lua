local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local searchInKingdomViewPanel = class("searchInKingdomViewPanel", baseFguiPanel)
function searchInKingdomViewPanel:ctor(...)
	searchInKingdomViewPanel.super.ctor(self, ...)
	print("searchInKingdomViewPanel:ctor", self.viewName)
end
function searchInKingdomViewPanel:onInit()
	print("=======searchInKingdomViewPanel:onInit")
	self.searchList, _ENV = print, print
	self.nextIndex = nil
	self.fields.Com_title:initData(i18n("item_name_501901"), handler(self, self.onClickClose))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onListEnd))
	self.fields.Text_none:setString(i18n("common_text_963"))
	self.fields.Text_none:setVisible(false)
	self.tfdSearch = self.fields.input:getChild("input")
	self.fields.input:fixPos()
	self.fields.Button_search:fixPos()
end
function searchInKingdomViewPanel:onItemRenderer(index, obj)
	obj:initData(self.searchList[index + 1])
	obj:setParent(self)
end
function searchInKingdomViewPanel:onListEnd()
	if self.keyname and self.keyname ~= "" then
		local offsetY = self.fields.List:getScrollPane():getPositionY()
		if offsetY >= math.ceil(#self.searchList / 2) * 180 - self.fields.List:getHeight() - 180 and self.nextIndex ~= nil then
			lordInfoCtrl:searchLordInKingdomReq(self.keyname, self.nextIndex, lordSearchType.PIGEON)
		end
	end
end
function searchInKingdomViewPanel:onShow()
	print("=======searchInKingdomViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.isAbbr = self.param and self.param.isAbbr or false
	self.searchName = self.param and self.param.searchName or nil
	self.aid = allianceMgr:getOwnAid()
	self:initData()
end
function searchInKingdomViewPanel:initData()
	if self.searchName and self.searchName ~= "" then
		lordInfoCtrl:searchLordInKingdomReq(self.searchName, 1, lordSearchType.PIGEON)
		self.tfdSearch:setText(self.searchName)
	elseif self.aid and self.aid ~= 0 then
		allianceQuery:reqMemberList(self.aid)
	else
		lordInfoCtrl:searchLordInKingdomReq("", 1, lordSearchType.PIGEON)
	end
	SoraDShowLoading(self)
end
function searchInKingdomViewPanel:initSearchData(target, data)
	SoraDCloseLoading(self)
	if data.msg == "MESSAGE_ITEM_LORD_SEARCH_BACK" then
		local retdata = data.data
		self.nextIndex = retdata.nextindex
		for i, v in ipairs(retdata.uinfolist) do
			_ENV = nil
			;(nil).isAllianceMember = false
			;(nil).uid = v.uid
			;(nil).iconID = v.iconID
			;(nil).totalFc = v.totalFc
			;(nil).nickName = v.nickName
			;(nil).allianceAbbr = v.allianceAbbr
			;(nil).cityLevel = v.cityLevel
			;(nil).starLv = v.starLv
			;(nil).online = v.online
			;(nil).language = v.language
			table.insert(self.searchList, nil)
		end
		self.fields.Text_none:setVisible(#self.searchList == 0)
	else
		self.searchList, _ENV = data.data, data.data
		local allianceData = allianceMgr:getMemberList(self.aid)
		_UPVALUE6_ = allianceMgr
		allianceMgr[1] = "5"
		allianceMgr[2] = "6"
		allianceMgr[3] = "4"
		allianceMgr[4] = "3"
		allianceMgr[5] = "2"
		local allianceMgr[6], tableMemberListKey = "1", allianceMgr
		for _, rank in ipairs(tableMemberListKey) do
			if not allianceData[rank] then
				local _ENV, rankData = allianceData[rank], allianceData[rank]
			end
			for k, v in ipairs(rankData) do
				_ENV = nil
				;(nil).isAllianceMember = true
				;(nil).uid = v.minfo.uid
				;(nil).iconID = v.uinfo.iconID
				;(nil).totalFc = v.uinfo.totalFc
				;(nil).nickName = v.uinfo.nickName
				;(nil).allianceAbbr = allianceMgr:getAllianceProperty("abbr")
				;(nil).cityLevel = v.uinfo.cityLevel
				;(nil).starLv = v.uinfo.starLv
				;(nil).online = v.uinfo.online
				table.insert(self.searchList, nil)
			end
		end
		self.fields.Text_none:setVisible(false)
	end
	self.fields.List:setNumItems(#self.searchList)
end
function searchInKingdomViewPanel:btnSearchClick(button, ttype)
	SoraDPlaySound()
	self.keyname = self.tfdSearch:getText()
	if not self.keyname or type(self.keyname) ~= "string" or string.utf8len(self.keyname) <= 0 then
		return
	end
	self.searchList, _ENV = string.utf8len(self.keyname), string.utf8len(self.keyname)
	lordInfoCtrl:searchLordInKingdomReq(self.keyname, 1, lordSearchType.PIGEON)
	SoraDShowLoading(self)
end
return searchInKingdomViewPanel
