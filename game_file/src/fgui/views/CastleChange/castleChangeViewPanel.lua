local gametop = gModuleMgr.getObject("gametop")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local castleSkinRead = include("castleSkinRead")
local dressltCtrl = include("dressltCtrl")
local chatSkinRead = include("chatSkinRead")
local castleChangeAttrNode = include("castleChangeAttrNode")
local jumpDesRead = include("jumpDesRead")
local itemDesRead = include("itemDesRead")
local troopsHelper = include("troopsHelper")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local castleChangeViewPanel = class("castleChangeViewPanel", baseFguiPanel)
function castleChangeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("castleChangeViewPanel:ctor", self.viewName)
end
function castleChangeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function castleChangeViewPanel:onInit()
	print("=======castleChangeViewPanel:onInit")
	self.needCallBack2SDK = true
	self.sceneType = 1
	self.tab = 1
	self.attrListData, _ENV, self.dressListData, _ENV, self.musicSwitch = print, print, print, print, false
	self.selectData = nil
	self.selectTimeData = nil
	self.timeIndex = 1
	self.groupId = 0
	self.activeType = 1
	self.changeSwitch = false
	_ENV = "=======castleChangeViewPanel:onInit"
	;("=======castleChangeViewPanel:onInit").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======castleChangeViewPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_1798"), handler(self, self.onClickClose))
	self.fields.Button_illustrated:setString(i18n("skin_text_11"))
	self.fields.Button_illustrated:addClickListener(handler(self, self.btnIllustratedClick))
	self.fields.Button_set:setString(i18n("common_text_713"))
	self.fields.Button_set:addClickListener(handler(self, self.btnSetClickCallBack))
	self.fields.Button_jump:setString(i18n("skin_text_26"))
	self.fields.Button_jump:addClickListener(handler(self, self.btnJumpClickCallBack))
	self.fields.btn_test:setString(i18n("#神兽测试"))
	self.fields.btn_test:addClickListener(handler(self, self.onDivineBeastTestClick))
	self.fields.Button_musicSet:setString(i18n("common_text_4710"))
	self.fields.Button_musicSet:addClickListener(handler(self, self.btnMusicSetClick))
	self.fields.Button_musicSet:setVisible(false)
	self.fields.text_attr_tip:setString(i18n("skin_text_03"))
	self.fields.ScrollView_castle:setVirtual()
	self.fields.ScrollView_castle:setItemRenderer(handler(self, self.onItemRenderer))
	self.nodeHead = include("chatHeadNode").new()
	self.nodeHead:setScale(0.8)
	self.nodeHead.imgPlayer:setScale(1.1)
	self.fields.nodeHead:setContent(self.nodeHead)
	self.nodeBubble = include("chatTextNode").new()
	self.nodeBubble:setMaxtextw(160)
	self.fields.nodeBubble:setContent(self.nodeBubble)
	self.fields.ScrollView_Attr:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.ScrollView_TimeTypeChoose:setItemRenderer(handler(self, self.onTimeTypeRenderer))
	self.fields.btn_filter:addClickListener(handler(self, self.btnFilterClick))
	self.fields.Button_buy:setString(i18n("common_text_282"))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClickCallBack))
	self.fields.Button_Source:setString(i18n("common_text_477"))
	self.fields.Button_Source:addClickListener(handler(self, self.btnSourceClick))
	self.fields.Button_use:setString(i18n("common_btn_05"))
	self.fields.Button_use:addClickListener(handler(self, self.btnUseItemClickCallBack))
	self.fields.Button_active:setString(i18n("common_text_1798"))
	self.fields.Button_active:addClickListener(handler(self, self.btnActiveDressClickCallBack))
	self.fields.Button_move:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onInClick))
	self.fields.Button_move:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
	self.fields.worldCastle:setVisible(false)
	self.fields.nodeHead:fixPos()
	self.fields.nodeBubble:fixPos()
	self.nodeBubble:setPositionX(SoraDFIsRA() and 0 or -240)
	self.fields.btn_test:setVisible(device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop())
