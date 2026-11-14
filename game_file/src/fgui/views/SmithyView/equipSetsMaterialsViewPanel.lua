local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
_ENV = "backpackltCtrl"
;("backpackltCtrl").TAB_COMPONE = 1
local ("backpackltCtrl").TAB_DECOMPOSITION, TAB_TYPE = 2, "backpackltCtrl"
local COMPONE_NEED_NUM = 4
local MAX_OPERATE_COUNT = 999
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipSetsMaterialsViewPanel = class("equipSetsMaterialsViewPanel", baseFguiPanel)
function equipSetsMaterialsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipSetsMaterialsViewPanel:ctor", self.viewName)
end
function equipSetsMaterialsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipSetsMaterialsViewPanel:onInit()
	print("=======equipSetsMaterialsViewPanel:onInit")
	self.tableMaterialData, _ENV = print, print
	self.tabType = TAB_TYPE.TAB_COMPONE
	self.selectIndex = 1
	self.maxMaterial = 4
	self.fields.List_source:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_merge:setString(i18n("common_text_1352"))
	self.fields.Btn_merge:addClickListener(handler(self, self.btnMergeClick))
	self.fields.slider:setInpuBoxFixPos()
	self.fields.jh:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.com_arrow:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.source_item:fixPos()
	self.fields.Text_source:fixPos()
	self.fields.target_item:fixPos()
	self.fields.Text_target:fixPos()
end
function equipSetsMaterialsViewPanel:onShow()
	print("=======equipSetsMaterialsViewPanel:onShow")
	self.curMid = self.param.mid
	self.isBase = self.param.isBase
	self:initData()
end
function equipSetsMaterialsViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableMaterialData[index + 1], index + 1, self.curMid, self.tabType)
end
function equipSetsMaterialsViewPanel:selectBack(target, data)
	self.curMid = data.mid
	self.selectIndex = data.index
	self.param.mid = self.curMid
	local isCanDecompose = equipmentltCtrl.isMaterialCanDecompose(self.curMid)
	if isCanDecompose then
		self.controllers.c1:setSelectedIndex(1)
		equipmentltCtrl = 1
		equipmentltCtrl, equipmentltCtrl, (1).defaultClick = nil, self.tabType, self.tabType
		;(nil).title = i18n("common_text_1352")
		equipmentltCtrl, self.tabType[1], (nil).tag = nil, nil, TAB_TYPE.TAB_COMPONE
		;(nil).title = i18n("common_text_1378")
		;(1).tabsetArray, self.tabType[2], (nil).tag = self.tabType, nil, TAB_TYPE.TAB_DECOMPOSITION
		;(1).callback = handler(self, self.onClickTab)
		self.fields.com_TabW:initView(1)
	else
		self.tabType = TAB_TYPE.TAB_COMPONE
		self.controllers.c1:setSelectedIndex(0)
		self:updateView()
	end
end
function equipSetsMaterialsViewPanel:initData(isFromMsg)
	if self.isBase and not isFromMsg then
		local materialID = equipmentltCtrl.getMaterialIDOfMerge(self.param.mid)
		self.curMid = materialID or self.curMid
	end
	local isCanDecompose = equipmentltCtrl.isMaterialCanDecompose(self.curMid)
	if isCanDecompose then
		self.tabType = TAB_TYPE.TAB_COMPONE
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_tips:setString(i18n("suit_text_06"))
		local defaultActionType = equipmentltCtrl.getMaterialActoinType(self.curMid)
		if defaultActionType == gMaterialActionType.DECOMPOSITION then
			self.tabType = TAB_TYPE.TAB_DECOMPOSITION
		end
		equipmentltCtrl = i18n("suit_text_06")
		equipmentltCtrl, equipmentltCtrl, i18n("suit_text_06").defaultClick = i18n("suit_text_06")
		i18n("suit_text_06").title = i18n("common_text_1352")
		equipmentltCtrl, self.tabType[1], i18n("suit_text_06").tag = i18n("suit_text_06")
		i18n("suit_text_06").title = i18n("common_text_1378")
		i18n("suit_text_06").tabsetArray, self.tabType[2], i18n("suit_text_06").tag = self.tabType, i18n("suit_text_06")
		i18n("suit_text_06").callback = handler(self, self.onClickTab)
		self.fields.com_TabW:initView(i18n("suit_text_06"))
	else
		self.tabType = TAB_TYPE.TAB_COMPONE
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_tips:setString(i18n("suit_text_05"))
		self:updateView()
	end
