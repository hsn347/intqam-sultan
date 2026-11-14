local gametop = gModuleMgr.getObject("gametop")
local allianceHelp = SoraDGetCtrl("allianceHelp")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EmbassyViewPanel = class("EmbassyViewPanel", baseFguiPanel)
function EmbassyViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EmbassyViewPanel:ctor", self.viewName)
	self.tableHelpList, _ENV, self.isHideCurrentSceneView = print, print, true
end
function EmbassyViewPanel:onInit()
	print("=======EmbassyViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_193"), handler(self, self.onClickClose))
	self.fields.Button_join:setString(i18n("common_text_167"))
	self.fields.Button_join:addClickListener(handler(self, self.btnJoinClick))
	self.btnHelpAll = self.fields.Button_helpAll
	self.btnHelpAll:setString(i18n("common_text_579"))
	self.btnHelpAll:addClickListener(handler(self, self.btnHelpAllClick))
	self.txtNoHelp = self.fields.Text_noHelp
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function EmbassyViewPanel:onShow()
	print("=======EmbassyViewPanel:onShow")
	self:postReq()
end
function EmbassyViewPanel:postReq()
	if allianceMgr:hasJoinAlliance() then
		self.controllers.c_alliance:setSelectedIndex(0)
		SoraDShowLoading(self:displayObject())
		allianceHelp:reqAllianceHelpData()
		self.txtNoHelp:setString(i18n("common_text_578"))
	else
		self.controllers.c_alliance:setSelectedIndex(1)
		self.txtNoHelp:setString(i18n("common_text_583"))
	end
end
function EmbassyViewPanel:initData(target, redata)
	SoraDCloseLoading(self:displayObject())
	local alliHelp = allianceHelp:getHelpList()
	self.tableHelpList = alliHelp.totalhelplist
	dump(self.tableHelpList, "==self.tableHelpList==")
	self:update()
end
function EmbassyViewPanel:update()
	if next(self.tableHelpList) ~= nil then
		self.txtNoHelp:setVisible(false)
		self.btnHelpAll:setEnabled(true)
	else
		self.fields.List:setNumItems(0)
		self.txtNoHelp:setVisible(true)
		self.btnHelpAll:setEnabled(false)
		return
	end
	local lordInList = false
	local lordid = gametop.playertop_:getPlayerID()
	for i, v in ipairs(self.tableHelpList) do
		if v.uid == lordid then
			lordInList = true
		else
			lordInList = false
		end
	end
	if lordInList then
		self.btnHelpAll:setEnabled(false)
	end
	self.fields.List:setNumItems(#self.tableHelpList)
end
function EmbassyViewPanel:btnHelpAllClick()
	SoraDPlaySound()
	print("帮助所有")
	allianceHelp:reqHelpAll()
	SoraDShowLoading(self:displayObject())
end
function EmbassyViewPanel:btnJoinClick()
	SoraDPlaySound()
	uiManager:show("AllianceJoinView")
end
function EmbassyViewPanel:itemHelpCallBack(uid, queuetype)
	print("帮助的是" .. uid .. "帮助类型" .. queuetype)
	allianceHelp:reqHelpOne(uid, queuetype)
	SoraDShowLoading(self:displayObject())
end
function EmbassyViewPanel:onItemRenderer(index, obj)
	local data = self.tableHelpList[index + 1]
	if data == nil then
		return
	end
	local lordid = gametop.playertop_:getPlayerID()
	if data.uid == lordid then
		obj:initData(data, true)
	else
		obj:initData(data, false)
	end
	obj:setHelpHandl(handler(self, self.itemHelpCallBack))
end
return EmbassyViewPanel
