local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainInfo", WarGemMainInfo)
function WarGemMainInfo:onInit()
	self.fields.Button_reset:fixPos()
	self.fields.Button_attr:fixPos()
	self.fields.Button_combo:fixPos()
	self.fields.Button_combo1:fixPos()
	self.fields.Button_rename:fixPos()
	self.fields.Button_attr:setString(i18n("gemEnchant_text_01"))
	self.fields.Button_reset:setString(i18n("gemEnchant_text_66"))
	self.fields.Button_active:setString(i18n("common_btn_05"))
	self.fields.Button_rename:addClickListener(handler(self, self.onClickRename))
	self.fields.Button_combo:addClickListener(handler(self, self.onClickCombo))
	self.fields.Button_combo1:addClickListener(handler(self, self.onClickCombo))
	self.fields.ComboList:setCallback(handler(self, self.onComboCallback))
	self.fields.Button_attr:addClickListener(handler(self, self.onClickAttr))
	self.fields.Button_reset:addClickListener(handler(self, self.onClickReset))
	self.fields.Button_active:addClickListener(handler(self, self.onClickActive))
end
function WarGemMainInfo:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA", handler(self, self.onWarGemData))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_INLAY", handler(self, self.onWarGemInlay))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_RESET", handler(self, self.onWarGemInlay))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_COPY", handler(self, self.onWarGemInlay))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_DATA_BAG", handler(self, self.onWarGemBag))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateCombo))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_REFREASH_ENCHANTED", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_RENAME", handler(self, self.onComboRename))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_MOUNT_RSP", handler(self, self.onInlayRsp))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_CHANGE_COLOR", handler(self, self.onChangeColorRsp))
end
function WarGemMainInfo:onWarGemData()
	SoraDCloseLoading(self.panel:displayObject())
	self:updateView()
end
function WarGemMainInfo:onWarGemInlay(data)
	SoraDCloseLoading(self.panel:displayObject())
	self:updateView()
end
function WarGemMainInfo:onWarGemBag()
	SoraDCloseLoading(self.panel:displayObject())
	self:updateView()
end
function WarGemMainInfo:onChangeColorRsp(target, data)
	self:updateView()
	self:showChangeColorEffect(data.lv, data.idx)
end
function WarGemMainInfo:onInlayRsp(target, data)
	self:showInlayEffect(data.lv, data.idx)
end
function WarGemMainInfo:onComboRename()
	SoraDCloseLoading(self.panel:displayObject())
	self:updateCombo()
end
function WarGemMainInfo:onClickRename()
	SoraDPlaySound()
	local tag = self.curIndex
	if warGemCtrl:checkVip(tag, true) then
		_ENV = true
		;(true).setID = tag
		;(true).renameType = 3
		uiManager:show("lordEquipRename", true)
	end
end
function WarGemMainInfo:onClickAttr()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.curIndex
	uiManager:show("WarGemTotalInfo", nil)
end
function WarGemMainInfo:onClickReset()
	SoraDPlaySound()
	uiManager:show("WarGemQuickSet")
