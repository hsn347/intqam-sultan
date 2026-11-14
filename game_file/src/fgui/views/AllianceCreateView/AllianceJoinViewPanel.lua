local allianceQuery = SoraDGetCtrl("allianceQuery")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceJoinViewPanel = class("AllianceJoinViewPanel", baseFguiPanel)
function AllianceJoinViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceJoinViewPanel:ctor", self.viewName)
	self.allianceListData, _ENV = print, print
	self.isHideCurrentSceneView = true
end
function AllianceJoinViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceJoinViewPanel:onInit()
	print("=======AllianceJoinViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_167"), handler(self, self.onClickClose))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClickCallBack))
	self.fields.Button_searchKOH:setString(i18n("common_text_166"))
	self.fields.Button_searchKOH:addClickListener(handler(self, self.btnSearchClickCallBack))
	self.fields.Button_options:setString(i18n("common_text_718"))
	self.fields.Button_options:addClickListener(handler(self, self.btnOptionClickCallBack))
	self.fields.Button_create:setString(i18n("common_text_168"))
	self.fields.Button_create:addClickListener(handler(self, self.btnCreateClickCallBack))
	self.fields.Button_refresh:setString(i18n("notice_0208"))
	self.fields.Button_refresh:addClickListener(handler(self, self.btnRefreshClickCallBack))
	self:updateCreateBtn()
	self.fields.Input_search:setMaxLength(20)
	self.fields.Input_search:setAlign(SoraDFLabelR())
	self.fields.List_alliance:setItemRenderer(handler(self, self.onAllianceItemRenderer))
	self.fields.List_alliance:setVirtual()
	self.fields.List_alliance:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScroll))
	self.fields.List_alliance:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List_alliance:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchBegin))
	self.fields.List_alliance:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	self.fields.Text_noData:setString(i18n("common_text_4551"))
	self.fields.Text_noData:setVisible(false)
	self.scrollInner = self.fields.List_alliance:getScrollPane()
	self.scrollFooter = self.scrollInner:getFooter()
	self.scrollFooter:setString(i18n("common_text_089"))
	self.scrollInner:lockFooter(50)
end
function AllianceJoinViewPanel:onShow()
	print("=======AllianceJoinViewPanel:onShow", conquestWarCtrl:isHelper())
	self.fields.Com_bg:setGradientColor()
	if conquestWarCtrl:isHelper() then
		self.fields.Button_search:setGrayed(true)
		self.fields.Button_create:setGrayed(true)
		self.fields.Button_options:setGrayed(true)
		allianceQuery:reqKingAlliance()
	else
		allianceQuery:reqAllianceList(gLanguage.ALL)
	end
	self.controllers.c1:setSelectedIndex(IsArClient and 0 or 1)
	_UPVALUE5_ = self.controllers.c1
	self.controllers.c1[1] = "Image_input"
	self.controllers.c1[2] = "Input_search"
	self.controllers.c1[3] = "Button_search"
	self.controllers.c1[4] = "Button_options"
	self.controllers.c1[5] = "Button_searchKOH"
	for i, v in ipairs(self.controllers.c1) do
		self.fields[v]:fixPos()
	end
