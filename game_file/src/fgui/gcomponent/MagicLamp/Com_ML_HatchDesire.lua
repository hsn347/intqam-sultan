local baseComponent = require("fgui.base.baseComponent")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local publicRead = include("publicRead")
local magicLampHatchRead = include("magicLampHatchRead")
local Com_ML_HatchDesire = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_HatchDesire", Com_ML_HatchDesire)
function Com_ML_HatchDesire:onInit()
end
function Com_ML_HatchDesire:onShow()
end
function Com_ML_HatchDesire:initData(data, hatchData, chooseItemID)
	self.data = data
	self.hatchData = hatchData
	local realNum = magicLampHatchCtrl:getRealItemNum(hatchData.desireInfo.desire, data.num)
	self.isSelected = data.id == chooseItemID
	self.fields.selected:setVisible(self.isSelected)
	self.fields.item:initData(data.id, realNum)
	self.controllers.c1:setSelectedIndex(self.isLocked and 1 or 0)
end
function Com_ML_HatchDesire:setClickCallback(clickCallback)
	if self.isSelected then
		return
	end
	self.fields.item:setClickCallback(function()
		if self.isLocked then
			self = nil
			;(nil).name = magicLampHatchRead.getHatchName(self.hatchData.id)
			;(nil).lv = self.data.lv
			;(nil).item = publicRead.getName(self.data.id)
			SoraDShowMsgTip(i18n("Jinn_hatch_text_10", nil))
			return
		end
		if clickCallback then
			clickCallback(self.fields.item)
		end
	end)
end
return Com_ML_HatchDesire
