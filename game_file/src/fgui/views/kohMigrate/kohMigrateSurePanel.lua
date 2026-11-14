local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local buildLogic = include("buildLogic")
local kohMigrateRead = include("kohMigrateRead")
local resDesRead = include("resDesRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigrateSurePanel = class("kohMigrateSurePanel", baseFguiPanel)
function kohMigrateSurePanel:ctor(...)
	kohMigrateSurePanel.super.ctor(self, ...)
	print("kohMigrateSurePanel:ctor", self.viewName)
	self.debug = true
end
function kohMigrateSurePanel:onInit()
	print("=======kohMigrateSurePanel:onInit")
	self.fields.Panel_bg:setString(i18n("across_move_title"))
	self.fields.Text_has:setString(i18n("across_getItemNum_name"))
	self.fields.Text_res:setString(i18n("across_move_resLimit_name"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_migrate:setString(i18n("across_moveSure_btn"))
	self.fields.Button_migrate:addClickListener(handler(self, self.btnMigrateClick))
	if not SoraDFIsRA() then
		_UPVALUE3_ = self.fields.Button_migrate
		self.fields.Button_migrate[1] = self.fields.Text_has
		self.fields.Button_migrate[2] = self.fields.Sprite_item
		self.fields.Button_migrate[3] = self.fields.Text_count
		for __, v in pairs(self.fields.Button_migrate) do
			v:fixPos()
		end
	end
end
function kohMigrateSurePanel:onShow()
	print("=======kohMigrateSurePanel:onShow")
	self:initData()
	self:initResConfig()
	if not self.param then
		_ENV = self.param
	end
	self:setMigrateData(self.param)
	self:initScrollInfo()
end
function kohMigrateSurePanel:setMigrateData(data)
	self.kingdomId = data.kingdomId
	self.isInvitedMove = data.isInvitedMove
	self.isExtraMove = data.isExtraMove
	self.isPrivilege = data.isPrivilege
end
function kohMigrateSurePanel:initScrollInfo(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_content)
	_ENV = nil
	_ENV, _ENV, (nil).var1 = nil, self.kingdomId, self.kingdomId
	self.kingdomId.var1, (nil).color = nil, "#F0E6D2"
	local des1 = i18n_html("across_move_targetKing_name", nil, self.kingdomId)
	_fields.Text_des1:setString(des1)
	local lvLimit = kohMigrateCtrl:getLvLimit()
	_ENV = nil
	;(nil).var1 = buildLogic.getBuildLvStr(lvLimit)
	_fields.Text_des2:setString(i18n("across_move_windowSure_text1", nil))
	_ENV = "across_move_windowSure_name"
	;("across_move_windowSure_name").color = "#DC915A"
	local des3 = SoraDWrapHtmlTagByStyle(i18n("across_move_windowSure_name"), "across_move_windowSure_name")
	des3 = des3 .. "\n" .. i18n("across_move_windowSure_text2")
	des3 = des3 .. [[


]] .. i18n("across_move_finalSure_desc")
	_fields.Text_des3:setString(des3)
end
function kohMigrateSurePanel:initData()
	self.itemIDList = kohMigrateCtrl:getItemIDList()
	self.itemCost = kohMigrateCtrl:getItemCost()
	local beginStrength = kohMigrateCtrl:getBeginStrength()
	kohMigrateCtrl = nil
	;(nil).var1 = string.formatnumberthousands(beginStrength)
	kohMigrateCtrl, kohMigrateCtrl, (nil).var2 = self.itemCost, string.formatnumberthousands(self.itemCost), string.formatnumberthousands(self.itemCost)
	string.formatnumberthousands(self.itemCost).var2, self.itemCost.color = self.itemCost, "#FFD43E"
	local powerStr = i18n_html("across_consume_desc", nil, (string.formatnumberthousands(self.itemCost)))
	self.fields.Text_power:setString(powerStr)
	self:refreshItemCount()
end
function kohMigrateSurePanel:btnMigrateClick()
	SoraDPlaySound()
	if not self.isItemEnough then
		_ENV = nil
		;(nil).itemID = self.itemIDList[1]
		;(nil).title = i18n("tips_across_item_noEnough")
		uiManager:show("CommonSourceGuide", nil)
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("tips_across_notInMap"))
		return
	end
	kohMigrateCtrl:reqMoveCity(self.kingdomId, self.isInvitedMove, self.isExtraMove, self.isPrivilege)
	SoraDShowLoading()
end
function kohMigrateSurePanel:refreshItemCount(...)
	local itemCount = kohMigrateCtrl:getItemCount()
	self.fields.Text_count:setString(string.formatnumberthousands(itemCount))
	self.isItemEnough = itemCount >= self.itemCost
	self.fields.Button_migrate:setCost2(self.itemIDList[1], self.itemCost, itemCount)
end
function kohMigrateSurePanel:onItemRenderer(index, obj)
	local data = self.resConfig[index + 1]
	local resIcon = resDesRead.getIcon(data.id)
	obj:setIcon(resIcon)
	local hasCount = cityCtrl:getResCount(data.id)
	local count1 = SoraDConvertNumberWithUnit(hasCount)
	local count2 = SoraDConvertNumberWithUnit(data.count)
	if hasCount > data.count then
		resDesRead = nil
		;(nil).color = "#FF0000"
		local str = string.format("%s/%s", SoraDWrapHtmlTagByStyle(count1, nil), count2)
		obj:setString(str)
	else
		local str = string.format("%s/%s", count1, count2)
		obj:setString(str)
	end
end
function kohMigrateSurePanel:initResConfig(...)
	local ARC = kohMigrateRead.getMigrantResourcesConfig()
	local warLv = SoraDGetCastleWarLv()
	local starLv = SoraDGetBuildStarLv()
	local resources
	for i, v in ipairs(ARC) do
		if starLv >= v.ghLevel[1] and starLv <= v.ghLevel[2] then
			if warLv < v.zzLevel then
				break
			end
			resources = v.resources
		end
	end
	resources = resources or ARC[1].resources
	local kohMigrateRead, resConfig = ARC[1], ARC[1]
	for i = 1, #resources / 2 do
		local resId = resources[i * 2 - 1]
		if SoraDResIsLock(resId) then
			kohMigrateRead = nil
			;(nil).id = resId
			;(nil).count = resources[i * 2]
			table.insert(resConfig, nil)
		end
	end
	self.resConfig = resConfig
	self.fields.List:setNumItems(#self.resConfig)
end
return kohMigrateSurePanel
