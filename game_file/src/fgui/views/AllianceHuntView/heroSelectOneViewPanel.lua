local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroSelectOneViewPanel = class("heroSelectOneViewPanel", baseFguiPanel)
function heroSelectOneViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("heroSelectOneViewPanel:ctor", self.viewName)
end
function heroSelectOneViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function heroSelectOneViewPanel:onInit()
	print("=======heroSelectOneViewPanel:onInit")
	_ENV = print
	print[gHeroState.HERO_STATE_NORMAL] = true
	print[gHeroState.HERO_STATE_DEAD] = false
	print[gHeroState.HERO_STATE_CAPTURED] = false
	print[gHeroState.HERO_STATE_BATTLE] = true
	print[gHeroState.HERO_STATE_DEFEND] = true
	self.tableSingle, _ENV, self.tableSpare, _ENV, self.stateList, print[gHeroState.HERO_STATE_ESCAPE] = print, print, print, print, print, true
	self.windowTitle = SoraDGetChildByName(self, "Top_Node_info")
	self.windowTitle:initData(i18n("herotrain_title_01"), handler(self, self.onClickClose))
	self.scrollHeros = SoraDGetChildByName(self, "scroll")
	self.scrollHeros:setItemRenderer(handler(self, self.onItemRenderer))
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.btnOk:setTitleText(i18n("common_text_054"))
	self.btnOk:addClickEventListener(handler(self, self.btnOkClick))
	self.txtNoHero = SoraDGetChildByName(self, "Center_Text_Tip")
	self.txtNoHero:setString(i18n("hero_text_71"))
end
function heroSelectOneViewPanel:onShow()
	print("=======heroSelectOneViewPanel:onShow")
end
function heroSelectOneViewPanel:initData(handl, filterList, times)
	self.resultCB = handl
	self.times = times
	self.canSelectHeros = heroCtrl:getHaveHerosIDNumList()
	dump(self.canSelectHeros, "self.canSelectHeros", 10)
	dump(filterList, "filterList")
	local heroCtrl, newCanSelectHeros = dump, dump
	for _, v in ipairs(self.canSelectHeros) do
		if filterList[v] or filterList[tostring(v)] then
		else
			table.insert(newCanSelectHeros, v)
		end
	end
	self.canSelectHeros = newCanSelectHeros
	self:initView()
	local selectHeroID = self.canSelectHeros[1]
	if self:judgeCanBeSelected(selectHeroID) then
		self:selectHeroClick(selectHeroID)
		self.selectHeroID = selectHeroID
	end
end
function heroSelectOneViewPanel:sMsgHeroStateChanged(target, data)
	dump(data, "heroSelectOneViewPanel:sMsgHeroStateChanged(target, data)", 10)
	local heroID = data.heroID
	local isCancel = false
	if self.selectHeroID and self.selectHeroID == heroID and not self:judgeCanBeSelected(heroID) then
		self.selectHeroID = nil
		self:cancelHeroClick()
		isCancel = true
	end
	self:prepareScrollData()
	if not isCancel and self.selectHeroID then
		self:selectHeroClick(self.selectHeroID)
	end
end
function heroSelectOneViewPanel:judgeCanBeSelected(heroID)
	if heroCtrl:judgeHeroInStates(heroID, self.stateList) then
		local heroInfo = heroCtrl:getHeroInfoByID(heroID)
		return heroInfo.state
	end
end
function heroSelectOneViewPanel:getCanSelectHeros()
	return self.canSelectHeros
end
function heroSelectOneViewPanel:getCanReallySelectHeros()
	local _ENV, ret
	for i, v in ipairs(self.canSelectHeros) do
		if self:judgeCanBeSelected(v) then
			table.insert(ret, v)
		end
	end
	return ret
end
function heroSelectOneViewPanel:initView(...)
	self.txtNoHero:setVisible(not next(self.canSelectHeros))
	self:prepareScrollData()
end
function heroSelectOneViewPanel:setBannerTitle(str)
	self.windowTitle:setTitle(str)
end
function heroSelectOneViewPanel:setBottomTip(str)
	self.txtTip:setString(str)
end
function heroSelectOneViewPanel:setFilteHeroState(states)
	self.stateList = states
end
function heroSelectOneViewPanel:btnOkClick(button, eventType)
	if self.resultCB then
		self.resultCB(self.selectHeroID, self.times)
	end
end
function heroSelectOneViewPanel:cancelHeroClick(heroID)
	print("heroID=", heroID)
	for i, v in ipairs(self.tableSingle) do
		v.check = false
		if v.point then
			print("取消选中----")
			v.point:setMeCheck(false)
		end
		self.selectHeroID = nil
	end
end
function heroSelectOneViewPanel:selectHeroClick(heroID)
	print("heroID=", heroID)
	for i, v in ipairs(self.tableSingle) do
		if v.data == heroID then
			v.check = true
			if v.point then
				print("选择了")
				v.point:setMeCheck(true)
			end
			self.selectHeroID = heroID
		else
			v.check = false
			if v.point then
				v.point:setMeCheck(false)
			end
		end
	end
end
function heroSelectOneViewPanel:prepareScrollData(...)
	heroCtrl:sortHuntHerosID(self.canSelectHeros, self.stateList)
	for i, v in ipairs(self.canSelectHeros) do
		heroCtrl = nil
		self.tableSingle[i], (nil).data = nil, v
	end
	self:initScrollList()
end
function heroSelectOneViewPanel:onItemRenderer(index, single)
	local v = self.tableSingle[index + 1]
	single:setClickCallBack(handler(self, self.selectHeroClick))
	single:setCancelLightBack(handler(self, self.cancelHeroClick))
	single:setFilteHeroState(self.stateList)
	single:initData(v.data)
	single:setMeCheck(not not v.check)
	v.point = single
end
function heroSelectOneViewPanel:initScrollList(...)
	self.scrollHeros:setNumItems(#self.tableSingle)
end
return heroSelectOneViewPanel
