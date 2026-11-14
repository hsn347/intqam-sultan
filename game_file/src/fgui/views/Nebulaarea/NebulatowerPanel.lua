local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulatowerPanel = class("NebulatowerPanel", baseFguiPanel)
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
function NebulatowerPanel:ctor(...)
	self.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
	self.debug = true
	print("NebulatowerPanel:ctor", self.viewName)
end
function NebulatowerPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaWar"
	end
	return self._packageList
end
function NebulatowerPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======NebulatowerPanel:onInit")
	self.fields.scroll:setItemRenderer(handler(self, self.onItemsRender))
	self.fields.scroll:setVirtual()
	self.fields.scroll:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.scollEvent))
	self.fields.Com_title:initData(i18n("nebula_war_text_0152"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btn_tps:addClickEventListener(handler(self, self.onClickTps))
	self.fields.Button_add:addClickEventListener(handler(self, self.onClickAddPage))
	self.fields.Button_min:addClickEventListener(handler(self, self.onClickMinPage))
	self.fields.text_next_lv:setString(i18n("nebula_war_text_0154"))
	self.fields.text_now_lv:setString(i18n("nebula_war_text_0154"))
	self.fields.Button_serverLv:addClickEventListener(handler(self, self.onClickBtnServerLv))
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local areaName = nebulaWarRead.getAreaName(regionId)
	self.fields.Text_region:setString(string.format("%s--%s", i18n("nebula_war_text_0140"), areaName))
	_ENV = string.format("%s--%s", i18n("nebula_war_text_0140"), areaName)
	string.format("%s--%s", i18n("nebula_war_text_0140"), areaName).name = areaName
	self.fields.text_tips:setString(i18n("nebula_war_text_0153", string.format("%s--%s", i18n("nebula_war_text_0140"), areaName)))
	nebulaActivityCtrl:reqTowerInit()
end
function NebulatowerPanel:onShow()
	print("=======NebulatowerPanel:onShow")
	self.realMaxLv = nebulaTowerLvDesRead.getMaxLevel()
	self:updateView()
end
function NebulatowerPanel:updateView()
	self.towerLv = nebulaActivityCtrl:getTowerLv()
	self.maxLv = self.towerLv >= self.realMaxLv and self.realMaxLv - 1 or self.towerLv
	self.pageCount = self.towerLv >= self.realMaxLv and self.maxLv or self.maxLv + 1
	self.fields.scroll:setNumItems(self.maxLv + 1)
	self.fields.progress_exp:setData()
	self.fields.Button_serverLv:setString(self.towerLv)
	self.curPage = self.maxLv
	self:updateCurPage()
end
function NebulatowerPanel:updateCurPage(...)
	self.fields.scroll:scrollToView(SoraDFIsRA() and self.maxLv - self.curPage or self.curPage)
	self:updateCurMsg()
end
function NebulatowerPanel:updateCurMsg()
	dump(self.curPage, "self.curPage")
	local slv, blv = nebulaTowerLvDesRead.getLookCurLv(self.curPage)
	self.fields.text_now:setString(slv)
	self.fields.text_next:setString(blv)
	self.fields.Button_add:setVisible(self.curPage < self.maxLv)
	self.fields.Button_min:setVisible(self.curPage > 0)
end
function NebulatowerPanel:onItemsRender(index, obj)
	local level = index
	if SoraDFIsRA() then
		level = self.maxLv - index
	end
	obj:setLevel(level)
end
function NebulatowerPanel:scollEvent(...)
	local itemIndex = self.fields.scroll:childIndexToItemIndex(0)
	self.curPage = itemIndex
	self.curPage = itemIndex
	if SoraDFIsRA() then
		self.curPage = self.maxLv - itemIndex
	end
	self:updateCurMsg()
end
function NebulatowerPanel:onClickTps()
	SoraDPlaySound()
	_ENV = nil
	;(nil).logType = gKingdomLevelLogType.LOG_EVENTS
	;(nil).isActOpen = false
	;(nil).isTower = true
	uiManager:show("WorldKingdomLvLog", nil)
end
function NebulatowerPanel:onClickBtnServerLv(...)
	SoraDPlaySound()
	if self.towerLv == self.curPage then
		return
	end
	self.curPage = self.towerLv
	self:updateCurPage()
end
function NebulatowerPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEBULA_AREA_ROS)
	end
end
function NebulatowerPanel:onClickAddPage()
	SoraDPlaySound()
	print("onClickAddPage")
	local nextPage = self.curPage + 1
	if nextPage <= self.maxLv then
		self.fields.scroll:scrollToView(SoraDFIsRA() and self.maxLv - nextPage or nextPage, true)
	end
end
function NebulatowerPanel:onClickMinPage()
	SoraDPlaySound()
	print("onClickMinPage")
	local nextPage = self.curPage - 1
	if 0 <= nextPage then
		self.fields.scroll:scrollToView(SoraDFIsRA() and self.maxLv - nextPage or nextPage, true)
	end
end
return NebulatowerPanel
