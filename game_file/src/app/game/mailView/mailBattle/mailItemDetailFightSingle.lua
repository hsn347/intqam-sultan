local cityBuildViewDef = include("cityBuildViewDef")
local mailItemDetailFightSingle = class("mailItemDetailFightSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailFightSingle")
end)
function mailItemDetailFightSingle:ctor(properties)
	self.itemWidth = gMailDetaiViewWidth
	self.itemHeight = 50
	self:setCascadeOpacityEnabled(true)
	self.img_Sheer = SoraDGetChildByName(self, "Image_Sheer")
	self.textZonshu = SoraDGetChildByName(self, "Text_zonshu")
	self.textXiaomie = SoraDGetChildByName(self, "Text_xiaomie")
	self.textShoushang = SoraDGetChildByName(self, "Text_shoushang")
	self.textSiwang = SoraDGetChildByName(self, "Text_siwang")
	self.textCunhuo = SoraDGetChildByName(self, "Text_cunhuo")
	self.imgLv = SoraDGetChildByName(self, "img_lv")
	self.imgItem = SoraDGetChildByName(self, "img_item")
	self.btnTip = SoraDGetChildByName(self, "Button_Tip")
	self.btnTip:addTouchEventListener(handler(self, self.btnClickNumTips))
	self.btnTip:setSwallowTouches(false)
end
function mailItemDetailFightSingle:initData(data, index)
	self.isShowBtn = false
	self.contentData = data
	if index and index % 2 == 0 then
		self.img_Sheer:setVisible(true)
	else
		self.img_Sheer:setVisible(false)
	end
	self.scroll = SoraDGetChildByName(gModuleMgr.sharedMgr("mailMgr"):getDetaiView(), "Size_scrollView")
	if data.battleItemType == gBattleItemType.SOLDIER then
		local armyDes = include("armyDesRead")
		local armyLogic = include("armyLogic")
		local imgIconName = armyDes.getArmyBattleShow(data.battleItemId)
		self.imgItem:loadTexture(imgIconName, ccui.TextureResType.plistType)
		self.imgLv:loadTexture(armyDes.getLvImg(data.battleItemId), ccui.TextureResType.plistType)
	elseif data.battleItemType == gBattleItemType.TRAP then
		local armyDes = include("armyDesRead")
		local armyLogic = include("armyLogic")
		local lv = armyLogic.getArmyLV(data.battleItemId)
		local imgIconName = armyDes.getArmyBattleShow(data.battleItemId)
		self.imgItem:loadTexture(imgIconName, ccui.TextureResType.plistType)
		self.imgLv:loadTexture(armyDes.getTrapLvImg(data.battleItemId), ccui.TextureResType.plistType)
	elseif data.battleItemType == gBattleItemType.TOWER then
		local lv = data.lv
		if lv == nil then
			lv = 1
		end
		local armyDes = include("armyDesRead")
		local imgIconName = armyDes.getArmyBattleShowByType(gArmyType.tower1)
		self.imgItem:loadTexture(imgIconName, ccui.TextureResType.plistType)
		self.imgLv:setVisible(false)
	end
	local strZonshu, strJisha, strShangbing, strSunshi, strCunhuo = self:getDetailStr(data)
	self:showStr(self.textXiaomie, strJisha)
	self:showStr(self.textShoushang, strShangbing)
	self:showStr(self.textSiwang, strSunshi)
	self:showStr(self.textZonshu, strZonshu)
	self:showStr(self.textCunhuo, strCunhuo)
	self.btnTip:setVisible(self.isShowBtn)
end
function mailItemDetailFightSingle:showStr(target, num)
	if tolua.type(num) == "number" then
		local numStr = self:convertNumberWithUnit(num)
		if tolua.type(numStr) == "number" then
			target:setString(string.formatnumberthousands(numStr))
		else
			target:setString(numStr)
			self.isShowBtn = true
		end
	else
		target:setString(num)
	end
end
function mailItemDetailFightSingle:getDetailStr(data)
	local battleItemType = data.battleItemType
	if battleItemType == gBattleItemType.SOLDIER then
		return data.survive + data.lost + data.wounded, data.kill, data.wounded, data.lost, data.survive
	elseif battleItemType == gBattleItemType.TRAP then
		return data.survive + data.lost, data.kill, "~", data.lost
	elseif battleItemType == gBattleItemType.TOWER then
		return "~", data.kill, "~", "~"
	end
end
function mailItemDetailFightSingle:convertNumberWithUnit(num, isCeil, decimal)
	local _c = 0.05
	local _d = 1
	if decimal then
		_d = decimal
		_c = 0.05 / 10 ^ (decimal - 1)
	end
	if num == nil then
		return
	end
	if num < 1000000 and -1000000 < num then
		return num
	end
	local value = num / 1000000000
	local temp
	if 1 <= value or value <= -1 then
		temp = string.match(value, "%.%d+")
		if temp and string.len(temp) > 2 then
			if not isCeil then
				value = value - _c
			end
			value = string.format("%." .. _d .. "f", value)
		end
		value = string.formatnumberthousands(value) .. "B"
	else
		value = num / 1000000
		if 1 <= value or value <= -1 then
			temp = string.match(value, "%.%d+")
			if temp and string.len(temp) > 2 then
				if not isCeil then
					value = value - _c
				end
				value = string.format("%." .. _d .. "f", value)
			end
			value = string.formatnumberthousands(value) .. "M"
		end
	end
	return value
end
function mailItemDetailFightSingle:btnClickNumTips(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll) then
			print("node is not on view")
			return
		end
		local panel = SoraDCreatePanel("mailNumTip")
		_ENV = nil
		;(nil)[1] = self:getDetailStr(self.contentData)
		;(nil)[2] = self:getDetailStr(self.contentData)
		;(nil)[3] = self:getDetailStr(self.contentData)
		panel:initData(nil)
		panel:show()
		local oPos = target:getTouchBeganPosition()
		oPos.x = oPos.x + SoraDFPosX(panel.img:getContentSize().width + 10, 0)
		panel.centerNode:setPosition(oPos)
	end
end
function mailItemDetailFightSingle:getItemWidth()
	return self.itemWidth
end
function mailItemDetailFightSingle:getItemHeight()
	return self.itemHeight
end
return mailItemDetailFightSingle
