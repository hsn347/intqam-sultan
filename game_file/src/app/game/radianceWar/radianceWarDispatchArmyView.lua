local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
local radianceWarUtil = include("radianceWarUtil")
local armyltCtrl = include("armyltCtrl")
local radianceWarDispatchArmyView = class("radianceWarDispatchArmyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarDispatchArmyView")
	end
	return target
end)
function radianceWarDispatchArmyView:ctor()
	self.isHideCurrentSceneView = true
	self.tableArmyData, _ENV, self.tableArmy, _ENV, self.tableSpare, _ENV, self.tableArmySingle, _ENV, self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	local constantRead = include("constantRead")
	local maxArmy = constantRead.getConstArmyMax_radiance()
	local armyNum = armyCtrl:getTotalWoundedArmyCount(gKingdomClassType.radiance)
	armyNum = armyNum + armyCtrl:getTotalArmyCount(gKingdomClassType.radiance)
	self.allCount = math.max(0, maxArmy - armyNum)
	self.curCount = 0
	self.isSelectFull = false
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_858"))
	self.btn_convene = SoraDGetChildByName(self, "Button_convene")
	self.btn_convene:setTitleText(i18n("common_text_3616"))
	self.btnQuickChoose = SoraDGetChildByName(self, "Button_quick")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelCountTotal = SoraDGetChildByName(self, "Text_countTotal")
	self.spriteCount = SoraDGetChildByName(self, "Sprite_count")
	self.labelTitle = SoraDGetChildByName(self, "Text_quick_title")
	self.labelTitle:setString(i18n("common_text_852"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_go")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.btnQuickChoose:addTouchEventListener(handler(self, self.btnQuickClickCallBack))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClickCallBack))
	self.btn_convene:addTouchEventListener(handler(self, self.btnConveneClickCallBack))
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelName:setString(i18n("brightWar_text_132"))
	self:initCreateView()
end
function radianceWarDispatchArmyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_ENTER_BACK", handler(self, self.rspDispatchBack))
end
function radianceWarDispatchArmyView:initArmyData()
	self:initData()
	self:quickChoose(true)
end
function radianceWarDispatchArmyView:initCreateView()
	self.nodeTitle:setTitle(i18n("brightWar_text_21"))
	self.btnGo:setTitleText(i18n("common_text_3318"))
	self:initArmyData()
end
local isForbidSolider = function(army)
	return army.level < 9 or army.soldierType == gSoldierType.SOLDIER_TYPE_ELITE
end
function radianceWarDispatchArmyView:initData(dType)
	local armyIDList = armyCtrl:getArmyIDList()
	self.armyIDList, armyCtrl = armyCtrl, armyCtrl
	for _, v in ipairs(armyIDList) do
		local armyID = v % 1000
		local armyLv = armyID % 100
		local soldierType = armyltCtrl.getSoldierType(v)
		armyCtrl = v
		v.id = v
		v.armyID = armyID
		v.level = armyLv
		local v.soldierType, tableArmyID = soldierType, v
		local isForbid = isForbidSolider(tableArmyID)
		tableArmyID.isForbid = isForbid
		table.insert(self.armyIDList, tableArmyID)
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.isForbid ~= army2.isForbid then
			return army2.isForbid
		end
		if army1.level ~= army2.level then
			return army2.level < army1.level
		end
		return army1.armyID < army2.armyID
	end)
	self.tableArmy, armyCtrl, self.tableArmyData, armyCtrl, self.curCount = table.sort, table.sort, table.sort, table.sort, 0
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local haveCount = armyCtrl:getArmyCount(id, ARMY_OPTYPE.NORMAL_ARMY)
		if 0 < haveCount then
			table.insert(self.tableArmy, id)
			armyCtrl = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = haveCount
			self.tableArmy.curCount = 0
			self.tableArmyData[id], self.tableArmy.isForbid = self.tableArmy, v.isForbid
		end
	end
	self.labelNotice:setVisible(0 >= #self.tableArmy)
	self.btn_convene:setVisible(0 >= #self.tableArmy)
	self.labelCountTotal:setString("/" .. tostring(self.allCount))
	self:updateCountLabel()
	self:initScroll()
end
function radianceWarDispatchArmyView:initScroll()
	self.scroll:removeAllChildren()
	self.tableSpare, _ENV, self.tableArmySingle, _ENV = self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren
	local scrollH = math.max(self.scroll:getContentSize().height, 130 * #self.tableArmy)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	for i, armyid in ipairs(self.tableArmy) do
		local posY = scrollH - 5 - (i - 1) * 130
		_ENV = cc.size(640, scrollH)
		cc.size(640, scrollH).armyid = armyid
		cc.size(640, scrollH).posY = posY
		cc.size(640, scrollH).point = nil
		table.insert(self.tableArmySingle, cc.size(640, scrollH))
	end
	self:updateScrollList()
end
function radianceWarDispatchArmyView:updateScrollList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 130)
	local self.scroll.endY, tableShowH = offsetY + scrollH + 130, self.scroll
	for i, v in ipairs(self.tableArmySingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("radianceWarDispatchArmySingle")
				single:setSliderChangeBack(handler(self, self.singleSliderChange))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				single:setVisible(true)
			end
			local armyData = self.tableArmyData[v.armyid]
			if armyData then
				single:initData(armyData)
			end
			single:setPosition(cc.p(0, v.posY))
			single:setLocalZOrder(i)
			v.point = single
		end
	end
end
function radianceWarDispatchArmyView:singleSliderChange(target, data)
	self:setCurValByArmyid(data.armyid, data.armycount)
	self:updateView()
end
function radianceWarDispatchArmyView:updateCountLabel()
	self.labelCount:setString(tostring(self.curCount))
end
function radianceWarDispatchArmyView:updateView()
	self:updateCountLabel()
	self:updateScroll()
	self:updateBtnStatus()
end
function radianceWarDispatchArmyView:updateScroll()
	for _, v in pairs(self.tableArmySingle) do
		if v.point then
			v.point:updateView()
		end
	end
end
function radianceWarDispatchArmyView:btnConveneClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("armyBuildingsView"):show()
	end
end
function radianceWarDispatchArmyView:updateBtnText()
	if self.isSelectFull then
		self.btnQuickChoose:loadTextures("btn_red_small_01.png", "btn_red_small_02.png", "btn_gray_small.png", ccui.TextureResType.plistType)
		self.labelTitle:setString(i18n("common_btn_18"))
	else
		self.btnQuickChoose:loadTextures("btn_green_small_01.png", "btn_green_small_02.png", "btn_gray_small.png", ccui.TextureResType.plistType)
		self.labelTitle:setString(i18n("common_text_852"))
	end
end
function radianceWarDispatchArmyView:quickChoose(isFull)
	self:quickChoose_army(isFull)
	self:updateBtnText()
end
function radianceWarDispatchArmyView:quickChoose_army(isFull)
	if isFull then
		for _, armyid in pairs(self.tableArmy) do
			self:setCurValMax(armyid)
		end
	else
		self:resetArmySelect()
	end
	self:updateView()
	self.isSelectFull = isFull
end
function radianceWarDispatchArmyView:btnQuickClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:quickChoose(not self.isSelectFull)
	end
end
function radianceWarDispatchArmyView:dispatchFun_msg()
	local _ENV, dispatchArmyList
	for _, v in pairs(self.tableArmyData) do
		if v.curCount > 0 then
			_ENV = nil
			;(nil).id = v.armyid
			;(nil).num = v.curCount
			table.insert(dispatchArmyList, nil)
		end
	end
	local err = radianceWarUtil.checkEnterBattleField()
	if gErrDef.Err_None == err then
		radianceActivityCtrl:reqEnterBattlefield(dispatchArmyList)
		SoraDShowLoading(self)
	else
		self:errHandle(err)
	end
end
function radianceWarDispatchArmyView:errHandle(err)
	radianceWarUtil.errShowTips(err)
end
function radianceWarDispatchArmyView:dispatchFun()
	local showMsg = i18n("brightWar_text_30")
	SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			self:dispatchFun_msg()
		end
	end)
end
function radianceWarDispatchArmyView:btnGoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:dispatchFun()
	end
end
function radianceWarDispatchArmyView:resetArmySelect()
	for _, v in pairs(self.tableArmyData) do
		v.curCount = 0
	end
	self.curCount = 0
end
function radianceWarDispatchArmyView:getArmyCurCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.curCount
	end
	return 0
end
function radianceWarDispatchArmyView:getArmyCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.armycount
	end
	return 0
end
function radianceWarDispatchArmyView:setCurValMax(armyid)
	local armyMax = self:getArmyCount(armyid)
	self:setCurValByArmyid(armyid, armyMax)
end
function radianceWarDispatchArmyView:setCurValByArmyid(armyid, curCount)
	local armyData = self.tableArmyData[armyid]
	if not armyData then
		print("setCurValByArmyid error", armyid, curCount)
		return 0
	end
	if curCount > armyData.armycount then
		print("setCurValByArmyid armycount error", armyid, curCount)
		return 0
	end
	if armyData.isForbid then
		return 0
	end
	local curArmyCount = self.curCount
	if 0 < armyData.curCount then
		curArmyCount = self.curCount - armyData.curCount
		if curArmyCount < 0 then
			print("setCurValByArmyid curCount error", armyid, curCount)
			return 0
		end
	end
	if curArmyCount + curCount > self.allCount and 0 < curCount then
		curCount = self.allCount - curArmyCount
	end
	armyData.curCount = curCount
	self.curCount = curArmyCount + curCount
	return curCount
end
function radianceWarDispatchArmyView:setCurValByIndex(index, curCount)
	local armyid = self.tableArmy[index]
	if _G.checknumber(armyid) > 0 then
		return self:setCurValByArmyid(armyid, curCount)
	else
		print("setCurValByIndex error", index, curCount)
	end
	return 0
end
function radianceWarDispatchArmyView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
function radianceWarDispatchArmyView:rspDispatchBack(target, data)
	if data.err ~= gErrDef.Err_None then
		SoraDCloseLoading(self)
		self:errHandle(data.err)
	else
		self:removeFromParent()
	end
end
function radianceWarDispatchArmyView:updateBtnStatus()
	local enable = self.curCount > 0 or self.allCount == 0
	self.btnGo:setTouchEnabled(enable)
	self.btnGo:setBright(enable)
end
return radianceWarDispatchArmyView