end
function AllianceJoinViewPanel:endShow(...)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local memberMgr = SoraDGetCtrl("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	if ownmember and ownmember:getProperty("isfirstjoin") and not allianceMgr:hasJoinAlliance() then
		uiManager:show("allianceFirstJoinView")
	end
end
function AllianceJoinViewPanel:updateCreateBtn(...)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if allianceMgr:hasJoinAlliance() then
		self.fields.Button_refresh:setPositionX(self:getWidth() / 2)
		self.fields.Button_create:setVisible(false)
		return
	end
	local c_free = self.fields.Button_create:getController("c_free")
	if SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
		c_free:setSelectedIndex(0)
		local Text_free = self.fields.Button_create:getChild("Text_free")
		Text_free:setString(i18n("common_text_049"))
	else
		c_free:setSelectedIndex(1)
		local Text_gold = self.fields.Button_create:getChild("Text_gold")
		_ENV = i18n("common_text_049")
		i18n("common_text_049").lv = CASTLE_LV6_LIMITED
		_ENV = i18n("common_text_049")
		i18n("common_text_049").color = "#ffff00"
		local str = i18n("common_text_169", i18n("common_text_049")) .. "/" .. SoraDWrapHtmlTagByStyle(gConstValue.ALLIANCE_CREATE_ALLIANCE_GOLD, i18n("common_text_049"))
		Text_gold:setString(str)
	end
end
function AllianceJoinViewPanel:btnSearchClickCallBack(...)
	SoraDPlaySound()
	if conquestWarCtrl:isHelper() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	local keyname = self.fields.Input_search:getText()
	if not keyname or type(keyname) ~= "string" or string.utf8len(keyname) <= 0 then
		return
	else
		allianceQuery:reqAllianceByName(keyname)
		SoraDShowLoading(self:displayObject())
	end
end
function AllianceJoinViewPanel:btnOptionClickCallBack()
	SoraDPlaySound()
	if conquestWarCtrl:isHelper() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	uiManager:show("allianceOptionsView")
end
function AllianceJoinViewPanel:btnCreateClickCallBack(...)
	SoraDPlaySound()
	if worldMapDefine.isInGarden() or worldMapDefine.isInGardenCity() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	if conquestWarCtrl:isHelper() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	uiManager:show("allianceCreateView")
end
function AllianceJoinViewPanel:btnRefreshClickCallBack(...)
	SoraDPlaySound()
	self.scrollInner:lockFooter(50)
	self.fields.List_alliance:scrollToView(0)
	self.allianceListData, _ENV = self.fields.List_alliance.scrollToView, self.fields.List_alliance.scrollToView
	self.fields.Input_search:setText("")
	if conquestWarCtrl:isHelper() then
		allianceQuery:reqKingAlliance()
	else
		allianceQuery:reqAllianceList(gLanguage.ALL)
	end
end
function AllianceJoinViewPanel:onAllianceItemRenderer(index, obj)
	local alliance = self.allianceListData[index + 1]
	obj:initData(alliance)
end
function AllianceJoinViewPanel:onScroll(...)
	if not self.haveMore then
		return
	end
	if not self._isTouch then
		return
	end
	if self.scrollInner:getPercY() >= 1 then
		if self.scrollFooter:getContentSize().height > 50 then
			self.scrollFooter:setString(i18n("common_text_084"))
		else
			self.scrollFooter:setString(i18n("common_text_089"))
		end
	end
end
function AllianceJoinViewPanel:onPullUpRelease(...)
	if not self.haveMore then
		return
	end
	if self.scrollFooter:getContentSize().height > 50 then
		allianceQuery:reqAllianceListByIndex(gLanguage.ALL, #self.allianceListData + 1)
		SoraDShowLoading(self:displayObject())
	end
end
function AllianceJoinViewPanel:onTouchBegin(EventContext)
	local InputEvent = EventContext:getInput()
	if InputEvent and InputEvent:getTouchId() == 0 then
		self._isTouch = true
	end
end
function AllianceJoinViewPanel:onTouchEnd(EventContext)
	local InputEvent = EventContext:getInput()
	if InputEvent and InputEvent:getTouchId() == 0 then
		self._isTouch = false
	end
end
function AllianceJoinViewPanel:refreshAllianceList(target, data)
	SoraDCloseLoading(self:displayObject())
	local allianceListData, haveMore = allianceQuery:getAllianceList(#self.allianceListData + 1)
	dump(allianceListData, "allianceListData")
	for i, v in ipairs(allianceListData) do
		table.insert(self.allianceListData, v)
	end
	self.haveMore = haveMore
	if not self.haveMore then
		self.scrollFooter:setString("")
		self.scrollInner:lockFooter(0)
	end
	self.fields.List_alliance:setNumItems(#self.allianceListData)
	self.fields.Text_noData:setVisible(#self.allianceListData <= 0)
end
function AllianceJoinViewPanel:refreshSearchList(target, data)
	SoraDCloseLoading(self:displayObject())
	local allianceSearchListData = allianceQuery:getQueryAllianceResult()
	self.allianceListData = allianceSearchListData
	self.haveMore = false
	self.scrollFooter:setString("")
	self.scrollInner:lockFooter(0)
	self.fields.List_alliance:setNumItems(#self.allianceListData)
	self.fields.Text_noData:setVisible(#self.allianceListData <= 0)
	self.fields.List_alliance:scrollToView(0)
end
return AllianceJoinViewPanel