end
function WarGemMainInfo:onClickActive()
	SoraDPlaySound()
	if warGemCtrl:checkVip(self.curIndex, true) then
		local tipsID = "gem_text_02"
		if self:isHasEmptyPanel() then
			tipsID = "gem_text_01"
		end
		SoraDShowMsgBox(i18n(tipsID), i18n("common_text_204"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				local dismountCost = self:getActivePanelCost()
				if not self:checkEnough(RESBUYVIEW_TYPE.WAR_GEM_REPLACE) then
					return
				else
					warGemCtrl:reqActivePanel(self.curIndex)
				end
			end
		end)
	end
end
function WarGemMainInfo:checkEnough(buyViewType)
	local dismountCost = self:getActivePanelCost()
	if not SoraDEnoughRes(gIDDef.MITHRIL, dismountCost) then
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local curRes = cityCtrl:getResCount(gIDDef.MITHRIL)
		local _ENV, shortList = cityCtrl, cityCtrl
		local _ENV, data = gIDDef.MITHRIL, gIDDef.MITHRIL
		data.resid = gIDDef.MITHRIL
		data.curcount = curRes
		data.rescount = dismountCost - data.curcount
		table.insert(shortList, data)
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(shortList) then
			uiManager:show("CommonQuicklyadd")
		else
			local resToGold = serviceFunctions.resConvertToGold(gIDDef.MITHRIL, math.max(0, data.rescount))
			_ENV, _ENV = math.max(0, data.rescount)
			_ENV, warGemCtrl, math.max(0, data.rescount).resToGold = math.max(0, data.rescount)
			math.max(0, data.rescount).resid = gIDDef.MITHRIL
			math.max(0, data.rescount).rescount = data.rescount
			math.max(0, data.rescount).needResData, math.max(0, data.rescount).retCostRes, math.max(0, data.rescount)[1] = math.max(0, data.rescount)
			math.max(0, data.rescount).viewType = buyViewType
			math.max(0, data.rescount).handle = function()
				warGemCtrl:reqActivePanel(self.curIndex)
			end
			uiManager:show("buildCreateResBuy", math.max(0, data.rescount))
		end
		return false
	end
	return true
end
function WarGemMainInfo:onComboCallback(index)
	warGemCtrl:setEditPanelId(index)
	self:updateView()
end
function WarGemMainInfo:onClickCombo()
	print("onClickCombo!!!!!")
	SoraDPlaySound()
	if not self.fields.ComboList:isVisible() then
		print("show!!!")
		self.fields.ComboList:setVisible(true)
		self.fields.ComboList:initData()
	else
		print("hide!!!")
		self.fields.ComboList:setVisible(false)
	end
end
function WarGemMainInfo:hideCombo(touchTarget)
	print("touchTarget", touchTarget and touchTarget.name)
	if touchTarget == self.fields.Button_combo or touchTarget == self.fields.Button_combo1 or touchTarget == self.fields.ComboList or touchTarget and touchTarget:getParent() == self.fields.ComboList or touchTarget and touchTarget:getParent() and touchTarget:getParent():getParent() == self.fields.ComboList then
		return
	end
	print("hide##@@@@", touchTarget.name, touchTarget, self.fields.Button_combo1)
	self.fields.ComboList:setVisible(false)
end
function WarGemMainInfo:onShow()
	print("=======WarGemMainInfo:onShow！！！！！！！！")
end
function WarGemMainInfo:setPanel(panel)
	self.panel = panel
end
function WarGemMainInfo:updateView()
	self:updateCombo()
	self.fields.Content:updateView()
end
function WarGemMainInfo:updateCombo()
	self.isActive = warGemCtrl:isCurPanelActive()
	local comboName = combinationCtrl:getSetName(combinationCtrl.COMBINATION_TYPE.WARGEM, warGemCtrl:getEditPanelId())
	self.fields.Button_combo:setString(comboName)
	self.curIndex = warGemCtrl:getEditPanelId()
	self.tableData = warGemCtrl:getGemPanel(self.curIndex)
	self:updateBtn()
end
function WarGemMainInfo:updateBtn()
	self.controllers.c1:setSelectedIndex(self.isActive and 0 or 1)
	if not self.isActive then
		local cost = self:getActivePanelCost()
		self.fields.Button_active:setCost(gIDDef.MITHRIL, cost)
	end
end
function WarGemMainInfo:getActivePanelCost()
	local const = warGemCtrl:getActivePanelCost(self.curIndex)
	if const and const[gIDDef.MITHRIL] then
		return -const[gIDDef.MITHRIL]
	end
	return 0
end
function WarGemMainInfo:isHasEmptyPanel()
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.MIRACLE)
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(curLevel)
	local placeNum = warGemltCtrl:getStonePlaceNum()
	local lv
	for i = 1, placeNum do
		lv = warGemltCtrl:getStonePlaceLv(i)
		if warLv < lv then
			break
		end
		for idx = 1, 3 do
			if self.tableData[tostring(lv)] and 0 == self.tableData[tostring(lv)][idx] then
				return true
			end
		end
	end
end
function WarGemMainInfo:showChangeColorEffect(lv, idx)
	self.fields.Content:showChangeColorEffect(lv, idx)
end
function WarGemMainInfo:showInlayEffect(lv, idx)
	self.fields.Content:showInlayEffect(lv, idx)
end
function WarGemMainInfo:gameGuide_getTarget(itemName, parameters)
	return self.fields.Content:gameGuide_getTarget(itemName, parameters)
end
return WarGemMainInfo
