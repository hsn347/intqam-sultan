local baseComponent = require("fgui.base.baseComponent")
local Com_ArmySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonDispatch/Com_ArmySingle", Com_ArmySingle)
function Com_ArmySingle:onInit()
	self:fixChildrenPos()
	self.fields.Load_cellHead:addClickListener(handler(self, self.OnBtnItemClick))
	self.fields.Com_Slide:setSliderCallBack(handler(self, self.sliderChange))
end
function Com_ArmySingle:onShow()
end
function Com_ArmySingle:initData(itemData, index)
	if itemData == nil then
		return
	end
	local armyDes = include("armyDesRead")
	self.tableSoldier = itemData
	self.index = index
	self.fields.Text_name:setString(armyDes.getName(self.tableSoldier.armyid))
	self.fields.Load_cellHead:setURL(armyDes.getIcon(self.tableSoldier.armyid))
	self.fields.Sprite_armyLevel:setURL(armyDes.getLvImg(self.tableSoldier.armyid))
	self.fields.Text_cellTxtWarLv:setVisible(armyDes.getWarLv(self.tableSoldier.armyid) > 0)
	self.fields.Text_cellTxtWarLv:setString(armyDes.getWarLv(self.tableSoldier.armyid))
	dump(self.tableSoldier, "self.tableSoldier===")
	_ENV = "self.tableSoldier==="
	;("self.tableSoldier===").maxValue = self.tableSoldier.armycount
	;("self.tableSoldier===").minValue = 0
	;("self.tableSoldier===").curValue = self.tableSoldier.curCount
	;("self.tableSoldier===").notBack = true
	self.fields.Com_Slide:initData("self.tableSoldier===")
	if self.tableSoldier.sliderChangeHandle then
		self:setSliderChangeBack(self.tableSoldier.sliderChangeHandle)
	end
	self.fields.Com_Slide:setMinValue(0)
	print("self.tableSoldier.curCount", self.tableSoldier.curCount)
	_ENV = self.tableSoldier.curCount
	self.tableSoldier.curCount.notBack = true
	self.fields.Com_Slide:setSliderCurValue(self.tableSoldier.curCount, self.tableSoldier.curCount)
	self.fields.Com_Slide:setText("/" .. self.tableSoldier.armycount)
	self:setLock(itemData.isForbid, itemData.forbidType)
end
function Com_ArmySingle:setLock(lock, lockType)
	self.controllers.c1:setSelectedIndex(lock and 1 or 0)
	if lock then
		local lockStr
		if lockType == 1 then
			lockStr = i18n("atlantiswar_text_0299")
		else
			lockStr = i18n("common_text_4526")
		end
		self.fields.Text_lock:setString(lockStr)
	end
end
function Com_ArmySingle:getMaxNum()
	return self.tableSoldier.armycount
end
function Com_ArmySingle:getCurNum()
	return self.tableSoldier.curCount
end
function Com_ArmySingle:setSliderChangeBack(handl)
	self.sliderChangeBack = handl
end
function Com_ArmySingle:sliderChange(num)
	if self.sliderChangeBack then
		_UPVALUE0_ = nil
		;(nil).armyid = self.tableSoldier.armyid
		;(nil).armycount = num
		;(nil).index = self.index
		return self.sliderChangeBack(self, nil)
	end
end
function Com_ArmySingle:updateView()
	if not self.tableSoldier then
		return
	end
	_UPVALUE0_ = nil
	;(nil).notBack = true
	self.fields.Com_Slide:setSliderCurValue(self.tableSoldier.curCount, nil)
end
function Com_ArmySingle:setCurVal(num, otherData)
	self.fields.Com_Slide:setSliderCurValue(num, otherData)
end
function Com_ArmySingle:OnBtnItemClick(button, type)
	if not (not tolua.isnull(self) and self.tableSoldier) or self.tableSoldier.armyid == nil then
		return
	end
	self:stopAllActions()
	_ENV = self
	self.msg = "MESSAGE_WORLD_MAP_ARMY_INFO_CLOSE"
	SoraDSendMessage(self)
	SoraDPlaySound()
	_ENV = nil
	;(nil).armyID = self.tableSoldier.armyid
	uiManager:show("soldiersInfoTipView", nil)
end
return Com_ArmySingle
