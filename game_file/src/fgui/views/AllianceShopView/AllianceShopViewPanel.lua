local gametop = gModuleMgr.getObject("gametop")
local allianceStore = gametop.playertop_:getModule("allianceStore")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceltCtrl = include("allianceltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceShopViewPanel = class("AllianceShopViewPanel", baseFguiPanel)
function AllianceShopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceShopViewPanel:ctor", self.viewName)
end
function AllianceShopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceShopViewPanel:onInit()
	print("=======AllianceShopViewPanel:onInit")
	self.fields.Label_point:fixPos()
	self.fields.Button_help:fixPos()
	self.fields.Label_point:fixChildrenPos()
	self.tableItemList, _ENV, self.curType = gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR, gIDDef.ALLIANCE_HONOR
	self.fields.Com_title:initData(i18n("common_text_192"), handler(self, self.onClickClose))
	self.fields.Button_log:addClickListener(handler(self, self.btnLogClickCallBack))
	self.fields.Button_log:setString(i18n("common_text_836"))
	self.fields.Text_notice:setString(i18n("common_text_930"))
	self.fields.Button_help:addClickListener(handler(self, self.btnHelpClickCallBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	_ENV = handler(self, self.onItemRederer)
	_ENV, _ENV, handler(self, self.onItemRederer).defaultClick = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).title = i18n("common_text_192")
	_ENV, handler(self, self.onItemRederer)[1], handler(self, self.onItemRederer).tag = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).title = i18n("allianceshop_btn_02")
	handler(self, self.onItemRederer).tabsetArray, handler(self, self.onItemRederer)[2], handler(self, self.onItemRederer).tag = handler(self, self.onItemRederer)
	handler(self, self.onItemRederer).callback = handler(self, self.onClickTag)
	self.fields.Com_tab:initView(handler(self, self.onItemRederer))
	SoraDShowLoading()
end
function AllianceShopViewPanel:onShow()
	print("=======AllianceShopViewPanel:onShow")
end
function AllianceShopViewPanel:onItemRederer(index, target)
	target:initData(self.curType, self.tableItemList[index + 1])
end
function AllianceShopViewPanel:onClickTag(tag)
	self.curType = tag
	self:updateScrollWithData()
end
function AllianceShopViewPanel:updatePoint()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.curPoint = memberMgr:getOwnMember():getProperty("playerHonor")
		self.fields.Label_point:getChild("Text_type"):setString(i18n("common_text_266"))
		self.fields.Label_point:setIcon("icon_alliance_honor.png")
	else
		self.curPoint = allianceMgr:getAllianceProperty("bonus")
		self.fields.Label_point:getChild("Text_type"):setString(i18n("common_text_032"))
		self.fields.Label_point:setIcon("icon_alliance_point.png")
	end
	self.fields.Label_point:setString(string.formatnumberthousands(self.curPoint))
end
function AllianceShopViewPanel:updateScrollWithData()
	self:updatePoint()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		self.tableItemList = allianceStore:getItemList()
	else
		self.tableItemList = allianceStore:getShopList()
	end
	self.fields.Text_notice:setVisible(#self.tableItemList <= 0)
	self.fields.List:setNumItems(#self.tableItemList)
	self.fields.List:jumpToTop()
	SoraDCloseLoading()
end
function AllianceShopViewPanel:btnHelpClickCallBack()
	SoraDPlaySound()
	if self.curType == gIDDef.ALLIANCE_HONOR then
		_UPVALUE1_ = "common_text_266"
		;("common_text_266")[1] = i18n("common_text_658")
		;("common_text_266")[2] = i18n("common_text_659")
		;("common_text_266")[3] = i18n("common_text_659")
		;("common_text_266")[4] = i18n("common_text_659")
		SoraDShowFixWindow(i18n("common_text_266"), "common_text_266", cc.c3b(215, 195, 155))
	else
		_UPVALUE1_ = "common_text_032"
		;("common_text_032")[1] = i18n("common_text_274")
		;("common_text_032")[2] = i18n("common_text_275")
		;("common_text_032")[3] = i18n("common_text_275")
		;("common_text_032")[4] = i18n("common_text_275")
		SoraDShowFixWindow(i18n("common_text_032"), "common_text_032", cc.c3b(215, 195, 155))
	end
end
function AllianceShopViewPanel:btnLogClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).curType = self.curType
	uiManager:show("AllianceShopLogView", nil)
end
function AllianceShopViewPanel:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	else
		allianceStore:reqAllianceItemStoreData()
	end
end
return AllianceShopViewPanel
