local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneRintensifyPanel = class("RuneRintensifyPanel", baseFguiPanel)
function RuneRintensifyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneRintensifyPanel:ctor", self.viewName)
end
function RuneRintensifyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneRintensifyPanel:onInit()
	print("=======RuneRintensifyPanel:onInit")
	self.selectArray, _ENV = print, print
	self.isToLimit = false
	self.isOneKeyChoose = true
	self.runeData = self.param.data
	self.fields.Com_title:initData(i18n("Weapon_Rune_tips_023"), handler(self, self.onClickClose))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_027"))
	self.fields.Text_list:setString(i18n("Weapon_Rune_tips_025"))
	self.fields.Btn_oneKeyChoose:setString(i18n("Weapon_Rune_tips_043"))
	self.fields.Btn_oneKeyChoose:addClickListener(handler(self, self.onOneKeyClick))
	self.fields.Btn_oneKeyChoose:setEnabled(false)
	self.fields.Btn_lvup:setString(i18n("common_text_055"))
	self.fields.Btn_lvup:addClickListener(handler(self, self.onLvUpClick))
	self.fields.Btn_lvup:setEnabled(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Lab_cost:setString(i18n("Weapon_Rune_tips_026"))
	self.fields.List_cost:setItemRenderer(handler(self, self.onItemCostRenderer))
	self.fields.Btn_advance:setString(i18n("common_text_2921"))
	self.fields.Btn_advance:addClickListener(handler(self, self.onAdvanceClick))
	self.fields.Btn_advance:setEnabled(false)
	self.fields.MV_up:setAllFrameName("dh_Tex_XL_zlts01_%.3d.png", 1)
	self.fields.MV_up:setVisible(false)
	self.fields.Com_advance:setVisible(false)
end
function RuneRintensifyPanel:onShow()
	print("=======RuneRintensifyPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_bgex:setGradientColor()
	self.fields.Btn_oneKeyChoose:fixPos()
	self.fields.Btn_lvup:fixPos()
	self:initData()
end
function RuneRintensifyPanel:onItemRenderer(index, obj)
	local isChoose = false
	if self.myRuneList[index + 1].isExp then
		if self.selectArray.expRidList and self.selectArray.expRidList[self.myRuneList[index + 1].rid] and SoraDisInList(self.myRuneList[index + 1].uuid, self.selectArray.expRidList[self.myRuneList[index + 1].rid]) then
			isChoose = true
		end
	else
		if not self.selectArray.uidList then
			_ENV = self.selectArray.uidList
		end
		if SoraDisInList(self.myRuneList[index + 1].uid, self.selectArray.uidList) then
			isChoose = true
		end
	end
	obj:initData(self.myRuneList[index + 1], isChoose, true, false, 2)
end
function RuneRintensifyPanel:onItemCostRenderer(index, obj)
	obj:initData(self.costArray[index + 1], self.runeData.uid)
end
function RuneRintensifyPanel:strengthenChooseBack(target, data)
	local chooseData = data.data
	dump(data, "strengthenChooseBack===")
	if data.isChoose then
		if not self.isToLimit then
			if chooseData.isExp then
				if not self.selectArray.expRidList then
					self.selectArray.expRidList, _ENV = data, data
				end
				if not self.selectArray.expRidList[chooseData.rid] then
					self.selectArray.expRidList[chooseData.rid], _ENV = "strengthenChooseBack===", "strengthenChooseBack==="
				end
				table.insert(self.selectArray.expRidList[chooseData.rid], chooseData.uuid)
			else
				if not self.selectArray.uidList then
					self.selectArray.uidList, _ENV = self.selectArray.expRidList[chooseData.rid], self.selectArray.expRidList[chooseData.rid]
				end
				table.insert(self.selectArray.uidList, chooseData.uid)
			end
		end
	else
		self.isToLimit = false
		if chooseData.isExp then
			if self.selectArray.expRidList[chooseData.rid] then
				for k, v in pairs(self.selectArray.expRidList[chooseData.rid]) do
					if chooseData.uuid == v then
						table.remove(self.selectArray.expRidList[chooseData.rid], k)
						if not next(self.selectArray.expRidList[chooseData.rid]) then
							self.selectArray.expRidList[chooseData.rid] = nil
						end
						break
					end
				end
			end
		elseif self.selectArray.uidList then
			for k, v in ipairs(self.selectArray.uidList) do
				if chooseData.uid == v then
					table.remove(self.selectArray.uidList, k)
					break
				end
			end
		end
	end
	self:updatePreInfo()
end
function RuneRintensifyPanel:updatePreInfo()
	if not self.selectArray.expRidList then
		_ENV = self.selectArray.expRidList
	end
	if not next(self.selectArray.expRidList) then
		if not self.selectArray.uidList then
			_ENV = self.selectArray.uidList
		end
	end
	local isEnable = next(self.selectArray.uidList) and true or false
	self.fields.Btn_lvup:setEnabled(isEnable)
	if isEnable then
		local newData, isToLimit = godArmsRuneCtrl:getNewRuneData(self.runeData.uid, self.selectArray.uidList, self.selectArray.expRidList)
		self.fields.com_info:setShowIndex(1)
		self.fields.com_info:setPreData(newData)
		if isToLimit then
			if self.isToLimit then
				SoraDShowMsgTip(i18n("Weapon_Rune_tips_024"))
			end
			self.isToLimit = true
		end
	else
		self.fields.com_info:setShowIndex(0)
		self.fields.com_info:initData(self.runeData)
	end
	self.fields.List:setNumItems(#self.myRuneList)
	self.isOneKeyChoose = not isEnable
	self.fields.Btn_oneKeyChoose:setString(self.isOneKeyChoose and i18n("Weapon_Rune_tips_043") or i18n("Weapon_Rune_tips_064"))
end
function RuneRintensifyPanel:chooseBack(target, data)
	self.uidList = data.uidList
	local isEnable = true
	for k, v in ipairs(self.costArray) do
		if v.type == 2 then
			v.chooseNum = #self.uidList
			if #self.uidList < v.count then
				isEnable = false
			end
		elseif v.type == 1 then
			local myCount = backpackCtrl:getItemCount(v.id)
			if myCount < v.count then
				isEnable = false
			end
		end
	end
	self.fields.List_cost:setNumItems(#self.costArray)
	self.fields.Btn_advance:setEnabled(isEnable)
end
function RuneRintensifyPanel:updateView(target, data)
	if data and data.isStrengthen then
		self.selectArray, _ENV = data.isStrengthen, data.isStrengthen
		self.isToLimit = false
		self.bestArray = nil
		self.fields.Btn_advance:setEnabled(false)
	end
	if data and data.isAdvance then
		self.fields.Com_advance:playAct()
		self.selectArray, _ENV = self.fields.Com_advance.playAct, self.fields.Com_advance.playAct
		self.isToLimit = false
		self.bestArray = nil
		self.fields.Btn_advance:setEnabled(false)
		if data.returnItem and next(data.returnItem) then
			godArmsRuneCtrl = nil
			;(nil)[1] = ffa.delay(1.0)
			;(nil)[2] = ffa.callFunc(function()
				_ENV = nil
				;(nil).title = i18n("Weapon_Rune_tips_074")
				;(nil).awardList = data.returnItem
				uiManager:show("Panel_gainView", nil)
			end)
			;(nil)[3] = ffa.callFunc(function()
				_ENV = nil
				;(nil).title = i18n("Weapon_Rune_tips_074")
				;(nil).awardList = data.returnItem
				uiManager:show("Panel_gainView", nil)
			end)
			self:runAction(ffa.seq(nil))
		end
	end
	self.runeData = godArmsRuneCtrl:getRuneInfo(self.runeData.uid)
	local info = artifactRuneRead.getRuneInfo(self.runeData.rid)
	local isUnlock, classLimit, levlLimit = artifactRuneRead.getLimitSeaonCfg(info.Season)
	local maxLv = levlLimit
	if maxLv <= self.runeData.level then
		self:close()
		return
	end
	self:initData()
end
function RuneRintensifyPanel:sortData()
	local runeList = godArmsRuneCtrl:getRuneData()
	local expruneList = godArmsRuneCtrl:getEXPRuneData()
	self.myRuneList, godArmsRuneCtrl = godArmsRuneCtrl, godArmsRuneCtrl
	local godArmsRuneCtrl, expList = godArmsRuneCtrl, godArmsRuneCtrl
	local index = 1
	for k, v in pairs(expruneList) do
		for i = 1, v do
			local info = artifactRuneRead.getRuneInfo(tonumber(k))
			local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, 1)
			godArmsRuneCtrl = tonumber(k)
			tonumber(k).isExp = true
			tonumber(k).rid = tonumber(k)
			tonumber(k).uuid = index
			tonumber(k).num = 1
			tonumber(k).ProduceExp = lvCfg.ProduceExp
			table.insert(self.myRuneList, tonumber(k))
			index = index + 1
		end
	end
	if artifactRuneRead.checkCostRune() then
		for k, v in ipairs(runeList) do
			if v.uid ~= self.runeData.uid then
				local wearRuneInfo = godArmsRuneCtrl:getWearRuneInfo(v.uid)
				local wearInfo = godArmsRuneCtrl:getWearRuneInfo(self.runeData.uid)
				if not godArmsRuneCtrl:isRuneWear(v.uid) or wearRuneInfo and wearInfo and (wearRuneInfo.armid ~= wearInfo.armid or wearRuneInfo.cell ~= wearInfo.cell) then
					local info = artifactRuneRead.getRuneInfo(v.rid)
					local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
					godArmsRuneCtrl = table.insert
					table.insert.rid = v.rid
					table.insert.uid = v.uid
					table.insert.isLock = v.isLock
					table.insert.class = lvCfg.Class or 0
					table.insert.level = v.level
					table.insert.exp = v.exp
					table.insert.ProduceExp = lvCfg.ProduceExp
					table.insert.cLevel = lvCfg.Level or 1
					table.insert.season = lvCfg.season or 1
					table.insert.runeType = info.RuneType
					table.insert.heritType = info.HeritType
					table.insert.isWear = godArmsRuneCtrl:isRuneWear(v.uid)
					if not v.extraProperty then
						godArmsRuneCtrl = v.extraProperty
					end
					table.insert.extraProperty = v.extraProperty
					table.insert(self.myRuneList, table.insert)
				end
			end
		end
	end
	table.sort(self.myRuneList, function(a, b)
		if a.isExp and b.isExp then
			if a.rid == b.rid then
				return a.uuid < b.uuid
			else
				return a.rid < b.rid
			end
		elseif not a.isExp and not b.isExp then
			if a.isWear and b.isWear or not a.isWear and not b.isWear then
				if a.class == b.class then
					if a.level == b.level then
						if a.season == b.season then
							if a.runeType == b.runeType then
								return a.rid < b.rid
							else
								return a.runeType < b.runeType
							end
						else
							return a.season < b.season
						end
					else
						return a.level < b.level
					end
				else
					return a.class < b.class
				end
			else
				return not a.isWear
			end
		else
			return a.isExp or false
		end
	end)
end
function RuneRintensifyPanel:initData()
	self.costArray, artifactRuneRead = nil, nil
	local info = artifactRuneRead.getRuneInfo(self.runeData.rid)
	local isAdvance, cost = artifactRuneRead.isCanAdvance(info.ExpGrowingType, self.runeData.level)
	if isAdvance then
		self.controllers.c1:setSelectedIndex(2)
		self.fields.com_info:setShowIndex(2)
		self.fields.com_info:setAdvanceData(self.runeData)
		self.costArray = cost
		self.fields.List_cost:setNumItems(#self.costArray)
		local nlvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, self.runeData.level + 1)
		local unLockIndex
		for k, v in ipairs(info.PropertyActivationClass) do
			if nlvCfg.Class == v then
				unLockIndex = k
			end
		end
		if unLockIndex then
			self.fields.n61:setVisible(true)
			self.fields.Text_preBuff:setVisible(true)
			local preExtra = self.runeData.extraProperty[unLockIndex]
			if preExtra then
				local propertyArray, quality = artifactRuneRead.getPropertyArray(preExtra[1])
				local des = ""
				for k, v in ipairs(propertyArray) do
					local pLvCfg = artifactRuneRead.getPropertiesLvCfg(v.growType, preExtra[2])
					if k == #propertyArray then
						des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal + pLvCfg.GrowingValue, v.buffMode)
					else
						des = des .. buffDesRead.getBuffDes(v.buffType, v.buffVal + pLvCfg.GrowingValue, v.buffMode) .. ","
					end
				end
				self.fields.Text_preBuff:setString(des)
			end
		else
			self.fields.n61:setVisible(false)
			self.fields.Text_preBuff:setVisible(false)
		end
		self.fields.Text_list:setString(i18n("Weapon_Rune_tips_054"))
	else
		self:sortData()
		local isHaveRes = #self.myRuneList > 0
		local cIndex = isHaveRes and 1 or 0
		self.controllers.c1:setSelectedIndex(cIndex)
		self.fields.com_info:setShowIndex(0)
		self.fields.com_info:initData(self.runeData)
		self.fields.Btn_oneKeyChoose:setEnabled(isHaveRes)
		if isHaveRes then
			self.fields.List:setNumItems(#self.myRuneList)
		end
		self.fields.Text_list:setString(i18n("Weapon_Rune_tips_025"))
		self:checkOneKey()
		self:updatePreInfo()
	end
end
function RuneRintensifyPanel:checkOneKey()
	local ret = false
	for k, v in ipairs(self.myRuneList) do
		if v.isExp then
			ret = true
			break
		end
		if v.uid and not v.isLock and not v.isWear and v.level == 1 and v.exp == 0 and not self:checkExtraProperty(v) then
			ret = true
			break
		end
	end
	self.fields.Btn_oneKeyChoose:setEnabled(ret)
end
function RuneRintensifyPanel:checkExtraProperty(data)
	local ret = false
	for k, v in ipairs(data.extraProperty) do
		if v[2] > 1 then
			ret = true
			break
		end
		local propertyArray, quality = artifactRuneRead.getPropertyArray(v[1])
		if 5 <= quality then
			ret = true
			break
		end
	end
	return ret
end
function RuneRintensifyPanel:chooseBest()
	local _ENV, bestData
	local isEnough = function(array, index, exp)
		local total = 0
		if index <= #array then
			for i = index, #array do
				total = total + array[i].ProduceExp
			end
		end
		return exp <= total
	end
	local tryChoose = function(array, target)
		local isEnough, num
		for i = 1, #array do
			if not array[i].isVisit and (target >= array[i].ProduceExp or not isEnough(array, i + 1, target)) then
				table.insert(num, array[i])
				array[i].isVisit = true
				target = target - array[i].ProduceExp
			end
		end
		return num
	end
	local checkEXP = function(array, fArray, exp)
		local newArray = array
		local addExp = 0
		for k, v in ipairs(array) do
			if v.isVisit then
				addExp = addExp + v.ProduceExp
			end
		end
		if exp > addExp then
			local _ENV, tempTb = ipairs(array)
			for i = #fArray, 1, -1 do
				if not fArray[i].isVisit and exp <= fArray[i].ProduceExp then
					table.insert(tempTb, fArray[i])
					fArray[i].isVisit = true
					break
				end
			end
			if 0 < #tempTb then
				newArray = tempTb
			end
		end
		return newArray
	end
	local _ENV, spData
	local spEXP = 0
	local _ENV, glData
	local glEXP = 0
	for k, v in ipairs(self.expData) do
		if v.isExp then
			spEXP = spEXP + v.ProduceExp
			table.insert(spData, v)
		else
			glEXP = glEXP + v.ProduceExp
			table.insert(glData, v)
		end
	end
	if spEXP >= self.needEXP then
		bestData = tryChoose(spData, self.needEXP)
		bestData = checkEXP(bestData, spData, self.needEXP)
	elseif glEXP + spEXP <= self.needEXP then
		bestData = self.expData
	else
		bestData = spData
		local tryArray = tryChoose(glData, self.needEXP - spEXP)
		tryArray = checkEXP(tryArray, glData, self.needEXP - spEXP)
		for k, v in ipairs(tryArray) do
			table.insert(bestData, v)
		end
	end
	local chooseExp = 0
	for k, v in ipairs(bestData) do
		chooseExp = chooseExp + v.ProduceExp
	end
	local needExtraExp = self.needEXP - chooseExp
	if 0 < needExtraExp then
		for i = #self.expData, 1, -1 do
			if not self.expData[i].isVisit and needExtraExp <= self.expData[i].ProduceExp then
				table.insert(bestData, self.expData[i])
				break
			end
		end
	end
	return bestData
end
function RuneRintensifyPanel:onOneKeyClick()
	SoraDPlaySound()
	print("一键选择")
	if self.isOneKeyChoose then
		if self.bestArray then
			for k, v in ipairs(self.bestArray) do
				if v.isExp then
					if not self.selectArray.expRidList[v.rid] then
						self.selectArray.expRidList[v.rid], _ENV = nil, nil
					end
					if not SoraDisInList(v.uuid, self.selectArray.expRidList[v.rid]) then
						table.insert(self.selectArray.expRidList[v.rid], v.uuid)
					end
				else
					table.insert(self.selectArray.uidList, v.uid)
				end
			end
			self:updatePreInfo()
			self:sortBestData()
			return
		end
		self.expData, _ENV = self.sortBestData, self.sortBestData
		for k, v in ipairs(self.myRuneList) do
			local info = artifactRuneRead.getRuneInfo(v.rid)
			if v.isExp then
				table.insert(self.expData, v)
			elseif not v.isLock and not v.isWear and v.level == 1 and v.exp == 0 and not self:checkExtraProperty(v) then
				table.insert(self.expData, v)
			end
		end
		table.sort(self.expData, function(a, b)
			return a.ProduceExp > b.ProduceExp
		end)
		self.selectArray, _ENV = table.sort, table.sort
		self.selectArray.expRidList, _ENV = self.expData, self.expData
		self.selectArray.uidList, _ENV = self.expData, self.expData
		local info = artifactRuneRead.getRuneInfo(self.runeData.rid)
		self.needEXP = artifactRuneRead.getNeedEXP(info.ExpGrowingType, self.runeData.level, self.runeData.exp)
		self.bestArray = self:chooseBest()
		for k, v in ipairs(self.bestArray) do
			if v.isExp then
				if not self.selectArray.expRidList[v.rid] then
					self.selectArray.expRidList[v.rid], _ENV = v, v
				end
				if not SoraDisInList(v.uuid, self.selectArray.expRidList[v.rid]) then
					table.insert(self.selectArray.expRidList[v.rid], v.uuid)
				end
			else
				table.insert(self.selectArray.uidList, v.uid)
			end
		end
		self:updatePreInfo()
		self:sortBestData()
	else
		self.selectArray, _ENV, self.isToLimit = artifactRuneRead.getRuneInfo(self.runeData.rid), artifactRuneRead.getRuneInfo(self.runeData.rid), false
		self.selectArray.expRidList, _ENV = self.sortBestData, self.sortBestData
		self.selectArray.uidList, _ENV = self.sortBestData, self.sortBestData
		self:initData()
	end
	dump(self.selectArray.expRidList, "self.selectArray.expRidList====")
end
function RuneRintensifyPanel:sortBestData()
	local _ENV, bestList
	local _ENV, keyExp
	local _ENV, keyRune
	for k, v in ipairs(self.bestArray) do
		if v.uid then
			keyRune[v.uid] = v
		end
		if v.uuid then
			keyExp[v.uuid] = v
		end
	end
	for k, v in ipairs(self.myRuneList) do
		if v.isExp then
			if keyExp[v.uuid] then
				table.insert(bestList, v)
			end
		elseif keyRune[v.uid] then
			table.insert(bestList, v)
		end
	end
	for k, v in ipairs(self.myRuneList) do
		if v.isExp then
			if not keyExp[v.uuid] then
				table.insert(bestList, v)
			end
		elseif not keyRune[v.uid] then
			table.insert(bestList, v)
		end
	end
	self.myRuneList = bestList
	self.fields.List:setNumItems(#self.myRuneList)
end
function RuneRintensifyPanel:onLvUpClick()
	SoraDPlaySound()
	print("升级")
	self.fields.Btn_lvup:setEnabled(false)
	_ENV = self.fields.Btn_lvup
	self.fields.Btn_lvup.msg = "MESSAGE_UI_STRENGTHEN_EFFECT"
	self.fields.Btn_lvup.selectArray = self.selectArray
	SoraDSendMessage(self.fields.Btn_lvup)
	self.fields.MV_up:setVisible(true)
	self.fields.MV_up:setPlaySettings(0, -1, 1)
	godArmsRuneCtrl = -1
	;(-1)[1] = ffa.delay(1.0)
	;(-1)[2] = ffa.callFunc(function()
		local _ENV, expRidList
		if not self.selectArray.expRidList then
			_ENV = self.selectArray.expRidList
		end
		for k, v in pairs(self.selectArray.expRidList) do
			table.insert(expRidList, k)
			table.insert(expRidList, #v)
		end
		godArmsRuneCtrl:sendStrengthen(self.runeData.uid, self.selectArray.uidList, expRidList)
	end)
	;(-1)[3] = ffa.callFunc(function()
		local _ENV, expRidList
		if not self.selectArray.expRidList then
			_ENV = self.selectArray.expRidList
		end
		for k, v in pairs(self.selectArray.expRidList) do
			table.insert(expRidList, k)
			table.insert(expRidList, #v)
		end
		godArmsRuneCtrl:sendStrengthen(self.runeData.uid, self.selectArray.uidList, expRidList)
	end)
	self:runAction(ffa.seq(-1))
end
function RuneRintensifyPanel:onAdvanceClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.runeData
	;(nil).uidList = self.uidList
	uiManager:show("RuneAdvancePop", nil)
end
return RuneRintensifyPanel
