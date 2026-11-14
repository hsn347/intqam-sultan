local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local wallsCtrl = SoraDGetCtrl("wallsCtrl")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local ADD_DEFENCE_VAL = 80
local quickBuildBackpackID = 502101
local quickBuildStoreID = IsArClient and 1000106 or 1000102
local QUICK_BUILD_WALL = shopltCtrl:getPrice(quickBuildStoreID)
local baseComponent = require("fgui.base.baseComponent")
local Com_status = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CityWallView/Com_status", Com_status)
function Com_status:onInit()
	self.addType = 0
	self.fields.btnEmergencyAdd:setString(i18n("common_btn_10"))
	self.fields.btnEmergencyAdd:addClickListener(handler(self, self.onBtnAddClick))
	self.fields.Button_addDefend:addClickListener(handler(self, self.btnAddDenfendClick))
	self.fields.Button_addDefend:fixPos()
	self.fields.btnEmergencyAdd:fixPos()
end
function Com_status:onShow()
end
function Com_status:setBurnStr(str, status)
	self.fields.Text_isBurn:setString(str)
	self.controllers.c1:setSelectedIndex(status)
end
function Com_status:setDefendStr(str)
	self.fields.Text_defendContent:setString(str)
end
function Com_status:setDefenceTime(timeStr)
	self.fields.Button_addDefend:setString(timeStr)
end
function Com_status:initData(tableWall)
	self.tableWall = tableWall
	if self.tableWall.addDefendTime > 0 then
		self.fields.Button_addDefend:setEnabled(false)
	else
		self.fields.Button_addDefend:setEnabled(true)
		self.fields.Button_addDefend:setString(i18n("common_text_400") .. "\n" .. ADD_DEFENCE_VAL)
	end
	if self.tableWall.defendCur < self.tableWall.defendVal and 0 >= self.tableWall.burnTime then
		_ENV = ADD_DEFENCE_VAL
		ADD_DEFENCE_VAL.time = WALL_ADD_DEFEND_COST_TIME
		self.fields.Text_defendContent:setString(i18n("common_text_401", ADD_DEFENCE_VAL))
	end
	local emergencyToolNum = backpackCtrl:getItemCount(quickBuildBackpackID)
	if 0 < emergencyToolNum then
		self.addType = 1
		self.fields.btnEmergencyAdd:setCostIcon(publicRead.getIcon(quickBuildBackpackID))
		self.fields.btnEmergencyAdd:setCostTitle(emergencyToolNum .. "/1")
	else
		self.addType = 0
		self.fields.btnEmergencyAdd:setCostIcon(publicRead.getIcon(gIDDef.GOLD))
		self.fields.btnEmergencyAdd:setCostTitle(QUICK_BUILD_WALL)
		if not SoraDEnoughGold(QUICK_BUILD_WALL, true) then
			self.fields.btnEmergencyAdd:setGoldColor(display.COLOR_RED)
		else
			self.fields.btnEmergencyAdd:setGoldColor(cc.c3b(255, 251, 213))
		end
	end
	local defendVal = wallsCtrl:getMaxDefence()
	local defendCur = wallsCtrl:getCurDefence()
	self.fields.btnEmergencyAdd:setEnabled(defendVal ~= defendCur)
end
function Com_status:onBtnAddClick()
	SoraDPlaySound()
	if self.addType == 0 then
		if SoraDEnoughGold(QUICK_BUILD_WALL, false) then
			shopCtrl:reqBuyInItemShop(quickBuildStoreID, 1, true)
		end
	else
		backpackCtrl:reqUseItem(quickBuildBackpackID, 1)
	end
end
function Com_status:btnAddDenfendClick(button, type)
	SoraDPlaySound()
	wallsCtrl:addDefence()
end
return Com_status
