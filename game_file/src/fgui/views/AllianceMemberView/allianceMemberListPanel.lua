local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local KWKingdomCtrl = SoraDGetCtrl("KWKingdomCtrl")
local allianceDesRead = include("allianceDesRead")
_UPVALUE7_ = "allianceDesRead"
;("allianceDesRead")[1] = "5"
;("allianceDesRead")[2] = "6"
;("allianceDesRead")[3] = "4"
;("allianceDesRead")[4] = "3"
;("allianceDesRead")[5] = "2"
;("allianceDesRead")[6] = "1"
local ("allianceDesRead")[7], tableMemberListKey = "0", "allianceDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceMemberListPanel = class("allianceMemberListPanel", baseFguiPanel)
function allianceMemberListPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceMemberListPanel:ctor", self.viewName)
end
function allianceMemberListPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceMemberListPanel:onInit()
	print("=======allianceMemberListPanel:onInit")
	self.memberList, _ENV, self.tableMemberList, _ENV, gTableParam, print.inviteMoveCityPos, _ENV, _ENV = print, print, print, print, print, "=======allianceMemberListPanel:onInit", "=======allianceMemberListPanel:onInit", print
	self.loadNew = false
	self.isOwnAid = false
	self.aid = nil
	self.fields.Com_title:initData(i18n("common_text_180"), handler(self, self.onClickClose), handler(self, self.onBtnHelp))
	_ENV = handler(self, self.onBtnHelp)
	handler(self, self.onBtnHelp).h = 8
	self.fields.Text_notice:setString(i18n("common_text_3208", handler(self, self.onBtnHelp)))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClickCallBack))
	self.fields.Button_all:setVisible(false)
	self.fields.Button_all:addClickListener(handler(self, self.btnAllClickCallBack))
	self.fields.TextField_search:setMaxLength(20)
	self.fields.TextField_search:setAlign(SoraDFLabelR())
	self.fields.TextField_search:addEventListener(fgui.UIEventType.Changed, handler(self, self.OnInputChangeEnd))
	self.fields.List:setItemRenderer(handler(self, self.onMemberListRenderer))
	self.fields.Button_attribute:setString(i18n("common_btn_07"))
	self.fields.Button_attribute:addClickListener(handler(self, self.btnAttributeClick))
	if worldMapDefine.isInWarForbid(true) then
		self.fields.Button_attribute:setBright(false)
	end
	self.fields.Button_attack:setString(i18n("common_btn_21"))
	self.fields.Button_attack:addClickListener(handler(self, self.btnAttackClick))
	self.fields.Button_search:fixPos()
	self.fields.n3:fixPos()
	self.fields.TextField_search:fixPos()
	self.fields.Button_all:fixPos()
	self.fields.Button_attribute:fixPos()
	self.fields.Button_attack:fixPos()
end
function allianceMemberListPanel:OnInputChangeEnd()
	local returnName = self.fields.TextField_search:getText()
	local nameLen = string.utf8len(returnName)
	self.fields.Button_all:setVisible(0 < nameLen)
	if nameLen <= 0 then
		self:showAllMember()
	end
end
function allianceMemberListPanel:onMemberListRenderer(index, obj)
	obj:initData(self.memberList[index + 1], index + 1, self.aid)
