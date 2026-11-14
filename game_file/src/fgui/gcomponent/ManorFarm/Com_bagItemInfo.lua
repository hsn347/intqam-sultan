local publicRead = include("publicRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_bagItemInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/Com_bagItemInfo", Com_bagItemInfo)
function Com_bagItemInfo:onInit()
	self.fields.Button_use:addClickListener(handler(self, self.onClickButton_use))
	self.fields.Button_use:setTitle(i18n("common_text_314"))
	self.fields.comSlider:setSliderCallBack(handler(self, self.onSliderChange))
end
function Com_bagItemInfo:onShow()
end
function Com_bagItemInfo:onClickButton_use()
	SoraDPlaySound()
	if self.data then
		manorCityCtrl:reqFarmlandUseSeedPack(self.data.data.itemId, self.fields.comSlider:getSliderCurValue())
		SoraDShowLoading(uiManager:getProxy("FarmBag").view, nil, gCmd.REQ_GARDEN_FARMLAND_USE_SEEDPACK)
	end
end
function Com_bagItemInfo:onSliderChange(value)
end
function Com_bagItemInfo:initData(data)
	dump(data, "==Com_bagItemInfo:initData==")
	self.data = data
	local curPosX = data.data.curPosX
	self.fields.Image_arr:setPositionX(curPosX)
	local itemId = data.data.itemId
	local name = publicRead.getName(itemId)
	self.fields.Text_title:setString(name)
	local des = publicRead.getDes(itemId)
	self.fields.Text_des:setString(des)
	if serviceFunctions.getIDType(itemId) == gIDType.GARDEN_FARM_SEED_BAG then
		self.controllers.ctrlUse:setSelectedIndex(1)
		_ENV = 1
		;(1).maxValue = manorCityCtrl:getBagSeedInfo(itemId).count
		;(1).minValue = 1
		;(1).curValue = 1
		;(1).allowZero = false
		self.fields.comSlider:initData(1)
	else
		self.controllers.ctrlUse:setSelectedIndex(0)
	end
	self:EnsureBoundsCorrect()
end
return Com_bagItemInfo
