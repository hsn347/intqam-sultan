local armyDes = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local worldDispatchArmySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperorOfficer/worldDispatchArmySingle", worldDispatchArmySingle)
fgui.register_extension("ui://NebulaEmperorOfficer/Reborn_armySingle", worldDispatchArmySingle)
function worldDispatchArmySingle:onInit()
	self.fields.Com_army:addClickListener(handler(self, self.onClickBtnItem))
	self.fields.slider:setSliderCallBack(handler(self, self.sliderChange))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function worldDispatchArmySingle:onShow()
end
function worldDispatchArmySingle:onClickBtnItem(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).armyID = self.tableSoldier.armyid
	uiManager:show("soldiersInfoTipView", nil)
end
function worldDispatchArmySingle:initData(itemData)
	self.tableSoldier = itemData
	self.fields.Text_name:setString(armyDes.getName(self.tableSoldier.armyid))
	self.fields.Com_army:initData(self.tableSoldier.armyid)
	armyDes = self.tableSoldier.armyid
	self.tableSoldier.armyid.maxValue = self.tableSoldier.armycount
	self.tableSoldier.armyid.minValue = 0
	self.tableSoldier.armyid.curValue = self.tableSoldier.curCount
	self.fields.slider:initData(self.tableSoldier.armyid)
	self.fields.slider:setMinValue(0)
end
function worldDispatchArmySingle:setSliderChangeBack(handl)
	self.sliderChangeBack = handl
end
function worldDispatchArmySingle:sliderChange(num)
	if self.sliderChangeBack then
		_UPVALUE0_ = nil
		;(nil).armyid = self.tableSoldier.armyid
		;(nil).armycount = num
		self.sliderChangeBack(self, nil)
	end
end
return worldDispatchArmySingle