end
function allianceMemberListPanel:onShow()
	print("=======allianceMemberListPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.aid = self.param and self.param.aid or allianceMgr:getOwnAid()
	local param = self.param and self.param.param
	if param then
		for k, v in pairs(param) do
			gTableParam[k] = v
		end
	end
	self.isOwnAid = allianceMgr.ownaid == self.aid
	self:updateScrollSize()
	allianceQuery:reqMemberList(self.aid)
	SoraDShowLoading(self)
end
function allianceMemberListPanel:switchMemberList(target, data)
	self.memberList[data.index].isOpen = data.isOpen
	self.fields.List:setNumItems(#self.memberList)
end
function allianceMemberListPanel:updateScrollSize()
	if self.isOwnAid then
		if KWKingdomCtrl:isProxyKing() then
			self.controllers.c1:setSelectedIndex(1)
		else
			self.controllers.c1:setSelectedIndex(0)
		end
	else
		self.controllers.c1:setSelectedIndex(2)
	end
end
function allianceMemberListPanel:updateData(target, data)
	SoraDCloseLoading(self)
	local ownmember = memberMgr:getOwnMember()
	local ownMapId = ownmember:getProperty("mapId")
	if target then
		self.tableMemberList = allianceMgr:getMemberList(self.aid)
	end
	if ownMapId then
		for k, v in pairs(self.tableMemberList) do
			for i = #v, 1, -1 do
				if v[i].getProperty and (v[i]:getProperty("mapId") == nil or v[i]:getProperty("mapId") ~= ownMapId) then
					table.remove(v, i)
				end
			end
		end
	end
	self:updateScrollSize()
	self:initScroll()
	self:updateScrollView()
	if not self.loadNew and self.isOwnAid then
		self.loadNew = true
		allianceQuery:reqApplyList(self.aid)
		SoraDShowLoading(self)
	end
	if data and data.reload and self.isOwnAid then
		allianceQuery:reqMemberList(self.aid)
		SoraDShowLoading(self)
	end
end
function allianceMemberListPanel:initScroll()
	for k, v in ipairs(tableMemberListKey) do
		if not self.memberList[k] then
			_ENV = self.memberList[k]
		end
		self.memberList[k] = self.memberList[k]
		self.memberList[k].rank = tonumber(v)
		if self.isOwnAid and allianceDesRead.getOwnRank() == tonumber(v) then
			self.memberList[k].isOpen = true
		elseif not self.isOwnAid and tonumber(v) == gAllianceRank.R5 then
			self.memberList[k].isOpen = true
		else
			self.memberList[k].isOpen = self.memberList[k].isOpen or false
		end
		self.memberList[k].memberList = self.tableMemberList[v]
	end
	self.fields.List:setNumItems(#self.memberList)
end
function allianceMemberListPanel:showAllMember()
	self:updateData(true)
end
function allianceMemberListPanel:updateScrollView()
end
function allianceMemberListPanel:btnAllClickCallBack(button, type)
	SoraDPlaySound()
	self.fields.TextField_search:setText("")
	self.fields.Button_all:setVisible(false)
	self:showAllMember()
end
function allianceMemberListPanel:btnSearchClickCallBack(button, type)
	SoraDPlaySound()
	local returnName = self.fields.TextField_search:getText()
	local nameLen = string.utf8len(returnName)
	if 0 < nameLen then
		local _ENV, searchData = returnName, returnName
		for i, v in ipairs(tableMemberListKey) do
			local rankData = self.tableMemberList[v]
			if rankData then
				for j, member in ipairs(rankData) do
					local baseName = member.nickName or member:getProperty("nickName")
					if string.find(string.lower(baseName), string.lower(returnName), 1, true) then
						if searchData[v] == nil then
							searchData[v], _ENV = searchData[v], searchData[v]
						end
						table.insert(searchData[v], member)
					end
				end
			end
		end
		if 0 < table.nums(searchData) then
			self:updateScrollSize()
			local index = 1
			self.memberList, _ENV = self, self
			for k, v in ipairs(tableMemberListKey) do
				if searchData[v] then
					self.memberList[index], _ENV = ipairs(rankData)
					self.memberList[index].rank = tonumber(v)
					self.memberList[index].isOpen = true
					self.memberList[index].memberList = searchData[v]
					index = index + 1
				end
			end
			self.fields.List:setNumItems(#self.memberList)
		else
			SoraDShowMsgTip(i18n("common_text_963"))
			self.fields.TextField_search:setText("")
			self.fields.Button_all:setVisible(false)
			self:showAllMember()
		end
	end
end
function allianceMemberListPanel:onBtnHelp()
	SoraDPlaySound()
	if not allianceDesRead.getPlayerConquestWarMigration() and not allianceDesRead.getPlayerBattleGroundMigration() then
		uiManager:show("allianceMemberRankInfoView")
	end
end
function allianceMemberListPanel:btnAttackClick()
	SoraDPlaySound()
	uiManager:show("allianceMemberBattlePointView")
end
function allianceMemberListPanel:btnAttributeClick()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbid() then
		return
	end
	uiManager:show("allianceAttributeView")
end
function allianceMemberListPanel:onHide()
	gTableParam.inviteMoveCityPos, _ENV = nil, nil
end
return allianceMemberListPanel
