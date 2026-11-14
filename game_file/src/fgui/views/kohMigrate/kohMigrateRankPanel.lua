local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateRankPanel = class("kohMigrateRankPanel", baseFguiPanel)
function kohMigrateRankPanel:ctor(...)
	kohMigrateRankPanel.super.ctor(self, ...)
	print("kohMigrateRankPanel:ctor", self.viewName)
	self.debug = true
	self.iBegin = 1
	self.nCount = 250
	self.rankList, kohMigrateRankPanel, self.hasMore = print, print, true
	self.selfKid = gametop.playertop_:getKingdomID()
end
function kohMigrateRankPanel:onInit()
	print("=======kohMigrateRankPanel:onInit")
	self.fields.Com_title:initData(i18n("migrant_move_text30"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_value:setString(i18n("migrant_move_text3"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_noData:setString(i18n("migrant_move_text33"))
	self.fields.Text_noData:setVisible(false)
	if not SoraDFIsRA() then
		self.fields.Text_name:fixPos()
		self.fields.Text_value:fixPos()
	end
end
function kohMigrateRankPanel:onShow()
	print("=======kohMigrateRankPanel:onShow")
	self.kid = self.param and self.param.kid
	if not self.kid then
		local kohMigrateRead = include("kohMigrateRead")
		local legendPlayerNumber = kohMigrateRead.getLegendPlayerNumber()
		self.nCount = math.max(self.nCount, legendPlayerNumber)
	end
	if self.kid then
		self.fields.Com_title:setString(i18n("migrant_move_text32"))
	else
		self.fields.Com_title:setString(i18n("migrant_move_text30"))
	end
	if not self.kid or self.kid == self.selfKid then
		self.controllers.c_showSelf:setSelectedIndex(0)
	else
		self.controllers.c_showSelf:setSelectedIndex(1)
	end
	if not kohMigrateCtrl:isGroupKidMapExist() then
		kohMigrateCtrl:reqGroupList()
	end
	self:req4Data()
end
function kohMigrateRankPanel:onClickHelp()
	SoraDPlaySound()
	local kohMigrateRead = include("kohMigrateRead")
	local kidStr = kohMigrateRead.getMinAndMaxKidStr()
	local legendNum = kohMigrateRead.getLegendLordNumber()
	_ENV = nil
	;(nil).var2 = kidStr
	;(nil).var3 = legendNum
	local ruleStr10 = i18n("migrant_move_rule10", nil)
	_ENV = nil
	;(nil).content = ruleStr10
	uiManager:show("RuleView", nil)
end
function kohMigrateRankPanel:onItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	data.rank = rank
	self:updateItemSingle(obj, data)
end
function kohMigrateRankPanel:updateItemSingle(obj, data)
	_UPVALUE0_ = nil
	;(nil).rank = data.rank
	;(nil).uid = data.uid
	;(nil).name = data.name or "player" .. data.rank
	;(nil).iconID = data.headid or 1401
	;(nil).avatar = data.avatar or ""
	;(nil).kid = data.kid
	;(nil).score = data.legend
	;(nil).isOwnRank = obj == self.fields.Com_myRank
	obj:initData(nil)
end
function kohMigrateRankPanel:onMsgUpdatePlayerRank(target, event)
	SoraDCloseLoading(self:displayObject())
	local rspdata = event.rspdata
	local showMyRank = false
	if self.iBegin == 1 and self.controllers.c_showSelf:getSelectedIndex() == 0 then
		showMyRank = true
	end
	if not rspdata.rank then
		local _ENV, rankList = rspdata.rank, rspdata.rank
	end
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	if not self.kid then
		self.hasMore = false
		if kohMigrateCtrl:isGroupKidMapExist() then
			self.rankList = self:getGroupRankList()
		else
			self.isWaiting = true
			SoraDShowLoading(self:displayObject())
			return
		end
	end
	self.fields.List:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(0 >= #self.rankList)
	if showMyRank then
		local info = lordInfoCtrl:getBaseInfo()
		_ENV = lordInfoCtrl
		lordInfoCtrl.kid = gametop.playertop_:getKingdomID()
		lordInfoCtrl.name = info.nickName
		lordInfoCtrl.headid = info.imageId
		lordInfoCtrl.avatar = info.avatar
		local lordInfoCtrl.uid, data = SoraDGetPlayerID(), lordInfoCtrl
		if not rspdata.myInfo then
			local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
		end
		data.rank = myInfo.rank or 0
		for i, v in ipairs(self.rankList) do
			if v.uid == data.uid then
				data.rank = i
				break
			end
		end
		data.legend = myInfo.legend or 0
		self:updateItemSingle(self.fields.Com_myRank, data)
	end
end
function kohMigrateRankPanel:onPullUpRelease(...)
	if self.hasMore then
		self:req4Data()
	end
end
function kohMigrateRankPanel:req4Data()
	kohMigrateCtrl:reqT1PlayerRank(self.iBegin, self.nCount, self.kid)
	SoraDShowLoading(self:displayObject())
end
function kohMigrateRankPanel:getGroupRankList(...)
	local _ENV, ret
	for __, v in ipairs(self.rankList) do
		if kohMigrateCtrl:isGroupKid(v.kid) then
			table.insert(ret, v)
		end
	end
	return ret
end
function kohMigrateRankPanel:onMsgUpdateGroupList(...)
	if self.kid then
		return
	end
	if not kohMigrateCtrl:isGroupKidMapExist() then
		return
	end
	if self.isWaiting then
		self.isWaiting = false
		SoraDCloseLoading(self:displayObject())
		self.rankList = self:getGroupRankList()
		self.fields.List:setNumItems(#self.rankList)
		self.fields.Text_noData:setVisible(#self.rankList <= 0)
	end
end
return kohMigrateRankPanel