end
function castleChangeViewPanel:onItemRenderer(index, obj)
	obj:initData(self.dressListData[index + 1], self.selectData)
end
function castleChangeViewPanel:onAttrRenderer(index, obj)
	obj:initData(self.attrListData[index + 1])
end
function castleChangeViewPanel:onTimeTypeRenderer(index, obj)
	obj:initData(self.dropData[index + 1], self.timeIndex, index + 1)
end
function castleChangeViewPanel:getCurSubData()
	local _ENV, subData
	for k, v in ipairs(self.dressListData) do
		if v.subType == self.selectData.subType then
			subData, _ENV = v.shopData, v.shopData
			subData = v.ownData or v.shopData or nil
			break
		end
	end
	return subData
end
function castleChangeViewPanel:updateDropDown()
	local subType = self.selectData.subType
	local subData = self:getCurSubData()
	dump(self.selectData, "self.selectData=======", 20)
	dump(subData, "subData=======", 20)
	self.activeType = 1
	local curDressID = dressCtrl:getCurDressID(self.tab)
	if dressCtrl:isClassic(self.selectData.dressID) then
		if self:isCurActive(subData) then
			self.fields.Button_active:setString(i18n("dress_text_229"))
			self.fields.Button_active:setBright(false)
		else
			self.fields.Button_active:setString(i18n("common_text_1798"))
			self.fields.Button_active:setBright(true)
		end
		self.controllers.c2:setSelectedIndex(3)
	else
		self.fields.Button_active:setString(i18n("common_text_1798"))
		self.fields.Button_active:setBright(true)
		print("是否拥有=========", self:isOwnDress(subData))
		if self:isOwnDress(subData) then
			print("是否激活=========", self:isCurActive(subData))
			if self:isCurActive(subData) then
				self.fields.Button_active:setString(i18n("dress_text_229"))
				self.fields.Button_active:setBright(false)
				if self:isForeverActive() then
					self.controllers.c2:setSelectedIndex(3)
				elseif self:hasAnyItem(subData) then
					self.controllers.c2:setSelectedIndex(2)
				else
					self.controllers.c2:setSelectedIndex(3)
				end
			else
				print("是否永久=========", self:isForeverActive())
				if self:isForeverActive() then
					self.controllers.c2:setSelectedIndex(3)
				elseif self:hasAnyItem(subData) then
					self.controllers.c2:setSelectedIndex(1)
					self.fields.Button_active:setString(i18n("common_text_1798"))
					self.activeType = 1
				else
					self.controllers.c2:setSelectedIndex(3)
				end
			end
		elseif not self:hasAnyItem(subData) then
			local saleGold = self.selectData.saleGold or self.selectData.gold or 0
			if self.selectData.inShop and 0 < saleGold then
				self.controllers.c2:setSelectedIndex(4)
			else
				self.controllers.c2:setSelectedIndex(0)
				local source = castleSkinRead.getSourceBySubType(subType)
				if source and next(source) then
					self.fields.Text_Source:setString(i18n(self:getSourceWayName(source)))
					self.fields.Button_Source:setVisible(true)
				else
					self.fields.Text_Source:setString("")
					self.fields.Button_Source:setVisible(false)
				end
			end
		else
			self.controllers.c2:setSelectedIndex(1)
			self.fields.Button_active:setString(i18n("castle_skin_btn_01"))
			self.activeType = 2
		end
	end
	self:updateTimeTypeNode(subData)
end
function castleChangeViewPanel:isActive()
	local ret = false
	for k, v in ipairs(self:getCurSubData()) do
		if v.active then
			ret = true
			break
		end
	end
	return ret
end
function castleChangeViewPanel:isHold()
	for _, v in ipairs(self:getCurSubData()) do
		if v.isOwn then
			return true
		end
	end
	return false
end
function castleChangeViewPanel:isActiveDress(data)