end
function equipSetsMaterialsViewPanel:onClickTab(tag)
	self.tabType = tag
	self:updateView()
end
function equipSetsMaterialsViewPanel:updateView()
	self.fields.Panel_bg:setString(itemDesRead.getName(self.curMid))
	if self.tabType == TAB_TYPE.TAB_COMPONE then
		self.toMid = equipmentltCtrl.getMaterialIDAfterMerge(self.curMid)
		self.srcMid = equipmentltCtrl.getMaterialIDOfMerge(self.curMid)
	else
		self.toMid = equipmentltCtrl.getMaterialIDOfMerge(self.curMid)
		self.srcMid = equipmentltCtrl.getMaterialIDAfterMerge(self.curMid)
	end
	self:updateSource()
	self:updateTarget()
	self.tableMaterialData, itemDesRead = self.updateTarget, self.updateTarget
	local tableM = equipmentltCtrl.getMaterialList(equipmentltCtrl.getMaterialType(self.curMid))
	local index = 1
	for i, v in ipairs(tableM) do
		if self.tabType == TAB_TYPE.TAB_COMPONE then
			local count = backpackCtrl:getItemCount(v)
			itemDesRead = equipmentltCtrl.getMaterialType(self.curMid)
			equipmentltCtrl.getMaterialType(self.curMid).mid = v
			equipmentltCtrl.getMaterialType(self.curMid).num = count
			table.insert(self.tableMaterialData, equipmentltCtrl.getMaterialType(self.curMid))
			if self.curMid == v then
				self.selectIndex = index
			end
			index = index + 1
		elseif self.tabType == TAB_TYPE.TAB_DECOMPOSITION then
			local count = backpackCtrl:getItemCount(v)
			itemDesRead = equipmentltCtrl.getMaterialType(self.curMid)
			equipmentltCtrl.getMaterialType(self.curMid).mid = v
			equipmentltCtrl.getMaterialType(self.curMid).num = count
			table.insert(self.tableMaterialData, equipmentltCtrl.getMaterialType(self.curMid))
			if self.curMid == v then
				self.selectIndex = index
			end
			index = index + 1
		end
	end
	self.fields.List_source:setNumItems(#self.tableMaterialData)
	self.fields.com_arrow:setMode(#self.tableMaterialData - 3)
	if self.tabType == TAB_TYPE.TAB_DECOMPOSITION then
		self.fields.com_arrow:setScaleX(SoraDFIsRA() and -1 or 1)
	else
		self.fields.com_arrow:setScaleX(SoraDFIsRA() and 1 or -1)
	end
	self:updateSliderAndBtn()
end
function equipSetsMaterialsViewPanel:updateSliderAndBtn()
	local curInfo = self.tableMaterialData[self.selectIndex]
	if self.tabType == TAB_TYPE.TAB_COMPONE then
		self.fields.Btn_merge:setString(i18n("common_text_1352"))
		self.fields.Text_tips:setString(i18n("suit_text_05"))
		self.fields.Btn_merge:setEnabled(curInfo.num >= COMPONE_NEED_NUM)
		local toNum = math.min(MAX_OPERATE_COUNT, math.floor(curInfo.num / COMPONE_NEED_NUM))
		TAB_TYPE = math.floor(curInfo.num / COMPONE_NEED_NUM)
		math.floor(curInfo.num / COMPONE_NEED_NUM).maxValue = toNum
		math.floor(curInfo.num / COMPONE_NEED_NUM).minValue = 1
		math.floor(curInfo.num / COMPONE_NEED_NUM).curValue = 1
		self.fields.slider:initData(math.floor(curInfo.num / COMPONE_NEED_NUM))
	else
		self.fields.Btn_merge:setString(i18n("common_text_1378"))
		self.fields.Text_tips:setString(i18n("suit_text_06"))
		self.fields.Btn_merge:setEnabled(curInfo.num > 0)
		local toNum = math.min(MAX_OPERATE_COUNT, curInfo.num)
		TAB_TYPE = i18n("suit_text_06")
		i18n("suit_text_06").maxValue = toNum
		i18n("suit_text_06").minValue = 1
		i18n("suit_text_06").curValue = 1
		self.fields.slider:initData(i18n("suit_text_06"))
	end
end
function equipSetsMaterialsViewPanel:updateSource()
	if self.curMid then
		itemDesRead = nil
		;(nil).id = self.curMid
		self.fields.source_item:initData(nil)
		self.fields.Text_source:setString(itemDesRead.getName(self.curMid))
		self.fields.Text_source:setColor(itemDesRead.getColor(self.curMid))
	end
end
function equipSetsMaterialsViewPanel:updateTarget()
	if self.toMid then
		itemDesRead = nil
		;(nil).id = self.toMid
		self.fields.target_item:initData(nil)
		self.fields.Text_target:setString(itemDesRead.getName(self.toMid))
		self.fields.Text_target:setColor(itemDesRead.getColor(self.toMid))
	end
end
function equipSetsMaterialsViewPanel:btnMergeClick()
	SoraDPlaySound()
	local num = self.fields.slider:getSliderCurValue()
	local curItemName = itemDesRead.getName(self.curMid)
	local toItemName = itemDesRead.getName(self.toMid)
	local curItemNum = num * COMPONE_NEED_NUM
	if self.tabType == TAB_TYPE.TAB_COMPONE then
		local judgeNum = backpackCtrl:getItemCount(self.curMid)
		local itemType = backpackltCtrl:getItemType(self.curMid)
		local quality = backpackltCtrl:getItemQuality(self.curMid)
		if itemType == gItemType.MATERIAL and quality >= gQualityDef.PURPLE and not IS_COMPOUND_ORANGE_MATERIALS and judgeNum >= COMPONE_NEED_NUM then
			_ENV = nil
			_ENV = nil
			;(nil).var1 = curItemNum
			;(nil).var2 = curItemName
			;(nil).var3 = num
			;(nil).var4 = toItemName
			;(nil).content = i18n("equipment_tips_02", nil)
			;(nil).confirmString = i18n("common_text_204")
			;(nil).confirmFunc = function()
				equipmentCtrl:mergeMaterial(self.toMid, num)
			end
			;(nil).remindString = i18n("build_gold_lvup_tips_name")
			;(nil).remindFunc = function(bRemind)
				IS_COMPOUND_ORANGE_MATERIALS = bRemind
			end
			uiManager:show("MessageBox", nil)
		elseif itemType == gItemType.REMAKE_MATERIAL and quality >= gQualityDef.PURPLE and not IS_LEVEL_4_WASH_FACE_USED_CONFIRM and judgeNum >= COMPONE_NEED_NUM then
			_ENV = nil
			_ENV = nil
			;(nil).var1 = curItemNum
			;(nil).var2 = curItemName
			;(nil).var3 = num
			;(nil).var4 = toItemName
			;(nil).content = i18n("equipment_tips_02", nil)
			;(nil).confirmString = i18n("common_text_204")
			;(nil).confirmFunc = function()
				equipmentCtrl:mergeMaterial(self.toMid, num)
			end
			;(nil).remindString = i18n("build_gold_lvup_tips_name")
			;(nil).remindFunc = function(bRemind)
				IS_LEVEL_4_WASH_FACE_USED_CONFIRM = bRemind
			end
			uiManager:show("MessageBox", nil)
		else
			equipmentCtrl:mergeMaterial(self.toMid, num)
		end
	else
		equipmentCtrl:disassembleMaterial(self.curMid, num)
	end
end
return equipSetsMaterialsViewPanel
