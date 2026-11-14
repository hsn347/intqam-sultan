local htBattleMgr = include("htBattleMgr")
local htMapMgr = include("htMapMgr")
local heroTrialltCtrl = include("heroTrialltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialAreaPanel = class("heroTrialAreaPanel", baseFguiPanel)
function heroTrialAreaPanel:ctor(...)
	heroTrialAreaPanel.super.ctor(self, ...)
	print("heroTrialAreaPanel:ctor", self.viewName)
end
function heroTrialAreaPanel:onInit()
	print("=======heroTrialAreaPanel:onInit")
	self.curAreaId = 1
	self.curPage = 1
	self.maxPage = 2
	self.classCount = heroTrialltCtrl.getMapAreaNum()
	self.fields.Com_title:initData(i18n("common_text_1697"), handler(self, self.onClickClose))
	self.fields.pageLeft:addClickListener(handler(self, self.btnLeftClick))
	self.fields.pageRight:addClickListener(handler(self, self.btnRightClick))
	self.fields.List_gate:setVirtual()
	self.fields.List_gate:setItemRenderer(handler(self, self.onPageRenderer))
	self.fields.List_chapter:setItemRenderer(handler(self, self.onChapterRenderer))
end
function heroTrialAreaPanel:onShow()
	print("=======heroTrialAreaPanel:onShow")
	self.fields.Com_bg:setGradientColor()
end
function heroTrialAreaPanel:endShow()
	if htBattleMgr.curTrialMap then
		local mapId = htBattleMgr.curTrialMap:getMapID()
		htBattleMgr = nil
		;(nil).mapId = mapId
		uiManager:show("heroTrialMapView", nil)
		local stageId = htBattleMgr.curTrialMap:getLastStage()
		self.curAreaId = heroTrialltCtrl.getAreaIDOfStage(stageId)
		self.curPage = math.ceil(math.floor(stageId / 100) % 20 / 10)
	end
	self.fields.List_gate:setNumItems(self.maxPage)
	self.fields.List_gate:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local offsetX = self.fields.List_gate:getScrollPane():getPositionX()
		self.curPage = 638 <= offsetX and 2 or 1
		print("==offsetX,self.curPage==", offsetX, self.curPage)
		self:updateBtnLR()
	end)
	self:turnToDefault()
end
function heroTrialAreaPanel:turnToDefault()
	local defaultArea, defaultPage, defaultMapId
	if htBattleMgr.curTrialMap then
		defaultMapId = tonumber(htBattleMgr.curTrialMap:getMapID())
	else
		defaultMapId = tonumber(htMapMgr.getLastUnlockMap())
	end
	defaultArea = math.floor((defaultMapId - 401) / 20) + 1
	defaultPage = 1
	if defaultMapId % 20 > 10 or defaultMapId % 20 == 0 then
		defaultPage = 2
	end
	self.curAreaId = defaultArea
	htBattleMgr = (defaultMapId - 401) / 20
	;(defaultMapId - 401) / 20.msg = "MESSAGE_UI_HEROTRIAL_AREA_SELECT"
	;(defaultMapId - 401) / 20.areaId = self.curAreaId
	SoraDSendMessage((defaultMapId - 401) / 20)
	self.fields.List_chapter:setNumItems(self.classCount)
	self.fields.List_gate:getScrollPane():setPercX(defaultPage - 1, true)
	self:updateBtnLR()
	self:updateBtnSelect()
end
function heroTrialAreaPanel:onPageRenderer(index, obj)
	obj:initData(index + 1, self.curAreaId)
end
function heroTrialAreaPanel:onChapterRenderer(index, obj)
	obj:initData(index + 1, self.curAreaId)
end
function heroTrialAreaPanel:areaSelect(target, data)
	self.curAreaId = data.areaId
	self.curPage = 1
	self.fields.List_chapter:setNumItems(self.classCount)
	self:updateBtnLR()
	self.fields.List_gate:setNumItems(self.maxPage)
	self.fields.List_gate:scrollToView(0, true)
end
function heroTrialAreaPanel:updateArea()
	self.fields.List_chapter:setNumItems(self.classCount)
	self.fields.List_gate:setNumItems(self.maxPage)
end
function heroTrialAreaPanel:updateBtnLR()
	self.fields.pageLeft:setVisible(self.curPage == 2)
	self.fields.pageRight:setVisible(self.curPage == 1)
end
function heroTrialAreaPanel:updateBtnSelect()
	self.fields.List_chapter:setNumItems(self.classCount)
	print("self.curAreaId=====", self.curAreaId)
	self.fields.List_chapter:scrollToView(self.curAreaId - 1)
end
function heroTrialAreaPanel:btnLeftClick()
	SoraDPlaySound()
	self.curPage = 1
	self:updateBtnLR()
	self.fields.List_gate:getScrollPane():setPercX(0, true)
end
function heroTrialAreaPanel:btnRightClick()
	SoraDPlaySound()
	self.curPage = 2
	self:updateBtnLR()
	self.fields.List_gate:getScrollPane():setPercX(1, true)
end
return heroTrialAreaPanel
