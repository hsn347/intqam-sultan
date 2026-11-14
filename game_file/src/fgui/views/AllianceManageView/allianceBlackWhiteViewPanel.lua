local allianceBWList = SoraDGetCtrl("allianceBWList")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceBlackWhiteViewPanel = class("allianceBlackWhiteViewPanel", baseFguiPanel)
function allianceBlackWhiteViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceBlackWhiteViewPanel:ctor", self.viewName)
end
function allianceBlackWhiteViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceBlackWhiteViewPanel:onInit()
	print("=======allianceBlackWhiteViewPanel:onInit")
	self.tableItemList, _ENV, self.curType = gAllianceBWListType.BLACK, gAllianceBWListType.BLACK, gAllianceBWListType.BLACK
	self.fields.Com_title:initData(i18n("common_text_1678"), handler(self, self.onClickClose))
	self.fields.Text_type:setString(i18n("common_text_032"))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClickCallBack))
	self.fields.Button_jump:addClickListener(handler(self, self.btnJumpClickCallBack))
	self.fields.Button_add:addClickListener(handler(self, self.btnAddClickCallBack))
	self.fields.Text_notice:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Text_type:fixPos()
	self.fields.Text_point:fixPos()
	self.fields.Sprite_type:fixPos()
	self.fields.Button_help:fixPos()
end
function allianceBlackWhiteViewPanel:onListRenderer(index, obj)
	obj:initData(self.tableItemList[index + 1], self.curType)
end
function allianceBlackWhiteViewPanel:onShow()
	print("=======allianceBlackWhiteViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	allianceBWList:getAllianceBWDetailList()
	SoraDShowLoading(self)
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.curType, self.curType
	;(nil).title = i18n("common_text_1679")
	_ENV, self.curType[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_1680")
	;(nil).tabsetArray, self.curType[2], (nil).tag = self.curType, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function allianceBlackWhiteViewPanel:onClickTab(tag)
	self.curType = tag
	self:updateView()
end
function allianceBlackWhiteViewPanel:updateView()
	if self.curType == gAllianceBWListType.BLACK then
		self.tableItemList = allianceBWList.bwDetailList.blackList
		self.fields.Text_notice:setString(i18n("common_text_1681"))
		_ENV = i18n("common_text_1681")
		i18n("common_text_1681").list = i18n("common_text_1679")
		self.fields.Button_add:setString(i18n("common_text_1687", i18n("common_text_1681")))
		self.fields.Button_add:setBtnColorIndex(0)
	else
		self.tableItemList = allianceBWList.bwDetailList.whiteList
		self.fields.Text_notice:setString(i18n("common_text_1682"))
		_ENV = i18n("common_text_1682")
		i18n("common_text_1682").list = i18n("common_text_1680")
		self.fields.Button_add:setString(i18n("common_text_1687", i18n("common_text_1682")))
		self.fields.Button_add:setBtnColorIndex(1)
	end
	self.fields.Text_notice:setVisible(#self.tableItemList <= 0)
	self.fields.List:setNumItems(#self.tableItemList)
	self:updatePoint()
end
function allianceBlackWhiteViewPanel:updateScrollWithData(target, data)
	SoraDCloseLoading(self)
	self:updateView()
end
function allianceBlackWhiteViewPanel:updateData(target, data)
	if data.bwtype == self.curType then
		allianceBWList:getAllianceBWDetailList()
	end
	self:updatePoint()
end
function allianceBlackWhiteViewPanel:updatePoint(target, data)
	self.fields.Button_add:setCostTitle(string.formatnumberthousands(allianceBWList:getScoreCost(self.curType)))
	self.fields.Text_point:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
end
function allianceBlackWhiteViewPanel:btnHelpClickCallBack()
	SoraDPlaySound()
	uiManager:show("allianceBlackWhiteHelpView")
end
function allianceBlackWhiteViewPanel:btnJumpClickCallBack()
	SoraDPlaySound()
	if GLOBAL_GAME_ALLIANCE_MODE then
		uiManager:show("AllianceScience")
	else
		SoraDCreatePanel("allianceScienceView"):show()
	end
end
function allianceBlackWhiteViewPanel:btnAddClickCallBack()
	SoraDPlaySound()
	local needPoint = allianceBWList:getScoreCost(self.curType)
	if needPoint > allianceMgr:getAllianceProperty("bonus") then
		SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("AllianceScience")
				else
					SoraDCreatePanel("allianceScienceView"):show()
				end
			end
		end)
	else
		uiManager:show("AllianceJoinView")
	end
end
return allianceBlackWhiteViewPanel
