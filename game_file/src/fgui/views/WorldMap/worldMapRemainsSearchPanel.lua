local findMonsterCtrl = SoraDGetCtrl("findMonsterCtrl")
local remainsWarCtrl = SoraDGetCtrl("remainsWarCtrl")
local remainsWarUtil = include("remainsWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local worldMapRemainsSearchPanel = class("worldMapRemainsSearchPanel", baseFguiPanel)
function worldMapRemainsSearchPanel:ctor(...)
	worldMapRemainsSearchPanel.super.ctor(self, ...)
	print("worldMapRemainsSearchPanel:ctor", self.viewName)
end
function worldMapRemainsSearchPanel:onInit()
	print("=======worldMapRemainsSearchPanel:onInit")
	self.targetList, _ENV = print, print
	self.selIndex = 1
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.btn_left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.btn_right:addClickListener(handler(self, self.btnRightClick))
end
function worldMapRemainsSearchPanel:onItemRenderer(index, obj)
	obj:setIcon(self.targetList[index + 1].icon)
	obj:setSelected(index + 1 == self.selIndex)
end
function worldMapRemainsSearchPanel:onChooseItem()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self:updateView()
end
function worldMapRemainsSearchPanel:onShow()
	print("=======worldMapRemainsSearchPanel:onShow")
	_ENV, _ENV = "=======worldMapRemainsSearchPanel:onShow", print
	;("=======worldMapRemainsSearchPanel:onShow").icon = "btn_search_yiji.png"
	;("=======worldMapRemainsSearchPanel:onShow").name = i18n("res_name_yiji")
	_ENV, print[1], ("=======worldMapRemainsSearchPanel:onShow").index = "=======worldMapRemainsSearchPanel:onShow", "=======worldMapRemainsSearchPanel:onShow", 1
	;("=======worldMapRemainsSearchPanel:onShow").icon = "btn_search_boss.png"
	;("=======worldMapRemainsSearchPanel:onShow").name = i18n("remains_optimize_text3")
	_ENV, print[2], ("=======worldMapRemainsSearchPanel:onShow").index = "=======worldMapRemainsSearchPanel:onShow", "=======worldMapRemainsSearchPanel:onShow", 2
	;("=======worldMapRemainsSearchPanel:onShow").icon = "btn_search_guard.png"
	;("=======worldMapRemainsSearchPanel:onShow").name = i18n("remains_optimize_text1")
	self.targetList, print[3], ("=======worldMapRemainsSearchPanel:onShow").index = print, "=======worldMapRemainsSearchPanel:onShow", 3
	self:updateView()
end
function worldMapRemainsSearchPanel:updateView()
	self.fields.List:setNumItems(#self.targetList)
	self:setTargetName()
	self:updateBtnLR()
end
function worldMapRemainsSearchPanel:setTargetName()
	self.fields.Text_showName:setString(self.targetList[self.selIndex].name)
end
function worldMapRemainsSearchPanel:msgBackData(target, data)
	SoraDCloseLoading(self)
	if data and data.retdate and (data.retdate.x ~= -1 or data.retdate.y ~= -1) then
		SoraDGotoWorldMapPoint(cc.p(data.retdate.x, data.retdate.y), true)
	else
		SoraDShowMsgTip(i18n("Martial_arts_text_10"))
	end
	self:close()
end
function worldMapRemainsSearchPanel:updateBtnLR()
	self.fields.btn_left:setVisible(self.selIndex > 1)
	self.fields.btn_right:setVisible(self.selIndex < #self.targetList)
end
function worldMapRemainsSearchPanel:btnLeftClick()
	SoraDPlaySound()
	self.selIndex = math.max(1, self.selIndex - 1)
	self:updateView()
end
function worldMapRemainsSearchPanel:btnRightClick()
	SoraDPlaySound()
	self.selIndex = math.min(#self.targetList, self.selIndex + 1)
	self:updateView()
end
function worldMapRemainsSearchPanel:btnGoClick()
	SoraDPlaySound()
	if self.selIndex == 1 then
		SoraDGotoWorldMapPoint(RUINS_POS)
		self:close()
	elseif self.selIndex == 2 then
		local isOpen = remainsWarCtrl:isInWar() and not remainsWarUtil.checkIsInRemainsXianXia()
		local timeMy = remainsWarCtrl:getBossRefreshTime_My()
		local timeZjssg = remainsWarCtrl:getBossRefreshTime_Zjssg()
		if not isOpen then
			SoraDShowMsgTip(i18n("Martial_arts_text_10"))
		elseif 0 < timeMy and 0 < timeZjssg then
			SoraDShowMsgTip(i18n("Martial_arts_text_10"))
		elseif timeMy <= 0 and 0 < timeZjssg then
			SoraDGotoWorldMapPoint(RUINS_BOSS_POS[1])
		elseif 0 < timeMy and timeZjssg <= 0 then
			SoraDGotoWorldMapPoint(RUINS_BOSS_POS[2])
		else
			SoraDGotoWorldMapPoint(RUINS_BOSS_POS[math.random(#RUINS_BOSS_POS)])
		end
		self:close()
	elseif self.selIndex == 3 then
		SoraDShowLoading(self)
		findMonsterCtrl:sendSearchMapType(gWorldTypeServerDef.mapTypeNpc, 1)
	end
end
return worldMapRemainsSearchPanel
