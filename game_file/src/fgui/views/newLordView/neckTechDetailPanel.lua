local necklaceTechRead = include("necklaceTechRead")
local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local publicUtil = include("publicUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local neckTechDetailPanel = class("neckTechDetailPanel", baseFguiPanel)
function neckTechDetailPanel:ctor(...)
	self.isLRU = true
	neckTechDetailPanel.super.ctor(self, ...)
	print("neckTechDetailPanel:ctor", self.viewName)
end
function neckTechDetailPanel:onInit()
	print("=======neckTechDetailPanel:onInit")
	self.fields.Label_title:setString(i18n("garden_text_14"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_upLv:setTitle(i18n("common_text_062"))
	self.fields.Button_upLv:addClickListener(handler(self, self.onClick_Button_upLv))
	self.fields.Text_max:setString(i18n("flames_dunes_text82"))
	self.fields.Button_detail:addClickListener(handler(self, self.onClick_Button_detail))
end
function neckTechDetailPanel:endShow()
	print("=======neckTechDetailPanel:endShow")
	self.techID = self.param.techID
	local cfg = necklaceTechRead.getTechCfg(self.techID)
	self.fields.Panel_bg:setString(i18n(cfg.techName))
	self:updateView()
end
function neckTechDetailPanel:updateView()
	self.tableSingleData = necklaceTecCtrl:getTechnoDataByID(self.techID)
	self.fields.tech:initData(self.techID)
	local curLv = self.tableSingleData.currentLevel or 0
	local maxLv = self.tableSingleData.maxLevel
	if curLv >= maxLv then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Panel_bg:getController("size"):setSelectedIndex(1)
		self.fields.Button_upLv:setEnabled(false)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Panel_bg:getController("size"):setSelectedIndex(4)
		self:initScroll(curLv + 1)
	end
end
function neckTechDetailPanel:initScroll(lv)
	self.tableNeedList, necklaceTechRead = nil, nil
	local isCanResearch = true
	local technologyPre = necklaceTechRead.getTechPre(self.techID, lv)
	if technologyPre and 0 < #technologyPre then
		for _, v in ipairs(technologyPre) do
			necklaceTechRead = nil
			;(nil).type = "tech"
			;(nil).id = v.tid
			;(nil).lv = v.level
			table.insert(self.tableNeedList, nil)
			local tData = necklaceTecCtrl:getTechnoDataByID(v.tid)
			if tData.currentLevel < v.level then
				isCanResearch = false
			end
		end
	end
	local promoteItem = necklaceTechRead.getTechCondition(self.techID, lv)
	if promoteItem and 0 < #promoteItem then
		for _, v in ipairs(promoteItem) do
			local sType = serviceFunctions.getIDType(v.id)
			necklaceTechRead = nil
			;(nil).type = sType == gIDType.ITEM and "item" or "resource"
			;(nil).id = v.id
			;(nil).count = v.count
			table.insert(self.tableNeedList, nil)
			local count = publicUtil.getCount(v.id)
			if count < v.count then
				isCanResearch = false
			end
		end
	end
	self.fields.List:setNumItems(#self.tableNeedList)
	self.fields.Button_upLv:setEnabled(isCanResearch)
end
function neckTechDetailPanel:itemRenderer_List(index, obj)
	local data = self.tableNeedList[index + 1]
	obj:initData(data)
end
function neckTechDetailPanel:onClick_Button_upLv(context)
	SoraDPlaySound()
	necklaceTecCtrl:sendReqUpLvDataMsg(self.techID)
end
function neckTechDetailPanel:onClick_Button_detail(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("neckTechDetailView", nil)
end
return neckTechDetailPanel
