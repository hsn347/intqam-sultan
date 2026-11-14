local baseComponent = require("fgui.base.baseComponent")
local Com_HV_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildMedicalTent/Com_HV_single", Com_HV_single)
local armyDes = include("armyDesRead")
function Com_HV_single:onInit()
	self:fixChildrenPos()
	self.tableSoldier, _ENV = self.fixChildrenPos, self.fixChildrenPos
	self.singleIsMoved = false
	self.sliderChangeBack = nil
	self.fields.btnHead:addEventListener(fgui.UIEventType.Click, handler(self, self.btnHeadClick))
	self.fields.slider:setSliderCallBack(handler(self, self.sliderChange))
	self.fields.slider:setInpuBoxFixPos(-180, -180, -75)
end
function Com_HV_single:onShow()
end
function Com_HV_single:initData(itemData)
	self.tableSoldier = itemData
	self.fields.imgLV:setURL(armyDes.getLvImg(self.tableSoldier.id))
	self.fields.txtSoldier:setString(armyDes.getName(self.tableSoldier.id))
	self.fields.btnHead:setURL(armyDes.getIcon(self.tableSoldier.id))
	if self.fields.spriteWarLv then
		self.fields.spriteWarLv:setVisible(armyDes.getWarLv(self.tableSoldier.id) > 0)
		self.fields.spriteWarLv:setTitle(armyDes.getWarLv(self.tableSoldier.id))
	end
	armyDes = armyDes.getWarLv(self.tableSoldier.id)
	armyDes.getWarLv(self.tableSoldier.id).maxValue = self.tableSoldier.num
	armyDes.getWarLv(self.tableSoldier.id).minValue = 0
	armyDes.getWarLv(self.tableSoldier.id).curValue = self.tableSoldier.cur
	self.fields.slider:initData(armyDes.getWarLv(self.tableSoldier.id))
	self.fields.slider:setMinValue(0)
end
function Com_HV_single:setCurVal(itemData)
	local nowCurValue = self.fields.slider:getSliderCurValue()
	if nowCurValue ~= itemData.cur or self.slider.maxValue ~= itemData.num then
		_UPVALUE0_ = nil
		;(nil).maxValue = itemData.num
		;(nil).minValue = 0
		;(nil).curValue = itemData.cur
		self.fields.slider:initData(nil)
	end
end
function Com_HV_single:setSliderChangeBack(handl)
	self.sliderChangeBack = handl
end
function Com_HV_single:sliderChange(num)
	if self.sliderChangeBack then
		_UPVALUE0_ = nil
		;(nil).index = self.tableSoldier.index
		;(nil).id = self.tableSoldier.id
		;(nil).cur = num
		self.sliderChangeBack(nil)
	end
end
function Com_HV_single:btnHeadClick(button, type)
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier(true) then
		worldMapDefine.showWarTips()
		return
	end
	local armyLogic = include("armyLogic")
	local bid = armyDes.getBuildID(self.tableSoldier.id)
	local soldierList, curIndex = armyLogic.getCanTrainList(bid)
	local curLv = armyLogic.getArmyLV(self.tableSoldier.id)
	local maxLv = armyLogic.getArmyLV(soldierList[curIndex].armyid)
	if maxLv <= curLv + 1 then
		SoraDShowMsgBox(i18n("common_text_2564"), i18n("common_text_204"))
		return
	end
	local proxy = uiManager:show("HospitalDismissView")
	proxy:initData(self.tableSoldier)
	_ENV = i18n("common_text_204")
	i18n("common_text_204").name = self.fields.txtSoldier:getText()
	proxy:setTitle(i18n("common_text_406", i18n("common_text_204")))
end
return Com_HV_single
