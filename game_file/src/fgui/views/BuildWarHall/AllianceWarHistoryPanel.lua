local gametop = gModuleMgr.getObject("gametop")
local allianceLog = gametop.playertop_:getModule("allianceLog")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceBWList = gametop.playertop_:getModule("allianceBWList")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceWarHistoryPanel = class("AllianceWarHistoryPanel", baseFguiPanel)
function AllianceWarHistoryPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceWarHistoryPanel:ctor", self.viewName)
end
function AllianceWarHistoryPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceWarHistoryPanel:onInit()
	print("=======AllianceWarHistoryPanel:onInit")
	self.tableSpare, _ENV, self.tableHistoryBaseData, _ENV, self.tableHistoryData, _ENV, self.historyData, _ENV = print, print, print, print, print, print, print, print
	self.fromLoadText = false
	self.aktOffsetY = nil
	_ENV, _ENV, self.defOffsetY = "=======AllianceWarHistoryPanel:onInit", print, nil
	;("=======AllianceWarHistoryPanel:onInit").btn = self.fields.CheckBox_all
	;("=======AllianceWarHistoryPanel:onInit").label = self.fields.Text_all
	_ENV, print[1], ("=======AllianceWarHistoryPanel:onInit").str = "=======AllianceWarHistoryPanel:onInit", "=======AllianceWarHistoryPanel:onInit", i18n("common_text_635")
	;("=======AllianceWarHistoryPanel:onInit").btn = self.fields.CheckBox_nowhite
	;("=======AllianceWarHistoryPanel:onInit").label = self.fields.Text_nowhite
	_ENV, print[2], ("=======AllianceWarHistoryPanel:onInit").str = "=======AllianceWarHistoryPanel:onInit", "=======AllianceWarHistoryPanel:onInit", i18n("alliance_war_text_01")
	;("=======AllianceWarHistoryPanel:onInit").btn = self.fields.CheckBox_black
	;("=======AllianceWarHistoryPanel:onInit").label = self.fields.Text_black
	self.checks, print[3], ("=======AllianceWarHistoryPanel:onInit").str = print, "=======AllianceWarHistoryPanel:onInit", i18n("alliance_war_text_02")
	self.fields.Com_title:initData(i18n("common_text_285"), handler(self, self.onClickClose))
	self.fields.noTip:setString(i18n("god_beast_text_16"))
	self.fields.labelType:setString(i18n("common_text_286"))
	self.fields.labelAttack:setString(i18n("common_text_3033"))
	self.fields.labelDefense:setString(i18n("common_text_3034"))
	self.fields.labelTime:setString(i18n("common_text_289"))
	self.fields.scroll:setVirtual()
	self.fields.scroll:getScrollPane():getFooter():setTitle(i18n("common_text_084"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.scroll:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
end
function AllianceWarHistoryPanel:onShow()
	print("=======AllianceWarHistoryPanel:onShow")
	self:changeState()
	self:initChecks()
end
function AllianceWarHistoryPanel:initChecks(...)
	for i, v in ipairs(self.checks) do
		v.label:setString(v.str)
		v.btn:addClickEventListener(handler(self, self.btnCheckClickCallBack))
		v.btn:setTag(i)
		self:setCheck(v.btn, i == 1)
	end
	self.curLanguage = self.checks[1].btn
end
function AllianceWarHistoryPanel:setCheck(btn, isCheck)
	btn:setSelected(isCheck)
	btn:setTouchEnabled(not isCheck)
end
function AllianceWarHistoryPanel:btnCheckClickCallBack(button, type)
	button:setTouchEnabled(false)
	SoraDPlaySound()
	if self.curLanguage then
		self:setCheck(self.curLanguage, false)
	end
	self.curLanguage = button
	self:updateView()
end
function AllianceWarHistoryPanel:updateView()
	local tag = self.curLanguage:getTag()
	self.tableHistoryData, _ENV = self.curLanguage, self.curLanguage
	for i, v in ipairs(self.tableHistoryBaseData) do
		local bwType1 = v.atk.aid and allianceBWList:isInBWList(v.atk.aid) or 0
		local bwType2 = v.def.aid and allianceBWList:isInBWList(v.def.aid) or 0
		print("bwType1", bwType1)
		print("bwType2", bwType2)
		bwType1 = v.atk.teamId and allianceBWList:isInBWList(v.atk.teamId) or bwType1
		bwType2 = v.def.teamId and allianceBWList:isInBWList(v.def.teamId) or bwType2
		print("bwType1", bwType1)
		print("bwType2", bwType2)
		if tag == 2 and (bwType1 == gAllianceBWListType.WHITE or bwType2 == gAllianceBWListType.WHITE) then
			print("排除白名单", i)
		elseif tag == 3 and bwType1 ~= gAllianceBWListType.BLACK and bwType2 ~= gAllianceBWListType.BLACK then
			print("不在名单", i)
		else
			_ENV = i
			i.point = nil
			i.posY = 0
			i.data = v
			table.insert(self.tableHistoryData, i)
		end
	end
	self.fields.noTip:setVisible(#self.tableHistoryBaseData <= 0)
	self:updateScrollSize(self.tableHistoryData)
	self.fields.scroll:setNumItems(#self.tableHistoryData)
	self.nextindex = self.historyData.nextindex
	self.fields.scroll:getScrollPane():getFooter():setAlpha(self.nextindex ~= nil and 1 or 0)
end
function AllianceWarHistoryPanel:changeState()
	print("发消息=====")
	allianceLog:reqBattleRecord(allianceMgr.ownaid, 1)
	SoraDShowLoading(self:displayObject())
end
function AllianceWarHistoryPanel:updateData(target, data)
	for i, v in ipairs(data.historyList.msglist) do
		table.insert(self.tableHistoryBaseData, v)
	end
	self.historyData = data.historyList
	self:updateView()
	SoraDCloseLoading(self:displayObject())
end
function AllianceWarHistoryPanel:onItemRenderer(index, object)
	local data = self.tableHistoryData[index + 1]
	object:initData(data.data)
end
function AllianceWarHistoryPanel:updateScrollSize(tableHistoryData)
end
function AllianceWarHistoryPanel:initHistoryOnScroll(tableHistoryData)
end
function AllianceWarHistoryPanel:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(self:displayObject())
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceWarHistory" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function AllianceWarHistoryPanel:scrollEventCallBack(target, event)
	if self.nextindex ~= nil then
		allianceLog:reqBattleRecord(allianceMgr.ownaid, self.historyData.nextindex)
		SoraDShowLoading(self:displayObject())
	end
end
return AllianceWarHistoryPanel
